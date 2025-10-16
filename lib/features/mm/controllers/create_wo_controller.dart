import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/services/providers.dart';
import '../../../core/constants/app_constants.dart';

class CreateWoController extends StateNotifier<CreateWoState> {
  CreateWoController(this.ref) : super(CreateWoState.initial());

  final Ref ref;

  void setType(WorkOrderType type) {
    state = state.copyWith(
      draft: state.draft.copyWith(type: type),
    );
  }

  void setAutoPriority(WorkOrderType type) {
    Priority priority;
    switch (type) {
      case WorkOrderType.emergencyRepair:
        priority = Priority.p1;
        break;
      case WorkOrderType.battery:
      case WorkOrderType.safety:
        priority = Priority.p2;
        break;
      case WorkOrderType.preventive:
      case WorkOrderType.tire:
        priority = Priority.p3;
        break;
      case WorkOrderType.other:
        priority = Priority.p4;
        break;
    }

    state = state.copyWith(
      draft: state.draft.copyWith(priority: priority),
    );
  }

  void setPriority(Priority priority) {
    state = state.copyWith(
      draft: state.draft.copyWith(priority: priority),
    );
  }

  void setDescription(String description) {
    state = state.copyWith(
      draft: state.draft.copyWith(description: description),
    );
  }

  void setCartId(String cartId) {
    state = state.copyWith(
      draft: state.draft.copyWith(cartId: cartId),
    );
  }

  void setLocation(String location) {
    state = state.copyWith(
      draft: state.draft.copyWith(location: location),
    );
  }

  void setLocationFromCart(String cartId) {
    // This would typically fetch cart details from repository
    // For now, we'll set a default location
    final location = 'Location for $cartId';
    state = state.copyWith(
      draft: state.draft.copyWith(location: location),
    );
  }

  void setScheduledDate(DateTime date) {
    final currentTime = state.draft.scheduledAt ?? DateTime.now();
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      currentTime.hour,
      currentTime.minute,
    );

    state = state.copyWith(
      draft: state.draft.copyWith(scheduledAt: newDateTime),
    );
  }

  void setScheduledTime(TimeOfDay time) {
    final currentDate = state.draft.scheduledAt ?? DateTime.now();
    final newDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      time.hour,
      time.minute,
    );

    state = state.copyWith(
      draft: state.draft.copyWith(scheduledAt: newDateTime),
    );
  }

  void setEstimatedDuration(Duration duration) {
    state = state.copyWith(
      draft: state.draft.copyWith(estimatedDuration: duration),
    );
  }

  void setTechnician(String technician) {
    state = state.copyWith(
      draft: state.draft.copyWith(technician: technician),
    );
  }

  void setParts(List<WoPart> parts) {
    state = state.copyWith(
      draft: state.draft.copyWith(parts: parts),
    );
  }

  void setChecklist(Map<String, bool> checklist) {
    state = state.copyWith(
      draft: state.draft.copyWith(checklist: checklist),
    );
  }

  void setNotes(String notes) {
    state = state.copyWith(
      draft: state.draft.copyWith(notes: notes),
    );
  }

  void loadDraft(WorkOrderDraft draft) {
    state = state.copyWith(draft: draft);
  }

  void reset() {
    state = CreateWoState.initial();
  }

  Future<WorkOrder> createWorkOrder(WorkOrderDraft draft) async {
    try {
      final workOrder =
          await ref.read(workOrderRepositoryProvider).create(draft);
      return workOrder;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  bool canProceedToNextStep(int currentStep) {
    switch (currentStep) {
      case 0: // Type & Priority
        return state.draft.type != null &&
            state.draft.priority != null &&
            state.draft.description.length >= 10;
      case 1: // Cart & Location
        return state.draft.cartId.isNotEmpty;
      case 2: // Schedule & Tech
        return state.draft.scheduledAt != null;
      case 3: // Parts & Review
        return true;
      default:
        return false;
    }
  }

  bool canSaveDraft() {
    return state.draft.type != null &&
        state.draft.priority != null &&
        state.draft.description.isNotEmpty;
  }

  List<String> getValidationErrors() {
    final errors = <String>[];

    if (state.draft.type == null) {
      errors.add('Work order type is required');
    }

    if (state.draft.priority == null) {
      errors.add('Priority is required');
    }

    if (state.draft.description.length < 10) {
      errors.add('Description must be at least 10 characters');
    }

    if (state.draft.cartId.isEmpty) {
      errors.add('Cart ID is required');
    }

    if (state.draft.scheduledAt == null) {
      errors.add('Scheduled date/time is required');
    }

    return errors;
  }
}

class CreateWoState {
  final WorkOrderDraft draft;
  final bool isLoading;
  final String? error;

  const CreateWoState({
    required this.draft,
    required this.isLoading,
    this.error,
  });

  factory CreateWoState.initial() {
    return CreateWoState(
      draft: WorkOrderDraft(
        type: WorkOrderType.preventive,
        priority: Priority.p3,
        description: '',
        cartId: '',
      ),
      isLoading: false,
    );
  }

  CreateWoState copyWith({
    WorkOrderDraft? draft,
    bool? isLoading,
    String? error,
  }) {
    return CreateWoState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final createWoControllerProvider =
    StateNotifierProvider<CreateWoController, CreateWoState>((ref) {
  return CreateWoController(ref);
});
