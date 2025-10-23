import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/unified_map_view.dart';
import '../../../domain/models/cart.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/via/via_toast.dart';
import '../controllers/live_map_controller.dart';
import '../widgets/map_controls.dart';
import '../widgets/cart_list_vertical.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/tone_control_slider.dart';
import '../widgets/micro_tag.dart';
import '../widgets/marker_overlay_tag.dart';
import '../widgets/via_filter_sheet.dart';
import '../widgets/via_status_bar.dart';
import '../state/realtime_map_state.dart';
import '../../../core/services/map/map_adapter.dart';
import '../../../core/services/map/golf_course_route_provider.dart';
import '../../../core/services/mock/mock_api.dart';

class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({super.key});

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> {
  final TextEditingController _searchController = TextEditingController();
  bool _showToneSlider = false;
  bool _cartListOnRight = false;
  bool _compactDensity = true;
  bool _cartListCollapsed = false;
  final GlobalKey<UnifiedMapViewState> _mapKey = GlobalKey<UnifiedMapViewState>();
  bool _isSatelliteUI = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(golfCourseRouteProvider.notifier).loadRoute();
      try {
        await MockApi().updateCartPositionsAlongRoute();
        await MockApi().updateAllTelemetryPositions();
        final updatedCarts = await MockApi().getCarts();
        ref.read(liveMapControllerProvider.notifier).updateCarts(updatedCarts);
      } catch (e) {
        print('Failed to update cart positions: $e');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final mapState = ref.watch(liveMapControllerProvider);
    final mapController = ref.read(liveMapControllerProvider.notifier);
    final realtimeMapState = ref.watch(realtimeMapStateProvider);

    // Detect mobile vs desktop
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return RawKeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKey: _handleKeyPress,
      child: Scaffold(
        key: _scaffoldKey,
            backgroundColor: DesignTokens.bgPrimary,
            appBar: ProfessionalAppBar(
          title: localizations.navRealTime,
              showBackButton: false,
              showMenuButton: true,
          showNotificationButton: false,
          notificationBadgeCount: 0,
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: SingleChildScrollView(
              child: const HamburgerMenu(),
            ),
          ),
            ),
            body: Column(
              children: [
                ViaStatusBar(
                  statusCounts: mapController.statusCounts,
                  activeFilters: mapState.statusFilters,
                  onFilterTap: mapController.toggleStatusFilter,
                  onOpenFilter: () => _showFilterSheet(context, mapController, mapState),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      UnifiedMapView(
                        key: _mapKey,
                        carts: mapController.filteredCarts,
                    onCartTap: (cart) => _onCartSelected(cart),
                        initialCameraPosition: mapState.cameraPosition,
                        onCameraChanged: mapController.setCameraPosition,
                        mapOpacity: mapState.mapOpacity,
                        isSatellite: _isSatelliteUI,
                    selectedCartId: realtimeMapState.selectedCartId,
                  ),

                  // Desktop: Use floating cart list
                  if (!isMobile)
                    CartListVertical(
                      carts: mapController.filteredCarts,
                      selectedCartId: realtimeMapState.selectedCartId,
                      compactDensity: _compactDensity,
                      cartListOnRight: _cartListOnRight,
                      isCollapsed: _cartListCollapsed,
                      onCartSelected: (cart) => _onCartSelected(cart),
                      onToggleCollapse: () => setState(() => _cartListCollapsed = !_cartListCollapsed),
                    ),

                  MapControls(
                    onZoomIn: () => _zoomIn(mapController, mapState),
                    onZoomOut: () => _zoomOut(mapController, mapState),
                    onToneToggle: () => setState(() => _showToneSlider = !_showToneSlider),
                    onLayerToggle: _toggleLayer,
                    onMyLocation: _showMyLocationMessage,
                    onFullscreen: _showFullscreenMessage,
                    isSatelliteUI: _isSatelliteUI,
                  ),
                  if (_showToneSlider)
                    ToneControlSlider(
                      mapOpacity: mapState.mapOpacity,
                      onOpacityChanged: mapController.setMapOpacity,
                    ),
                  // Micro tag overlay for selected cart
                  if (realtimeMapState.selectedCartId != null)
                    _buildMicroTagOverlay(realtimeMapState.selectedCartId!, mapController.filteredCarts),

                  // Mobile: Use bottom sheet
                  if (isMobile)
                    CartBottomSheet(
                      carts: mapController.filteredCarts,
                      selectedCartId: realtimeMapState.selectedCartId,
                      onCartSelected: (cart) => _onCartSelected(cart),
                    ),
                ],
              ),
            ),
              ],
            ),
          ),
    );
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;
    final key = event.logicalKey;
    final mapState = ref.read(liveMapControllerProvider);
    final mapController = ref.read(liveMapControllerProvider.notifier);

    if (key == LogicalKeyboardKey.add || (key == LogicalKeyboardKey.equal && event.isShiftPressed)) {
      _zoomIn(mapController, mapState);
    } else if (key == LogicalKeyboardKey.minus) {
      _zoomOut(mapController, mapState);
    } else if (key == LogicalKeyboardKey.keyT) {
      _toggleLayer();
    } else if (key == LogicalKeyboardKey.keyL) {
      _showMyLocationMessage();
    } else if (key == LogicalKeyboardKey.keyF) {
      _showFullscreenMessage();
    }
  }

  void _zoomIn(LiveMapController controller, mapState) {
    final currentZoom = mapState.cameraPosition.zoom;
    final newZoom = (currentZoom + 1).clamp(1.0, 20.0);
    final newCameraPosition = CameraPosition(
      center: mapState.cameraPosition.center,
      zoom: newZoom,
      bearing: mapState.cameraPosition.bearing,
      tilt: mapState.cameraPosition.tilt,
    );
    controller.setCameraPosition(newCameraPosition);
  }

  void _zoomOut(LiveMapController controller, mapState) {
    final currentZoom = mapState.cameraPosition.zoom;
    final newZoom = (currentZoom - 1).clamp(1.0, 20.0);
    final newCameraPosition = CameraPosition(
      center: mapState.cameraPosition.center,
      zoom: newZoom,
      bearing: mapState.cameraPosition.bearing,
      tilt: mapState.cameraPosition.tilt,
    );
    controller.setCameraPosition(newCameraPosition);
  }

  void _toggleLayer() {
    setState(() {
      _isSatelliteUI = !_isSatelliteUI;
    });
  }

  void _showMyLocationMessage() {
    ViaToast.show(
      context: context,
      message: '내 위치 기능은 플랫폼별 권한 설정 후 활성화됩니다.',
      variant: ViaToastVariant.info,
    );
  }

  void _showFullscreenMessage() {
    ViaToast.show(
      context: context,
      message: '전체화면 토글은 플랫폼별 API 연동 후 활성화됩니다.',
      variant: ViaToastVariant.info,
    );
  }

  void _showFilterSheet(BuildContext context, LiveMapController controller, mapState) {
    ViaFilterSheet.show(
      context: context,
      activeFilters: mapState.statusFilters,
      onFilterToggle: controller.toggleStatusFilter,
      onClearFilters: controller.clearFilters,
    );
  }

  void _onCartSelected(Cart cart) {
    final realtimeMapState = ref.read(realtimeMapStateProvider);
    final mapController = ref.read(liveMapControllerProvider.notifier);
    
    print('Cart selected: ${cart.id}');
    print('Current carts count: ${mapController.filteredCarts.length}');
    print('Cart position: ${cart.position}');
    
    // Toggle selection if same cart is tapped
    if (realtimeMapState.selectedCartId == cart.id) {
      realtimeMapState.clearSelection();
      print('Cart deselected: ${cart.id}');
    } else {
      realtimeMapState.selectCart(cart.id);
      print('Cart selected: ${cart.id}');
      
      // Focus on cart with offset - only if position is valid
      if (cart.position != null && cart.position!.latitude != 0 && cart.position!.longitude != 0) {
        print('Focusing on cart position: ${cart.position}');
        _focusOnCart(cart.position!);
      } else {
        print('Invalid cart position, skipping focus');
      }
    }
  }

  Future<void> _focusOnCart(LatLng position) async {
    final mapController = ref.read(liveMapControllerProvider.notifier);
    await mapController.focusOn(position);
  }

  Widget _buildMicroTagOverlay(String selectedCartId, List<Cart> carts) {
    final selectedCart = carts.firstWhere((cart) => cart.id == selectedCartId);
    if (selectedCart.position == null) return const SizedBox.shrink();

    // Calculate badge for battery <= 30% or charging
    String? badge;
    final batteryPct = selectedCart.batteryPct?.toInt() ?? 0;
    final isCharging = selectedCart.status == CartStatus.charging;
    
    if (batteryPct <= 30 || isCharging) {
      badge = isCharging ? 'Charging' : '$batteryPct%';
    }

    return MarkerOverlayTag(
      controller: _mapKey.currentState?.getGoogleMapController(),
      position: google.LatLng(selectedCart.position!.latitude, selectedCart.position!.longitude),
      child: MicroTag(
        id: selectedCart.id,
        badge: badge,
      ),
    );
  }
}