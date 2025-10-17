import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/status_bar.dart' as status_bar;
import '../../../core/widgets/filter_sheet.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/canvas_map_view.dart';
import '../../../domain/models/cart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/live_map_controller.dart';
import '../widgets/map_cart_marker.dart';
import '../widgets/map_controls.dart';

class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({super.key});

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> {
  final TextEditingController _searchController = TextEditingController();
  Cart? _selectedCart;

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
                // Canvas Map
                CanvasMapView(
                  carts: mapController.filteredCarts,
                  onCartTap: (cart) => _showCartPopover(context, cart),
                  zoom: mapState.zoom,
                  onZoomChanged: mapController.setZoom,
                  centerOffset: mapState.centerOffset,
                  onCenterChanged: mapController.setCenterOffset,
                ),

                // Search Bar with Glass Morphism
                Positioned(
                  top: DesignTokens.spacingMd,
                  left: DesignTokens.spacingMd,
                  right: DesignTokens.spacingMd,
                  child: _buildSearchBar(mapController),
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
                          final newZoom = (mapState.zoom * 1.2).clamp(
                            AppConstants.mapZoomMin,
                            AppConstants.mapZoomMax,
                          );
                          mapController.setZoom(newZoom);
                        },
                        backgroundColor:
                            DesignTokens.bgSecondary.withOpacity(0.8),
                        child: Icon(Icons.add, color: DesignTokens.textPrimary),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          final newZoom = (mapState.zoom / 1.2).clamp(
                            AppConstants.mapZoomMin,
                            AppConstants.mapZoomMax,
                          );
                          mapController.setZoom(newZoom);
                        },
                        backgroundColor:
                            DesignTokens.bgSecondary.withOpacity(0.8),
                        child:
                            Icon(Icons.remove, color: DesignTokens.textPrimary),
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cart.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => setState(() => _selectedCart = null),
              ),
            ],
          ),

          const SizedBox(height: 12),

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
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cart.location?.toString() ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              CartStatusChip(status: cart.status),
            ],
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 16),

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
        color: DesignTokens.bgSecondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.bgPrimary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
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
          contentPadding: EdgeInsets.symmetric(
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
      builder: (context) => const HamburgerMenu(),
    );
  }
}
