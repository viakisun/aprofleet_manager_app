import 'package:flutter/material.dart';
import '../theme/industrial_dark_tokens.dart';
import '../utils/performance_logger.dart';

/// Performance debug overlay showing real-time metrics
///
/// Displays:
/// - FPS (frames per second)
/// - Build times (LiveMapView, CartList)
/// - Marker update performance
/// - Performance score (0-100)
class PerformanceDebugOverlay extends StatefulWidget {
  const PerformanceDebugOverlay({super.key});

  @override
  State<PerformanceDebugOverlay> createState() =>
      _PerformanceDebugOverlayState();
}

class _PerformanceDebugOverlayState extends State<PerformanceDebugOverlay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isExpanded ? 280 : 50,
          decoration: BoxDecoration(
            color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.95),
            border: Border.all(
              color: IndustrialDarkTokens.outline,
              width: IndustrialDarkTokens.borderWidth,
            ),
            borderRadius:
                BorderRadius.circular(IndustrialDarkTokens.radiusCard),
          ),
          child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    final score = _calculatePerformanceScore();
    final scoreColor = _getScoreColor(score);

    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.speed,
              color: scoreColor,
              size: 16,
            ),
            const SizedBox(height: 2),
            Text(
              score.toString(),
              style: IndustrialDarkTokens.labelStyle.copyWith(
                color: scoreColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    final score = _calculatePerformanceScore();
    final scoreColor = _getScoreColor(score);
    final metrics = _getMetrics();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: IndustrialDarkTokens.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.speed,
                color: IndustrialDarkTokens.accentPrimary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'PERFORMANCE',
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 14),
                onPressed: () => setState(() => _isExpanded = false),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                color: IndustrialDarkTokens.textSecondary,
              ),
            ],
          ),
        ),
        // Score
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SCORE',
                      style: IndustrialDarkTokens.labelStyle.copyWith(
                        fontSize: 10,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          score.toString(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: scoreColor,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/100',
                          style: IndustrialDarkTokens.bodyStyle.copyWith(
                            fontSize: 14,
                            color: IndustrialDarkTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getScoreLabel(score),
                      style: IndustrialDarkTokens.labelStyle.copyWith(
                        fontSize: 9,
                        color: scoreColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Score indicator
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    // Background circle
                    const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 4,
                          color: IndustrialDarkTokens.outline,
                        ),
                      ),
                    ),
                    // Score circle
                    Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: score / 100,
                          strokeWidth: 4,
                          color: scoreColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Metrics
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            children: [
              _buildMetricRow(
                  'Build', '${metrics['build']}ms', metrics['build']! <= 5),
              const SizedBox(height: 6),
              _buildMetricRow('Markers', '${metrics['markers']}ms',
                  metrics['markers']! <= 2),
              const SizedBox(height: 6),
              _buildMetricRow('Icon Cache', '${metrics['iconHits']}%',
                  metrics['iconHits']! >= 95),
              const SizedBox(height: 6),
              _buildMetricRow(
                  'Update Rate', '${metrics['updateRate']}ms', true),
            ],
          ),
        ),
        // Clear button
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SizedBox(
            width: double.infinity,
            height: 28,
            child: OutlinedButton(
              onPressed: () {
                PerformanceLogger.clear();
                setState(() {});
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(
                  color: IndustrialDarkTokens.outline,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                ),
              ),
              child: Text(
                'CLEAR METRICS',
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, bool isGood) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isGood
                ? IndustrialDarkTokens.statusActive
                : IndustrialDarkTokens.statusIdle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: IndustrialDarkTokens.labelStyle.copyWith(
              fontSize: 10,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: IndustrialDarkTokens.labelStyle.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isGood
                ? IndustrialDarkTokens.statusActive
                : IndustrialDarkTokens.statusIdle,
          ),
        ),
      ],
    );
  }

  Map<String, int> _getMetrics() {
    final buildTimes =
        PerformanceLogger.getMeasurements('LiveMapView.build') ?? [];
    final markerTimes =
        PerformanceLogger.getMeasurements('updateMarkers') ?? [];
    final iconGetTimes =
        PerformanceLogger.getMeasurements('updateMarkers.iconGet') ?? [];

    final avgBuild = buildTimes.isEmpty
        ? 0
        : (buildTimes.reduce((a, b) => a + b) / buildTimes.length).round();
    final avgMarkers = markerTimes.isEmpty
        ? 0
        : (markerTimes.reduce((a, b) => a + b) / markerTimes.length).round();
    final iconCacheHits = iconGetTimes.isEmpty
        ? 100
        : (iconGetTimes.where((t) => t == 0).length / iconGetTimes.length * 100)
            .round();

    return {
      'build': avgBuild,
      'markers': avgMarkers,
      'iconHits': iconCacheHits,
      'updateRate': 1000, // Current update interval
    };
  }

  int _calculatePerformanceScore() {
    final metrics = _getMetrics();
    int score = 100;

    // Build time penalty (target: ≤5ms)
    final buildTime = metrics['build']!;
    if (buildTime > 5) score -= ((buildTime - 5) * 2).clamp(0, 20);

    // Marker update penalty (target: ≤2ms)
    final markerTime = metrics['markers']!;
    if (markerTime > 2) score -= ((markerTime - 2) * 5).clamp(0, 25);

    // Icon cache hit rate bonus/penalty (target: ≥95%)
    final iconHits = metrics['iconHits']!;
    if (iconHits < 95) score -= ((95 - iconHits) * 2).clamp(0, 30);

    return score.clamp(0, 100);
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return IndustrialDarkTokens.statusActive; // Green
    if (score >= 70) return IndustrialDarkTokens.statusIdle; // Orange
    return IndustrialDarkTokens.statusMaintenance; // Red
  }

  String _getScoreLabel(int score) {
    if (score >= 95) return 'EXCELLENT';
    if (score >= 90) return 'VERY GOOD';
    if (score >= 80) return 'GOOD';
    if (score >= 70) return 'FAIR';
    if (score >= 60) return 'POOR';
    return 'CRITICAL';
  }
}
