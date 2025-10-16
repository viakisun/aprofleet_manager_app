import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import '../controllers/cart_inventory_controller.dart';

class CartInventoryList extends ConsumerStatefulWidget {
  const CartInventoryList({super.key});

  @override
  ConsumerState<CartInventoryList> createState() => _CartInventoryListState();
}

class _CartInventoryListState extends ConsumerState<CartInventoryList> {
  final TextEditingController _searchController = TextEditingController();
  ViewMode _viewMode = ViewMode.list;
  bool _isSelectionMode = false;
  final Set<String> _selectedCarts = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final inventoryState = ref.watch(cartInventoryControllerProvider);
    final inventoryController =
        ref.read(cartInventoryControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.navCartManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, inventoryController),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () =>
                _showFilterSheet(context, inventoryController, inventoryState),
          ),
          IconButton(
            icon:
                Icon(_viewMode == ViewMode.list ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _viewMode =
                    _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/cm/register'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          _buildStatsBar(inventoryController),

          // Cart List/Grid
          Expanded(
            child: inventoryState.carts.when(
              data: (carts) => _buildCartList(carts, inventoryController),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading carts: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(cartsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Selection Actions
          if (_isSelectionMode) _buildSelectionActions(inventoryController),
        ],
      ),
    );
  }

  Widget _buildStatsBar(CartInventoryController controller) {
    final stats = controller.getStats();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildStatChip('Total', stats['total'] ?? 0, Colors.white),
          const SizedBox(width: 12),
          _buildStatChip('Active', stats['active'] ?? 0, Colors.green),
          const SizedBox(width: 12),
          _buildStatChip('Service', stats['maintenance'] ?? 0, Colors.red),
          const SizedBox(width: 12),
          _buildStatChip('Charging', stats['charging'] ?? 0, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(List<Cart> carts, CartInventoryController controller) {
    final filteredCarts = controller.getFilteredCarts(carts);

    if (filteredCarts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No carts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_viewMode == ViewMode.grid) {
      return _buildGridView(filteredCarts);
    } else {
      return _buildListView(filteredCarts);
    }
  }

  Widget _buildListView(List<Cart> carts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return _buildCartCard(cart, index);
      },
    );
  }

  Widget _buildGridView(List<Cart> carts) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return _buildCartGridCard(cart, index);
      },
    );
  }

  Widget _buildCartCard(Cart cart, int index) {
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;
    final isSelected = _selectedCarts.contains(cart.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.06),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSelection(cart.id)
            : () => _showCartActions(context, cart),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  CartStatusChip(status: cart.status),
                  if (_isSelectionMode)
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => _toggleSelection(cart.id),
                      activeColor: Colors.blue,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Cart Info
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
                cart.location ?? 'Unknown Location',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 12),

              // Telemetry Info
              Row(
                children: [
                  Expanded(
                    child: TelemetryWidget(
                      label: 'Battery',
                      value: cart.batteryPct,
                      unit: '%',
                      color: cart.batteryPct > 50
                          ? Colors.green
                          : cart.batteryPct > 20
                              ? Colors.orange
                              : Colors.red,
                      isCompact: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TelemetryWidget(
                      label: 'Speed',
                      value: cart.speedKph,
                      unit: 'km/h',
                      isCompact: true,
                    ),
                  ),
                ],
              ),

              if (!_isSelectionMode) ...[
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Details',
                        onPressed: () => context.go('/cm/profile/${cart.id}'),
                        type: ActionButtonType.secondary,
                        icon: Icons.info_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionButton(
                        text: 'Track',
                        onPressed: () => context.go('/rt/cart/${cart.id}'),
                        type: ActionButtonType.secondary,
                        icon: Icons.my_location,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionButton(
                        text: 'Service',
                        onPressed: () =>
                            context.go('/mm/create?cart=${cart.id}'),
                        type: ActionButtonType.secondary,
                        icon: Icons.build,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartGridCard(Cart cart, int index) {
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;
    final isSelected = _selectedCarts.contains(cart.id);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.06),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSelection(cart.id)
            : () => _showCartActions(context, cart),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      cart.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (_isSelectionMode)
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => _toggleSelection(cart.id),
                      activeColor: Colors.blue,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Model
              Text(
                cart.model,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Status
              CartStatusChip(status: cart.status, isCompact: true),

              const Spacer(),

              // Battery
              Row(
                children: [
                  Icon(
                    Icons.battery_std,
                    size: 12,
                    color: cart.batteryPct > 50
                        ? Colors.green
                        : cart.batteryPct > 20
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${cart.batteryPct.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cart.batteryPct > 50
                          ? Colors.green
                          : cart.batteryPct > 20
                              ? Colors.orange
                              : Colors.red,
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

  Widget _buildSelectionActions(CartInventoryController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedCarts.length} selected',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          ActionButton(
            text: 'Assign',
            onPressed: _selectedCarts.isNotEmpty ? () => _bulkAssign() : null,
            type: ActionButtonType.secondary,
            icon: Icons.assignment_ind,
          ),
          const SizedBox(width: 8),
          ActionButton(
            text: 'Service',
            onPressed: _selectedCarts.isNotEmpty ? () => _bulkService() : null,
            type: ActionButtonType.secondary,
            icon: Icons.build,
          ),
          const SizedBox(width: 8),
          ActionButton(
            text: 'Export',
            onPressed: _selectedCarts.isNotEmpty ? () => _bulkExport() : null,
            type: ActionButtonType.secondary,
            icon: Icons.download,
          ),
        ],
      ),
    );
  }

  void _toggleSelection(String cartId) {
    setState(() {
      if (_selectedCarts.contains(cartId)) {
        _selectedCarts.remove(cartId);
      } else {
        _selectedCarts.add(cartId);
      }

      if (_selectedCarts.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _showCartActions(BuildContext context, Cart cart) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.info_outline, color: Colors.white),
                    title: const Text('View Details',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/cm/profile/${cart.id}');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.my_location, color: Colors.white),
                    title: const Text('Track Location',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/rt/cart/${cart.id}');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.build, color: Colors.white),
                    title: const Text('Request Service',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/mm/create?cart=${cart.id}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(
      BuildContext context, CartInventoryController controller) {
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

  void _showFilterSheet(BuildContext context,
      CartInventoryController controller, inventoryState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        activeFilters: inventoryState.statusFilters,
        onFilterToggle: controller.toggleStatusFilter,
        onClearFilters: controller.clearFilters,
      ),
    );
  }

  void _bulkAssign() {
    // TODO: Implement bulk assign
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assigning ${_selectedCarts.length} carts'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    );
    _clearSelection();
  }

  void _bulkService() {
    // TODO: Implement bulk service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Creating service request for ${_selectedCarts.length} carts'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    );
    _clearSelection();
  }

  void _bulkExport() {
    // TODO: Implement bulk export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_selectedCarts.length} carts'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    );
    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedCarts.clear();
      _isSelectionMode = false;
    });
  }
}

enum ViewMode { list, grid }
