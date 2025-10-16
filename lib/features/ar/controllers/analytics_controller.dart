import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/kpi.dart';
import '../../../core/services/providers.dart';
import '../../../core/utils/kpi_calculator.dart';

class AnalyticsController extends StateNotifier<AnalyticsState> {
  AnalyticsController(this.ref) : super(AnalyticsState.initial()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Load initial KPIs
    ref.read(kpiProvider.future).then((kpi) {
      state = state.copyWith(kpis: AsyncValue.data(kpi), isLoading: false);
    });

    // Start periodic updates every 30 seconds
    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    // Simulate real-time updates every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _updateKPIs();
        _startPeriodicUpdates();
      }
    });
  }

  void _updateKPIs() {
    final currentKpis = state.kpis.valueOrNull;
    if (currentKpis != null) {
      // Add slight random variation (±2%)
      final updatedKpis = currentKpis.copyWith(
        availabilityRate: _addVariation(currentKpis.availabilityRate, 0.02),
        mttr: _addVariation(currentKpis.mttr, 0.02),
        utilization: _addVariation(currentKpis.utilization, 0.02),
        dailyDistance: _addVariation(currentKpis.dailyDistance, 0.02),
        lastUpdated: DateTime.now(),
      );

      state = state.copyWith(kpis: AsyncValue.data(updatedKpis));
    }
  }

  double _addVariation(double value, double maxVariation) {
    final variation = (Math.random() - 0.5) * 2 * maxVariation;
    return (value + variation).clamp(0.0, 100.0);
  }

  void setRange(AnalyticsRange range) {
    state = state.copyWith(range: range);
    _refreshDataForRange(range);
  }

  void _refreshDataForRange(AnalyticsRange range) {
    // In a real implementation, this would fetch data for the specific range
    // For now, we'll just update the state
    state = state.copyWith(isRefreshing: true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        state = state.copyWith(isRefreshing: false);
      }
    });
  }

  void refreshData() {
    state = state.copyWith(isRefreshing: true);

    // Simulate data refresh
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _updateKPIs();
        state = state.copyWith(isRefreshing: false);
      }
    });
  }

  List<double> getAvailabilitySparkline() {
    // Generate mock sparkline data
    return List.generate(7, (index) => 90 + (Math.random() - 0.5) * 10);
  }

  List<double> getMTTRSparkline() {
    // Generate mock sparkline data
    return List.generate(7, (index) => 15 + (Math.random() - 0.5) * 10);
  }

  List<double> getUtilizationSparkline() {
    // Generate mock sparkline data
    return List.generate(7, (index) => 800 + (Math.random() - 0.5) * 100);
  }

  List<double> getDailyDistanceSparkline() {
    // Generate mock sparkline data
    return List.generate(7, (index) => 850 + (Math.random() - 0.5) * 100);
  }

  List<Map<String, dynamic>> getFleetPerformanceData() {
    // Generate mock fleet performance data
    final days = state.range == AnalyticsRange.week ? 7 : 30;
    return List.generate(days, (index) {
      return {
        'date': DateTime.now().subtract(Duration(days: days - index - 1)),
        'availability': 90 + (Math.random() - 0.5) * 10,
        'utilization': 800 + (Math.random() - 0.5) * 100,
      };
    });
  }

  List<Map<String, dynamic>> getBatteryHealthData() {
    // Generate mock battery health data
    final days = state.range == AnalyticsRange.week ? 7 : 30;
    return List.generate(days, (index) {
      return {
        'date': DateTime.now().subtract(Duration(days: days - index - 1)),
        'averageBattery': 75 + (Math.random() - 0.5) * 20,
        'minBattery': 60 + (Math.random() - 0.5) * 20,
        'maxBattery': 90 + (Math.random() - 0.5) * 10,
      };
    });
  }

  List<Map<String, dynamic>> getMaintenanceDistributionData() {
    // Generate mock maintenance distribution data
    return [
      {'type': 'Preventive', 'count': 45, 'color': Colors.blue},
      {'type': 'Battery', 'count': 20, 'color': Colors.green},
      {'type': 'Tire', 'count': 15, 'color': Colors.orange},
      {'type': 'Emergency', 'count': 10, 'color': Colors.red},
      {'type': 'Other', 'count': 10, 'color': Colors.purple},
    ];
  }

  Map<String, double> getCostAnalysisData() {
    // Generate mock cost analysis data
    return {
      'Total': 15000.0,
      'Labor': 8000.0,
      'Parts': 5000.0,
      'Other': 2000.0,
    };
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }
}

class AnalyticsState {
  final AsyncValue<Kpi> kpis;
  final AnalyticsRange range;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const AnalyticsState({
    required this.kpis,
    required this.range,
    required this.isLoading,
    required this.isRefreshing,
    this.error,
  });

  factory AnalyticsState.initial() {
    return const AnalyticsState(
      kpis: AsyncValue.loading(),
      range: AnalyticsRange.week,
      isLoading: true,
      isRefreshing: false,
    );
  }

  AnalyticsState copyWith({
    AsyncValue<Kpi>? kpis,
    AnalyticsRange? range,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
  }) {
    return AnalyticsState(
      kpis: kpis ?? this.kpis,
      range: range ?? this.range,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }
}

final analyticsControllerProvider =
    StateNotifierProvider<AnalyticsController, AnalyticsState>((ref) {
  return AnalyticsController(ref);
});

// Math utility for random numbers
class Math {
  static double random() {
    return DateTime.now().millisecondsSinceEpoch % 1000 / 1000.0;
  }
}
