import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/status_bar.dart' as status_bar;
import '../../../core/widgets/filter_sheet.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/unified_map_view.dart';
import '../../../domain/models/cart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/live_map_controller.dart';
import '../widgets/route_info_card.dart';
import '../../../core/services/map/golf_course_route_provider.dart';
import '../../../core/services/mock/mock_api.dart';

class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({super.key});

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> {
  final TextEditingController _searchController = TextEditingController();
  Cart? _selectedCart;
  bool _showToneSlider = false;

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() async {
      // Load route first
      ref.read(golfCourseRouteProvider.notifier).loadRoute();
      
      // Update cart positions on route
      try {
        await MockApi().updateCartPositionsAlongRoute();
        
        // Update telemetry data with new positions
        await MockApi().updateAllTelemetryPositions();
        
        // Refresh cart data in the controller
        final updatedCarts = await MockApi().getCarts();
        ref.read(liveMapControllerProvider.notifier).updateCarts(updatedCarts);
        print('Updated ${updatedCarts.length} carts to route positions with telemetry data');
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
    
    // Debug: Check cart count
    print('LiveMapView - Filtered carts: ${mapController.filteredCarts.length}');

    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      appBar: ProfessionalAppBar(
        title: localizations.navRealTime,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: true,
        notificationBadgeCount: 3, // Mock count
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: Icons.filter_list,
            onPressed: () => _showFilterSheet(context, mapController, mapState),
          ),
        ],
      ),
      body: Column(
        children: [
          // Map View
          Expanded(
            child: Stack(
              children: [
                // Unified Map
                UnifiedMapView(
                  carts: mapController.filteredCarts,
                  onCartTap: (cart) => _showCartPopover(context, cart),
                  initialCameraPosition: mapState.cameraPosition,
                  onCameraChanged: mapController.setCameraPosition,
                  mapOpacity: mapState.mapOpacity,
                ),

                // Search Bar with Glass Morphism
                Positioned(
                  top: DesignTokens.spacingMd,
                  left: DesignTokens.spacingMd,
                  right: DesignTokens.spacingMd,
                  child: _buildSearchBar(mapController),
                ),

                // Cart List
                Positioned(
                  bottom: DesignTokens.spacingMd,
                  left: DesignTokens.spacingMd,
                  right: DesignTokens.spacingMd,
                  child: _buildCartList(mapController),
                ),

                // Zoom Controls
                Positioned(
                  right: DesignTokens.spacingMd,
                  top: 80, // Below search bar
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: () {
                          final currentZoom = mapState.cameraPosition.zoom;
                          final newZoom = (currentZoom * 1.2).clamp(10.0, 20.0);
                          mapController.setZoom(newZoom);
                        },
                        backgroundColor:
                            DesignTokens.bgSecondary.withValues(alpha: 0.8),
                        child: const Icon(Icons.add,
                            color: DesignTokens.textPrimary),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          final currentZoom = mapState.cameraPosition.zoom;
                          final newZoom = (currentZoom / 1.2).clamp(10.0, 20.0);
                          mapController.setZoom(newZoom);
                        },
                        backgroundColor:
                            DesignTokens.bgSecondary.withValues(alpha: 0.8),
                        child: const Icon(Icons.remove,
                            color: DesignTokens.textPrimary),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      FloatingActionButton.small(
                        heroTag: 'tone_control',
                        onPressed: () {
                          setState(() {
                            _showToneSlider = !_showToneSlider;
                          });
                        },
                        backgroundColor:
                            DesignTokens.bgSecondary.withValues(alpha: 0.8),
                        child: const Icon(Icons.palette,
                            color: DesignTokens.textPrimary),
                      ),
                    ],
                  ),
                ),

                // Tone Control Slider
                if (_showToneSlider)
                  Positioned(
                    right: 80, // To the left of the tone button
                    top: 80,
                    child: Container(
                      padding: const EdgeInsets.all(8), // Tighter padding
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusMd), // Sharper corners
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tone',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11, // Smaller font
                              fontWeight: FontWeight.w700, // Bolder
                              letterSpacing: DesignTokens.letterSpacingNormal, // Tighter tracking
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            width: 40,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: mapState.mapOpacity,
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                onChanged: (value) {
                                  mapController.setMapOpacity(value);
                                },
                                activeColor: Colors.white,
                                inactiveColor:
                                    Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          Text(
                            '${(mapState.mapOpacity * 100).round()}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9, // Smaller font
                              fontWeight: FontWeight.w700, // Bolder
                              letterSpacing: DesignTokens.letterSpacingTight, // Tighter tracking
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Route Info Card
                Positioned(
                  top: 120, // 검색바 아래 더 여유있게 배치
                  left: DesignTokens.spacingMd,
                  child: RouteInfoCard(),
                ),

                // Cart Popover
                if (_selectedCart != null)
                  Positioned(
                    top: 100,
                    left: 16,
                    right: 16,
                    child: _buildCartPopover(
                        context, _selectedCart!, mapController),
                  ),
              ],
            ),
          ),

          // Status Bar
          status_bar.StatusBar(
            statusCounts: mapController.statusCounts,
            activeFilters: mapState.statusFilters,
            onFilterTap: mapController.toggleStatusFilter,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showSearchDialog(BuildContext context, LiveMapController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Search Carts',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search by ID, model, or location...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: controller.setSearchQuery,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              controller.setSearchQuery('');
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(
      BuildContext context, LiveMapController controller, mapState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        activeFilters: mapState.statusFilters,
        onFilterToggle: controller.toggleStatusFilter,
        onClearFilters: controller.clearFilters,
      ),
    );
  }

  void _showCartPopover(BuildContext context, Cart cart) {
    setState(() {
      _selectedCart = cart;
    });
  }

  Widget _buildCartPopover(
      BuildContext context, Cart cart, LiveMapController controller) {
    final localizations = AppLocalizations.of(context);
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12), // Tighter padding
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg), // Sharper corners
        border: Border.all(
          color: DesignTokens.borderPrimary, // More subtle border
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // More subtle shadow
            blurRadius: 6, // Reduced blur
            offset: const Offset(0, 2), // Reduced offset
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 8, // Smaller indicator
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6), // Tighter spacing
              Expanded(
                child: Text(
                  cart.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: DesignTokens.letterSpacingNormal, // Tighter tracking
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => setState(() => _selectedCart = null),
              ),
            ],
          ),

          const SizedBox(height: 8), // Tighter spacing

          // Cart Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart.model,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700, // Bolder for hierarchy
                        color: Colors.white,
                        letterSpacing: DesignTokens.letterSpacingNormal, // Tighter tracking
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cart.location?.toString() ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              CartStatusChip(status: cart.status),
            ],
          ),

          const SizedBox(height: 12), // Tighter spacing

          // Telemetry Info
          Row(
            children: [
              Expanded(
                child: TelemetryWidget(
                  label: 'Battery',
                  value: cart.batteryPct ?? 0.0,
                  unit: '%',
                  color: (cart.batteryPct ?? 0) > 50
                      ? Colors.green
                      : (cart.batteryPct ?? 0) > 20
                          ? Colors.orange
                          : Colors.red,
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TelemetryWidget(
                  label: 'Speed',
                  value: cart.speedKph ?? 0.0,
                  unit: 'km/h',
                  isCompact: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12), // Tighter spacing

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: localizations.details,
                  onPressed: () {
                    context.go('/rt/cart/${cart.id}');
                    setState(() => _selectedCart = null);
                  },
                  type: ActionButtonType.secondary,
                  icon: Icons.info_outline,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
                  text: localizations.track,
                  onPressed: () {
                    controller.navigateToCartTracking(cart.id);
                    setState(() => _selectedCart = null);
                  },
                  type: ActionButtonType.primary,
                  icon: Icons.my_location,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(LiveMapController controller) {
    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.bgPrimary.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: DesignTokens.textPrimary,
          fontSize: DesignTokens.fontSizeMd,
        ),
        decoration: InputDecoration(
          hintText: 'Search carts...',
          hintStyle: TextStyle(
            color: DesignTokens.textTertiary,
            fontSize: DesignTokens.fontSizeMd,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: DesignTokens.textSecondary,
            size: DesignTokens.iconMd,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: DesignTokens.textSecondary,
                    size: DesignTokens.iconSm,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    controller.clearSearch();
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: DesignTokens.textSecondary,
                    size: DesignTokens.iconSm,
                  ),
                  onPressed: () => _showFilterSheet(context, controller,
                      ref.watch(liveMapControllerProvider)),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingSm,
          ),
        ),
        onChanged: (value) {
          controller.searchCarts(value);
        },
      ),
    );
  }

  void _showHamburgerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const HamburgerMenu(      ),
    );
  }

  Widget _buildCartList(LiveMapController controller) {
    final carts = controller.filteredCarts;
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Text(
              '카트 목록 (${carts.length})',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                fontWeight: FontWeight.w600,
                color: DesignTokens.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];
                return _buildCartCard(cart, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartCard(Cart cart, LiveMapController controller) {
    final isSelected = _selectedCart?.id == cart.id;
    
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: isSelected 
          ? DesignTokens.statusActive.withValues(alpha: 0.1)
          : DesignTokens.bgTertiary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: isSelected 
          ? Border.all(color: DesignTokens.statusActive, width: 2)
          : null,
      ),
      child: InkWell(
        onTap: () => _onCartSelected(cart, controller),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCartStatusIcon(cart.status),
                    size: 16,
                    color: _getCartStatusColor(cart.status),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      cart.id,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXs,
                        fontWeight: FontWeight.w600,
                        color: DesignTokens.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                cart.model ?? 'Unknown',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXs,
                  color: DesignTokens.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.battery_std,
                    size: 12,
                    color: _getBatteryColor(cart.batteryPct),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${cart.batteryPct?.toStringAsFixed(0) ?? '0'}%',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      color: _getBatteryColor(cart.batteryPct),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCartSelected(Cart cart, LiveMapController controller) {
    setState(() {
      _selectedCart = cart;
    });
    
    // Center map on selected cart
    if (cart.position != null) {
      controller.centerOnCart(cart);
    }
  }

  IconData _getCartStatusIcon(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return Icons.play_circle_filled;
      case CartStatus.idle:
        return Icons.pause_circle_filled;
      case CartStatus.charging:
        return Icons.battery_charging_full;
      case CartStatus.maintenance:
        return Icons.build;
      case CartStatus.offline:
        return Icons.offline_bolt;
      default:
        return Icons.help_outline;
    }
  }

  Color _getCartStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return Colors.green;
      case CartStatus.idle:
        return Colors.orange;
      case CartStatus.charging:
        return Colors.blue;
      case CartStatus.maintenance:
        return Colors.purple;
      case CartStatus.offline:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getBatteryColor(double? batteryPct) {
    if (batteryPct == null) return Colors.grey;
    if (batteryPct > 50) return Colors.green;
    if (batteryPct > 20) return Colors.orange;
    return Colors.red;
  }
}
