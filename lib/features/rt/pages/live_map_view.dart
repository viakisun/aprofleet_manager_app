import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/status_bar.dart';
import '../../../core/widgets/filter_sheet.dart';
import '../../../core/services/map/canvas_map_view.dart';
import '../../../domain/models/cart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import '../controllers/live_map_controller.dart';

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
      appBar: AppBar(
        title: Text(localizations.navRealTime),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, mapController),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
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

                // Zoom Controls
                Positioned(
                  right: 16,
                  top: 16,
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
                        backgroundColor: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          final newZoom = (mapState.zoom / 1.2).clamp(
                            AppConstants.mapZoomMin,
                            AppConstants.mapZoomMax,
                          );
                          mapController.setZoom(newZoom);
                        },
                        backgroundColor: const Color(0xFF1A1A1A),
                        child: const Icon(Icons.remove, color: Colors.white),
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
          StatusBar(
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
}
