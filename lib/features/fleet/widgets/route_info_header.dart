import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// 경로 정보 헤더 - 상단 오버레이
///
/// 경로 이름과 총 거리를 표시하는 플로팅 헤더
class RouteInfoHeader extends StatelessWidget {
  /// 경로 이름
  final String routeName;

  /// 총 거리 (km)
  final double totalDistance;

  const RouteInfoHeader({
    super.key,
    required this.routeName,
    required this.totalDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: IndustrialDarkTokens.bgSurface.withOpacity(0.92),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: IndustrialDarkTokens.outline,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 경로 이름
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.route,
                      color: IndustrialDarkTokens.accentPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        routeName.toUpperCase(),
                        style: IndustrialDarkTokens.displayStyle.copyWith(
                          fontSize: 14,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // 구분선
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: IndustrialDarkTokens.outline,
              ),

              // 총 거리
              Row(
                children: [
                  const Icon(
                    Icons.straighten,
                    color: IndustrialDarkTokens.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${totalDistance.toStringAsFixed(2)} KM',
                    style: IndustrialDarkTokens.displayStyle.copyWith(
                      fontSize: 14,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
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
}
