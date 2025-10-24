import 'dart:math' as math;
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/domain/models/alert.dart';

/// 카트의 경로 진행 상태 정보
///
/// 레이스 진행 상황을 추적하기 위한 데이터 모델
class CartProgress {
  /// 카트 정보
  final Cart cart;

  /// 순위 (1위, 2위, 3위...)
  final int rank;

  /// 주행한 거리 (km)
  final double distanceTraveled;

  /// 경로 진행률 (0.0 ~ 1.0)
  final double progressPercentage;

  /// 앞 카트와의 거리 (km)
  /// - 1위 카트는 null
  /// - 2위부터는 앞 카트와의 거리
  final double? distanceToNext;

  /// Alert 정보
  final String? alertId;
  final AlertSeverity? alertSeverity;

  /// 선두 카트 여부
  bool get isLeading => rank == 1;

  /// Alert가 있는 카트 여부
  bool get hasAlert => alertId != null;

  /// 경로상에 있는 카트인지 (오프라인/충전중 제외)
  bool get isOnRoute =>
      cart.status != CartStatus.offline &&
      cart.status != CartStatus.charging;

  CartProgress({
    required this.cart,
    required this.rank,
    required this.distanceTraveled,
    required this.progressPercentage,
    this.distanceToNext,
    this.alertId,
    this.alertSeverity,
  });

  /// 경로상에 있는 카트들만 필터링하여 순위 계산
  static List<CartProgress> calculateProgress({
    required List<Cart> carts,
    required List<double> cumulativeDistances,
    required List<dynamic> routeCoordinates,
    required double totalRouteDistance,
  }) {
    // 1. 경로상에 있는 카트만 필터링 (오프라인/충전중 제외)
    final activeCarts = carts.where((cart) {
      return cart.position != null &&
          cart.status != CartStatus.offline &&
          cart.status != CartStatus.charging;
    }).toList();

    if (activeCarts.isEmpty) {
      return [];
    }

    // 2. 각 카트의 주행 거리 계산 (경로상 가장 가까운 포인트 기준)
    final cartDistances = activeCarts.map((cart) {
      // RouteLoader의 findNearestRoutePoint 대신 여기서 직접 계산
      int nearestIndex = 0;
      double minDistance = double.infinity;

      for (int i = 0; i < routeCoordinates.length; i++) {
        final routePoint = routeCoordinates[i];
        final distance = _calculateDistance(
          cart.position!.latitude,
          cart.position!.longitude,
          routePoint.latitude,
          routePoint.longitude,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestIndex = i;
        }
      }

      return {
        'cart': cart,
        'distance': cumulativeDistances[nearestIndex],
        'routeIndex': nearestIndex,
      };
    }).toList();

    // 3. 주행 거리 기준으로 내림차순 정렬 (가장 많이 진행한 카트가 1위)
    cartDistances.sort((a, b) =>
        (b['distance'] as double).compareTo(a['distance'] as double));

    // 4. CartProgress 리스트 생성
    final progressList = <CartProgress>[];
    for (int i = 0; i < cartDistances.length; i++) {
      final cartData = cartDistances[i];
      final cart = cartData['cart'] as Cart;
      final distance = cartData['distance'] as double;

      // 앞 카트와의 거리 계산 (1위는 null)
      double? distanceToNext;
      if (i > 0) {
        final prevDistance = cartDistances[i - 1]['distance'] as double;
        distanceToNext = prevDistance - distance;
      }

      progressList.add(CartProgress(
        cart: cart,
        rank: i + 1,
        distanceTraveled: distance,
        progressPercentage: distance / totalRouteDistance,
        distanceToNext: distanceToNext,
        alertId: cart.activeAlertId,
        alertSeverity: cart.alertSeverity,
      ));
    }

    return progressList;
  }

  /// Haversine 거리 계산 (km)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = 0.5 -
        0.5 * math.cos(dLat) +
        math.cos(lat1 * 0.017453292519943295) *
            math.cos(lat2 * 0.017453292519943295) *
            (1 - math.cos(dLon)) /
            2;

    return earthRadiusKm * 2 * math.asin(math.sqrt(a));
  }

  static double _toRadians(double degrees) {
    return degrees * 0.017453292519943295; // π / 180
  }

  @override
  String toString() {
    return 'CartProgress(rank: $rank, cart: ${cart.id}, distance: ${distanceTraveled.toStringAsFixed(2)}km, progress: ${(progressPercentage * 100).toStringAsFixed(1)}%)';
  }
}
