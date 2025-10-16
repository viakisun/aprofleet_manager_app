import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/alert.dart';
import '../../../core/services/providers.dart';

class AlertController extends StateNotifier<AlertState> {
  AlertController(this.ref) : super(AlertState.initial()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Load initial alerts
    ref.read(alertsProvider.future).then((alerts) {
      state = state.copyWith(alerts: AsyncValue.data(alerts), isLoading: false);
    });

    // Subscribe to live alert stream
    ref.listen(alertStreamProvider, (previous, next) {
      next.whenData((alert) {
        final currentAlerts = state.alerts.valueOrNull ?? [];
        final updatedAlerts = [alert, ...currentAlerts];
        state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));

        // Show toast for critical alerts if not muted
        if (!state.isMuted && alert.severity == AlertSeverity.critical) {
          _showCriticalAlertToast(alert);
        }
      });
    });
  }

  void setFilter(AlertFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void clearFilter() {
    state = state.copyWith(filter: const AlertFilter());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  List<Alert> getFilteredAlerts(List<Alert> alerts) {
    var filtered = alerts;

    // Apply severity filter
    if (state.filter.severities != null &&
        state.filter.severities!.isNotEmpty) {
      filtered = filtered
          .where((alert) => state.filter.severities!.contains(alert.severity))
          .toList();
    }

    // Apply state filter
    if (state.filter.states != null && state.filter.states!.isNotEmpty) {
      filtered = filtered
          .where((alert) => state.filter.states!.contains(alert.state))
          .toList();
    }

    // Apply priority filter
    if (state.filter.priorities != null &&
        state.filter.priorities!.isNotEmpty) {
      filtered = filtered
          .where((alert) => state.filter.priorities!.contains(alert.priority))
          .toList();
    }

    // Apply source filter
    if (state.filter.sources != null && state.filter.sources!.isNotEmpty) {
      // Note: AlertSource is not in the current Alert model, so we'll skip this for now
    }

    // Apply cart filter
    if (state.filter.cartId != null && state.filter.cartId!.isNotEmpty) {
      filtered = filtered
          .where((alert) => alert.cartId == state.filter.cartId)
          .toList();
    }

    // Apply date range filter
    if (state.filter.fromDate != null) {
      filtered = filtered
          .where((alert) => alert.createdAt.isAfter(state.filter.fromDate!))
          .toList();
    }
    if (state.filter.toDate != null) {
      filtered = filtered
          .where((alert) => alert.createdAt.isBefore(state.filter.toDate!))
          .toList();
    }

    // Apply unread filter
    if (state.filter.unreadOnly == true) {
      filtered = filtered
          .where((alert) =>
              alert.state == AlertState.triggered ||
              alert.state == AlertState.notified)
          .toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((alert) {
        return alert.title.toLowerCase().contains(query) ||
            alert.message.toLowerCase().contains(query) ||
            (alert.cartId?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort by priority and creation date
    filtered.sort((a, b) {
      final priorityComparison = a.priority.index.compareTo(b.priority.index);
      if (priorityComparison != 0) return priorityComparison;
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  Map<String, int> getSummary() {
    final alerts = state.alerts.valueOrNull ?? [];
    final summary = <String, int>{
      'critical':
          alerts.where((a) => a.severity == AlertSeverity.critical).length,
      'warning':
          alerts.where((a) => a.severity == AlertSeverity.warning).length,
      'info': alerts.where((a) => a.severity == AlertSeverity.info).length,
      'resolved': alerts.where((a) => a.state == AlertState.resolved).length,
    };
    return summary;
  }

  int getUnreadCount() {
    final alerts = state.alerts.valueOrNull ?? [];
    return alerts
        .where((alert) =>
            alert.state == AlertState.triggered ||
            alert.state == AlertState.notified)
        .length;
  }

  Future<void> acknowledgeAlert(String alertId) async {
    try {
      await ref.read(alertRepositoryProvider).acknowledge(alertId);

      // Update local state
      final currentAlerts = state.alerts.valueOrNull ?? [];
      final updatedAlerts = currentAlerts
          .map((alert) => alert.id == alertId
              ? alert.copyWith(
                  state: AlertState.acknowledged,
                  acknowledgedAt: DateTime.now(),
                  acknowledgedBy: 'Current User',
                  updatedAt: DateTime.now(),
                )
              : alert)
          .toList();

      state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> escalateAlert(String alertId, int toLevel) async {
    try {
      await ref
          .read(alertRepositoryProvider)
          .escalate(alertId, toLevel: toLevel);

      // Update local state
      final currentAlerts = state.alerts.valueOrNull ?? [];
      final updatedAlerts = currentAlerts
          .map((alert) => alert.id == alertId
              ? alert.copyWith(
                  state: AlertState.escalated,
                  escalationLevel: toLevel,
                  updatedAt: DateTime.now(),
                )
              : alert)
          .toList();

      state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> resolveAlert(String alertId) async {
    try {
      await ref.read(alertRepositoryProvider).resolve(alertId);

      // Update local state
      final currentAlerts = state.alerts.valueOrNull ?? [];
      final updatedAlerts = currentAlerts
          .map((alert) => alert.id == alertId
              ? alert.copyWith(
                  state: AlertState.resolved,
                  resolvedAt: DateTime.now(),
                  resolvedBy: 'Current User',
                  updatedAt: DateTime.now(),
                )
              : alert)
          .toList();

      state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAllRead() async {
    try {
      await ref.read(alertRepositoryProvider).markAllRead();

      // Update local state - mark all triggered/notified as acknowledged
      final currentAlerts = state.alerts.valueOrNull ?? [];
      final updatedAlerts = currentAlerts
          .map((alert) => (alert.state == AlertState.triggered ||
                  alert.state == AlertState.notified)
              ? alert.copyWith(
                  state: AlertState.acknowledged,
                  acknowledgedAt: DateTime.now(),
                  acknowledgedBy: 'Current User',
                  updatedAt: DateTime.now(),
                )
              : alert)
          .toList();

      state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> clearResolved() async {
    try {
      // Remove resolved alerts from local state
      final currentAlerts = state.alerts.valueOrNull ?? [];
      final updatedAlerts = currentAlerts
          .where((alert) => alert.state != AlertState.resolved)
          .toList();

      state = state.copyWith(alerts: AsyncValue.data(updatedAlerts));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _showCriticalAlertToast(Alert alert) {
    // This would typically show a toast notification
    // For now, we'll just update the state to indicate a critical alert
    state = state.copyWith(lastCriticalAlert: alert);
  }
}

class AlertState {
  final AsyncValue<List<Alert>> alerts;
  final AlertFilter filter;
  final String searchQuery;
  final bool isMuted;
  final bool isLoading;
  final String? error;
  final Alert? lastCriticalAlert;

  const AlertState({
    required this.alerts,
    required this.filter,
    required this.searchQuery,
    required this.isMuted,
    required this.isLoading,
    this.error,
    this.lastCriticalAlert,
  });

  factory AlertState.initial() {
    return const AlertState(
      alerts: AsyncValue.loading(),
      filter: AlertFilter(),
      searchQuery: '',
      isMuted: false,
      isLoading: true,
    );
  }

  AlertState copyWith({
    AsyncValue<List<Alert>>? alerts,
    AlertFilter? filter,
    String? searchQuery,
    bool? isMuted,
    bool? isLoading,
    String? error,
    Alert? lastCriticalAlert,
  }) {
    return AlertState(
      alerts: alerts ?? this.alerts,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      isMuted: isMuted ?? this.isMuted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastCriticalAlert: lastCriticalAlert ?? this.lastCriticalAlert,
    );
  }
}

final alertControllerProvider =
    StateNotifierProvider<AlertController, AlertState>((ref) {
  return AlertController(ref);
});
