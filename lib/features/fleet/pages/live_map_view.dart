import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/mapbox_map_view.dart';
import '../../../core/services/map/route_loader.dart';
import '../../../core/services/providers.dart';
import '../../../domain/models/cart.dart';
import '../../../domain/models/cart_progress.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../controllers/live_map_controller.dart';
import '../widgets/route_info_header.dart';
import '../widgets/cart_list_bottom_sheet.dart';
import '../widgets/cart_ripple_animation.dart';

/// Live Map View - 새로운 로딩 플로우 구현
///
/// # 로딩 플로우:
///
/// 1. 지구본 스케일로 지도 시작 (MapboxMapView가 globe scale zoom 0에서 시작)
/// 2. 경로 데이터 로딩 (~2초, 스타일리시한 로딩 애니메이션)
/// 3. 경로 로딩 완료 후 MapboxMapView에 경로 전달
/// 4. MapboxMapView가 경로 바운드로 부드럽게 줌인 (2초)
/// 5. 경로와 카트 마커 표시
class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({super.key});

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MapboxMapViewState> _mapKey = GlobalKey<MapboxMapViewState>();

  // 로딩 상태
  bool _isLoadingRoute = true;

  // 로딩된 데이터
  List<Cart> _carts = [];
  List<LatLng>? _routeCoordinates;
  double _totalRouteDistance = 0.0;
  List<CartProgress> _cartProgressList = [];

  // 선택된 카트 (Ripple 애니메이션용)
  Cart? _selectedCart;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. 경로 데이터 먼저 로드
      debugPrint('[LiveMapView] Loading route data...');

      final startTime = DateTime.now();
      final routeCoords = await RouteLoader.loadCourseRoute();

      // 2. 경로 총 거리 계산
      final totalDistance = RouteLoader.calculateTotalDistance(routeCoords);
      final cumulativeDistances =
          RouteLoader.calculateCumulativeDistances(routeCoords);
      debugPrint(
          '[LiveMapView] Route total distance: ${totalDistance.toStringAsFixed(2)} km');

      // 3. 카트 데이터 로드
      final cartsAsync = await ref.read(cartsProvider.future);

      // 4. 카트를 경로상에 무작위로 배치
      _carts = _distributeCartsRandomly(cartsAsync, routeCoords);
      debugPrint(
          '[LiveMapView] Distributed ${_carts.length} carts along route');

      // 5. 카트 진행 상황 계산
      final cartProgressList = CartProgress.calculateProgress(
        carts: _carts,
        cumulativeDistances: cumulativeDistances,
        routeCoordinates: routeCoords,
        totalRouteDistance: totalDistance,
      );
      debugPrint(
          '[LiveMapView] Calculated progress for ${cartProgressList.length} active carts');

      final elapsed = DateTime.now().difference(startTime);
      debugPrint(
          '[LiveMapView] Route loaded: ${routeCoords.length} points in ${elapsed.inMilliseconds}ms');

      // 6. 최소 4초 로딩 시간 보장
      final remainingMs = 4000 - elapsed.inMilliseconds;
      if (remainingMs > 0) {
        debugPrint(
            '[LiveMapView] Waiting ${remainingMs}ms to meet 4-second loading time...');
        await Future.delayed(Duration(milliseconds: remainingMs));
      }

      // 7. 로딩 완료 - MapboxMapView로 경로 전달
      setState(() {
        _routeCoordinates = routeCoords;
        _totalRouteDistance = totalDistance;
        _cartProgressList = cartProgressList;
        _isLoadingRoute = false;
      });

      debugPrint(
          '[LiveMapView] Route loading complete, displaying map with route');
    } catch (e) {
      debugPrint('[LiveMapView] Error loading data: $e');
      setState(() {
        _isLoadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: IndustrialDarkTokens.bgBase,
      appBar: ProfessionalAppBar(
        title: localizations.navRealTime,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: false,
        notificationBadgeCount: 0,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: HamburgerMenu(),
          ),
        ),
      ),
      body: _isLoadingRoute
          ? _buildStylishLoadingView()
          : Stack(
              children: [
                // 지도 뷰
                MapboxMapView(
                  key: _mapKey,
                  carts: _carts,
                  routeCoordinates: _routeCoordinates,
                  onCartTap: (cart) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cart: ${cart.id} - ${cart.status.name}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // 경로 정보 헤더 (상단 오버레이)
                if (_routeCoordinates != null)
                  RouteInfoHeader(
                    routeName: 'Golf Course Route',
                    totalDistance: _totalRouteDistance,
                  ),

                // Ripple 애니메이션 (카트 선택 시)
                if (_selectedCart != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CartRippleAnimation(
                        position: _selectedCart!.position,
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: _isLoadingRoute
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                CartListBottomSheet.show(
                  context,
                  cartProgressList: _cartProgressList,
                  totalRouteDistance: _totalRouteDistance,
                  onCartTap: _handleCartSelection,
                );
              },
              backgroundColor: IndustrialDarkTokens.accentPrimary,
              icon: const Icon(Icons.route, color: Colors.black),
              label: const Text(
                'ON ROUTE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
    );
  }

  /// 스타일리시한 로딩 화면 (모던 디자인)
  Widget _buildStylishLoadingView() {
    return Stack(
      children: [
        // 배경 - 지구본 이미지 또는 어두운 배경
        Container(
          color: IndustrialDarkTokens.bgBase,
        ),

        // 중앙 로딩 애니메이션
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 회전하는 원형 프로그레스 인디케이터
              Stack(
                alignment: Alignment.center,
                children: [
                  // 큰 원 (배경)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: IndustrialDarkTokens.outline,
                        width: 2,
                      ),
                    ),
                  ),

                  // 애니메이션 프로그레스
                  const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        IndustrialDarkTokens.accentPrimary,
                      ),
                    ),
                  ),

                  // 중앙 아이콘
                  const Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: IndustrialDarkTokens.accentPrimary,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 로딩 텍스트
              Text(
                'LOADING ROUTE',
                style: IndustrialDarkTokens.displayStyle.copyWith(
                  fontSize: 18,
                  letterSpacing: 2.4,
                ),
              ),

              const SizedBox(height: 12),

              // 서브 텍스트
              const Text(
                'PREPARING MAP DATA...',
                style: TextStyle(
                  color: IndustrialDarkTokens.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              // 애니메이션 점들 (로딩 중임을 나타냄)
              _buildAnimatedDots(),
            ],
          ),
        ),
      ],
    );
  }

  /// 애니메이션 점들 (로딩 인디케이터)
  Widget _buildAnimatedDots() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final delay = index * 0.2;
            final dotValue = (value - delay).clamp(0.0, 1.0);
            final opacity = (dotValue * 2).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      IndustrialDarkTokens.accentPrimary.withOpacity(opacity),
                ),
              ),
            );
          }),
        );
      },
      onEnd: () {
        // 애니메이션이 끝나면 다시 시작
        if (_isLoadingRoute) {
          setState(() {});
        }
      },
    );
  }

  /// 카트 선택 핸들러 (카메라 센터링 + Ripple 애니메이션)
  Future<void> _handleCartSelection(Cart cart) async {
    debugPrint('[LiveMapView] Cart selected: ${cart.id} at ${cart.position}');

    // 1. 카메라를 카트 위치로 이동 (1.5초)
    await _mapKey.currentState?.animateCameraToCart(cart.position);

    // 2. Ripple 애니메이션 표시 (5초)
    setState(() {
      _selectedCart = cart;
    });

    // 3. 5초 후 Ripple 제거
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        _selectedCart = null;
      });
    }
  }

  /// 카트들을 경로상에 무작위로 배치
  /// - 처음 6개 (APRO-001 ~ APRO-006): 경로상 무작위 포인트에 배치
  /// - 나머지 6개 (APRO-007 ~ APRO-012): 오프라인/충전중 상태로 경로 밖 배치
  List<Cart> _distributeCartsRandomly(List<Cart> carts, List<LatLng> route) {
    if (carts.isEmpty || route.isEmpty) return carts;

    // 6개 포인트를 무작위로 선택 (중복 없이)
    final random = Random();
    final selectedIndices = <int>{};
    while (selectedIndices.length < 6) {
      selectedIndices.add(random.nextInt(route.length));
    }
    final pointIndices = selectedIndices.toList()..sort();

    debugPrint('[LiveMapView] Selected route indices for carts: $pointIndices');

    return carts.asMap().entries.map((entry) {
      final index = entry.key;
      final cart = entry.value;

      if (index < 6) {
        // 처음 6개: 경로상 무작위 포인트에 배치
        final position = route[pointIndices[index]];
        debugPrint(
            '[LiveMapView] Cart ${cart.id} → Route point ${pointIndices[index]}: $position');
        return cart.copyWith(position: position);
      } else {
        // 나머지 6개: 오프라인/충전중 상태로 경로 밖 배치
        final newStatus =
            index.isEven ? CartStatus.offline : CartStatus.charging;
        // 충전소/정비소 위치 (경로 중심에서 약간 떨어진 곳)
        final offlinePosition = LatLng(
          35.9570 + (index - 6) * 0.0002, // 경로 밖
          127.0073 + (index - 6) * 0.0002,
        );
        debugPrint(
            '[LiveMapView] Cart ${cart.id} → Offline/Charging at: $offlinePosition (status: ${newStatus.name})');
        return cart.copyWith(
          status: newStatus,
          position: offlinePosition,
          speed: 0.0,
        );
      }
    }).toList();
  }
}
