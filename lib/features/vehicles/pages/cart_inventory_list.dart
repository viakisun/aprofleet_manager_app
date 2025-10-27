import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/cart.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/filter_sheet.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/widgets/custom_icons.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_toast.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../core/widgets/via/via_button.dart';
import '../../../core/widgets/via/via_input.dart';
import '../controllers/cart_inventory_controller.dart';
import '../widgets/cart_grid_item.dart';
import '../widgets/inventory_stats_bar.dart';
import '../widgets/admin_cart_card.dart';

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
      backgroundColor: IndustrialDarkTokens.bgBase,
      appBar: ProfessionalAppBar(
        title: localizations.navCartManagement,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: true,
        notificationBadgeCount: 3, // Mock count
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: Icons.route, // 경로 아이콘
            onPressed: () => _goToRouteView(context),
          ),
          AppBarActionButton(
            icon: CustomIcons.search,
            onPressed: () => _showSearchDialog(context, inventoryController),
          ),
          AppBarActionButton(
            icon: CustomIcons.filter,
            onPressed: () =>
                _showFilterSheet(context, inventoryController, inventoryState),
          ),
          AppBarActionButton(
            icon: _viewMode == ViewMode.list
                ? CustomIcons.grid
                : CustomIcons.list,
            onPressed: () {
              setState(() {
                _viewMode =
                    _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
              });
            },
          ),
          AppBarActionButton(
            icon: CustomIcons.add,
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
    final inventoryState = ref.watch(cartInventoryControllerProvider);
    return inventoryState.carts.when(
      data: (carts) => InventoryStatsBar(carts: carts),
      loading: () => Container(
        height: 80,
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        height: 80,
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
        child: Text('Error loading stats: $error'),
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
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return AdminCartCard(
          cart: cart,
          isSelected: _selectedCarts.contains(cart.id),
          onTap: () => _handleCartTap(cart),
          onTrack: () => context.go('/rt/cart/${cart.id}'),
          onService: () => _showServiceSheet(cart),
          onWorkOrder: () => context.go('/mm/create?cart=${cart.id}'),
        );
      },
    );
  }

  Widget _buildGridView(List<Cart> carts) {
    return GridView.builder(
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: IndustrialDarkTokens.spacingItem,
        mainAxisSpacing: IndustrialDarkTokens.spacingItem,
      ),
      itemCount: carts.length,
      itemBuilder: (context, index) {
        final cart = carts[index];
        return CartGridItem(
          cart: cart,
          isSelected: _selectedCarts.contains(cart.id),
          onTap: () => _handleCartTap(cart),
          onLongPress: () => _handleCartLongPress(cart),
        );
      },
    );
  }

  Widget _buildSelectionActions(CartInventoryController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
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
                color: Colors.white.withValues(alpha: 0.3),
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
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.4, 0.6],
      header: const Text(
        'Search Carts',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: ViaInput(
        controller: _searchController,
        label: 'Search',
        placeholder: 'Search by ID, model, or location...',
        prefixIcon: Icons.search,
        onChanged: controller.setSearchQuery,
      ),
      footer: Row(
        children: [
          Expanded(
            child: ViaButton.ghost(
              text: 'Clear',
              onPressed: () {
                _searchController.clear();
                controller.setSearchQuery('');
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          Expanded(
            child: ViaButton.primary(
              text: 'Close',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  void _showServiceSheet(Cart cart) {
    final locale = AppLocalizations.of(context);
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.5],
      header: Text(
        '${locale.service} - ${cart.id}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service options for ${cart.model}',
            style: TextStyle(
              fontSize: 14,
              color: IndustrialDarkTokens.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          ViaButton.primary(
            text: locale.createWorkOrder.toUpperCase(),
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/mm/create?cart=${cart.id}');
            },
          ),
          const SizedBox(height: 12),
          ViaButton.ghost(
            text: locale.view.toUpperCase(),
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/rt/cart/${cart.id}');
            },
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
    ViaToast.show(
      context: context,
      message: 'Assigning ${_selectedCarts.length} carts',
      variant: ViaToastVariant.info,
    );
    _clearSelection();
  }

  void _bulkService() {
    // TODO: Implement bulk service
    ViaToast.show(
      context: context,
      message: 'Creating service request for ${_selectedCarts.length} carts',
      variant: ViaToastVariant.info,
    );
    _clearSelection();
  }

  void _bulkExport() {
    // TODO: Implement bulk export
    ViaToast.show(
      context: context,
      message: 'Exporting ${_selectedCarts.length} carts',
      variant: ViaToastVariant.info,
    );
    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedCarts.clear();
      _isSelectionMode = false;
    });
  }

  void _handleCartTap(Cart cart) {
    if (_isSelectionMode) {
      _handleCartSelection(cart);
    } else {
      context.go('/rt/cart/${cart.id}');
    }
  }

  void _handleCartLongPress(Cart cart) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedCarts.add(cart.id);
      });
    }
  }

  void _handleCartSelection(Cart cart) {
    setState(() {
      if (_selectedCarts.contains(cart.id)) {
        _selectedCarts.remove(cart.id);
        if (_selectedCarts.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedCarts.add(cart.id);
      }
    });
  }

  void _goToRouteView(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final inventoryController =
        ref.read(cartInventoryControllerProvider.notifier);

    // Position carts along route
    try {
      await inventoryController.updateCartPositionsAlongRoute();

      // Show success message
      if (context.mounted) {
        ViaToast.show(
          context: context,
          message: localizations.cartsPositionedOnRoute,
          variant: ViaToastVariant.success,
        );
      }

      // Navigate to live map view
      if (context.mounted) {
        context.go('/rt/live');
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ViaToast.show(
          context: context,
          message: '${localizations.cartPositionUpdateFailed}: $e',
          variant: ViaToastVariant.error,
        );
      }
    }
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

enum ViewMode { list, grid }
