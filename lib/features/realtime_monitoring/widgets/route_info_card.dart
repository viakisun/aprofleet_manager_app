import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/services/map/golf_course_route_provider.dart';

class RouteInfoCard extends ConsumerWidget {
  const RouteInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(golfCourseRouteProvider);

    if (routeState.isLoading) {
      return _buildLoadingCard();
    }

    if (routeState.error != null) {
      return _buildErrorCard(routeState.error!);
    }

    if (routeState.data == null && !routeState.isLoading) {
      return _buildDefaultCard();
    }

    if (routeState.data == null) {
      return _buildDefaultCard();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8), // 더 진한 배경
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.route,
            color: Color(0xFF4CAF50),
            size: DesignTokens.iconSm,
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                routeState.routeName ?? 'Golf Course',
                style: const TextStyle(
                  color: DesignTokens.textPrimary,
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${routeState.totalCoordinates ?? 0} points',
                style: TextStyle(
                  color: DesignTokens.textSecondary,
                  fontSize: DesignTokens.fontSizeXs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text(
                '골프장 경로 로딩 중...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            '1374개의 GPS 좌표 데이터를 불러오는 중입니다',
            style: TextStyle(
              color: Colors.blue.shade300,
              fontSize: DesignTokens.fontSizeXs,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade300],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            '잠시만 기다려주세요...',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: DesignTokens.fontSizeXs,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: DesignTokens.iconSm,
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '경로 로딩 실패',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: DesignTokens.fontSizeXs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.map_outlined,
            color: Colors.blue,
            size: DesignTokens.iconSm,
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          const Text(
            '골프장 경로 대기 중...',
            style: TextStyle(
              color: DesignTokens.textPrimary,
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
