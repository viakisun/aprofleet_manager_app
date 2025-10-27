import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import 'package:aprofleet_manager/domain/models/cart_progress.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';

/// 카트 목록 바텀 시트 - 전문가 스타일 디자인
///
/// 카트들의 경로 진행 상황을 시각화하는 고급스러운 드래그 가능 바텀 시트
class CartListBottomSheet extends StatelessWidget {
  /// 카트 진행 상황 목록 (순위순)
  final List<CartProgress> cartProgressList;

  /// 총 경로 거리 (km)
  final double totalRouteDistance;

  /// 카트 탭 콜백 (카트 선택 시 호출)
  final Function(Cart)? onCartTap;

  const CartListBottomSheet({
    super.key,
    required this.cartProgressList,
    required this.totalRouteDistance,
    this.onCartTap,
  });

  /// 바텀 시트 표시
  static void show(
    BuildContext context, {
    required List<CartProgress> cartProgressList,
    required double totalRouteDistance,
    Function(Cart)? onCartTap,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CartListBottomSheet(
        cartProgressList: cartProgressList,
        totalRouteDistance: totalRouteDistance,
        onCartTap: onCartTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: IndustrialDarkTokens.bgSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: IndustrialDarkTokens.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              _buildDragHandle(),

              // 헤더
              _buildHeader(),

              // 카트 목록
              Expanded(
                child: cartProgressList.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: cartProgressList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final progress = cartProgressList[index];
                          return _buildCartProgressCard(progress, context);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 드래그 핸들 (세련된 필 모양)
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [
              IndustrialDarkTokens.accentPrimary.withOpacity(0.3),
              IndustrialDarkTokens.accentPrimary.withOpacity(0.6),
              IndustrialDarkTokens.accentPrimary.withOpacity(0.3),
            ],
          ),
        ),
      ),
    );
  }

  /// 헤더 (제목 + 구분선)
  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.route,
                color: IndustrialDarkTokens.accentPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'CARTS ON ROUTE',
                style: IndustrialDarkTokens.displayStyle.copyWith(
                  fontSize: 16,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // 그라디언트 구분선
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                IndustrialDarkTokens.outline,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 빈 상태 (카트가 없을 때)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: IndustrialDarkTokens.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'NO ACTIVE CARTS',
            style: IndustrialDarkTokens.displayStyle.copyWith(
              fontSize: 14,
              letterSpacing: 1.6,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 카트 진행 카드 (고급스러운 디자인)
  Widget _buildCartProgressCard(CartProgress progress, BuildContext parentContext) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          // 바텀 시트 닫기
          Navigator.pop(parentContext);
          // 카트 탭 콜백 호출
          onCartTap?.call(progress.cart);
        },
        child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: progress.isLeading
                ? IndustrialDarkTokens.accentPrimary.withOpacity(0.5)
                : IndustrialDarkTokens.outline,
            width: progress.isLeading ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 행: 랭킹 배지 + 카트 ID + 리딩 배지
            Row(
              children: [
                // 랭킹 배지
                _buildRankBadge(progress.rank),
                const SizedBox(width: 12),

                // 카트 ID + 상태
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.cart.id,
                        style: IndustrialDarkTokens.displayStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: _getStatusColor(progress.cart.status),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        progress.cart.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 진행 바
            _buildProgressBar(progress),

            const SizedBox(height: 16),

            // 메트릭스 행
            _buildMetricsRow(progress),
          ],
        ),
        ),
      ),
    );
  }

  /// 진행 순서 배지
  Widget _buildRankBadge(int rank) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: IndustrialDarkTokens.bgBase,
        border: Border.all(
          color: IndustrialDarkTokens.accentPrimary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_forward,
            color: IndustrialDarkTokens.accentPrimary,
            size: 14,
          ),
          Text(
            '$rank',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: IndustrialDarkTokens.accentPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// 진행 바 (둥근 캡, 그라디언트)
  Widget _buildProgressBar(CartProgress progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 진행률 레이블
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROGRESS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: IndustrialDarkTokens.textSecondary,
              ),
            ),
            Text(
              '${(progress.progressPercentage * 100).toStringAsFixed(1)}%',
              style: IndustrialDarkTokens.displayStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 진행 바
        Stack(
          children: [
            // 배경 바
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgBase,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: IndustrialDarkTokens.outline,
                  width: 0.5,
                ),
              ),
            ),

            // 진행 바 (애니메이션)
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0.0, end: progress.progressPercentage),
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          _getStatusColor(progress.cart.status).withOpacity(0.6),
                          _getStatusColor(progress.cart.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 메트릭스 행 (아이콘 + 값)
  Widget _buildMetricsRow(CartProgress progress) {
    return Row(
      children: [
        // 주행 거리
        Expanded(
          child: _buildMetric(
            icon: Icons.straighten,
            label: 'TRAVELED',
            value: '${progress.distanceTraveled.toStringAsFixed(2)} KM',
            color: IndustrialDarkTokens.accentPrimary,
          ),
        ),

        // 구분선
        Container(
          width: 1,
          height: 32,
          color: IndustrialDarkTokens.outline,
        ),

        // 앞 카트와의 거리 (2위부터)
        Expanded(
          child: progress.distanceToNext != null
              ? _buildMetric(
                  icon: Icons.trending_down,
                  label: 'TO NEXT',
                  value: '-${progress.distanceToNext!.toStringAsFixed(2)} KM',
                  color: const Color(0xFFFF6B6B),
                )
              : _buildMetric(
                  icon: Icons.check_circle,
                  label: 'STATUS',
                  value: 'FIRST',
                  color: const Color(0xFFFFD700),
                ),
        ),
      ],
    );
  }

  /// 단일 메트릭 (아이콘 + 레이블 + 값)
  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                  color: IndustrialDarkTokens.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: IndustrialDarkTokens.displayStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  /// 상태별 색상 반환
  Color _getStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return IndustrialDarkTokens.statusActive;
      case CartStatus.idle:
        return IndustrialDarkTokens.statusIdle;
      case CartStatus.charging:
        return IndustrialDarkTokens.statusCharging;
      case CartStatus.maintenance:
        return IndustrialDarkTokens.statusMaintenance;
      case CartStatus.offline:
        return IndustrialDarkTokens.statusOffline;
    }
  }
}
