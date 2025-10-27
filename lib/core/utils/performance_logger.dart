import 'package:flutter/foundation.dart';

/// Performance measurement utility for profiling Flutter app
///
/// Usage:
/// ```dart
/// PerformanceLogger.start('myFunction');
/// // ... code to measure ...
/// PerformanceLogger.end('myFunction');
///
/// // Print summary
/// PerformanceLogger.printSummary();
/// ```
class PerformanceLogger {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<int>> _measurements = {};
  static bool _enabled = true;

  /// Start measuring a labeled operation
  static void start(String label) {
    if (!_enabled) return;
    _timers[label] = Stopwatch()..start();
  }

  /// End measuring a labeled operation
  static void end(String label) {
    if (!_enabled) return;

    final timer = _timers[label];
    if (timer == null) {
      if (kDebugMode) {
        print('⚠️  PerformanceLogger: Timer "$label" not found');
      }
      return;
    }

    timer.stop();
    _measurements.putIfAbsent(label, () => []);
    _measurements[label]!.add(timer.elapsedMilliseconds);

    // Real-time logging in debug/profile mode
    if (kDebugMode || kProfileMode) {
      print('⏱️  [$label] ${timer.elapsedMilliseconds}ms');
    }

    // Clean up timer
    _timers.remove(label);
  }

  /// Print performance summary with statistics
  static void printSummary() {
    if (_measurements.isEmpty) {
      print('\n📊 Performance Summary: No measurements collected');
      return;
    }

    print('\n${'=' * 70}');
    print('📊 Performance Summary');
    print('=' * 70);

    // Sort by average time descending
    final sorted = _measurements.entries.toList()
      ..sort((a, b) {
        final avgA = a.value.reduce((x, y) => x + y) / a.value.length;
        final avgB = b.value.reduce((x, y) => x + y) / b.value.length;
        return avgB.compareTo(avgA);
      });

    for (final entry in sorted) {
      final label = entry.key;
      final times = entry.value;
      final count = times.length;
      final sum = times.reduce((a, b) => a + b);
      final avg = sum / count;
      final max = times.reduce((a, b) => a > b ? a : b);
      final min = times.reduce((a, b) => a < b ? a : b);

      print('  $label:');
      print('    Count: $count calls');
      print('    Avg: ${avg.toStringAsFixed(2)}ms');
      print('    Min: ${min}ms');
      print('    Max: ${max}ms');
      print('    Total: ${sum}ms');
      print('');
    }
    print('=' * 70);
  }

  /// Clear all measurements
  static void clear() {
    _measurements.clear();
    _timers.clear();
  }

  /// Enable/disable logging
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Get measurements for a specific label
  static List<int>? getMeasurements(String label) {
    return _measurements[label];
  }
}
