import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/services/providers.dart';
import '../../../core/utils/validators/business_validator.dart';

/// Controller for managing work order creation state and business logic
class WorkOrderCreationController extends StateNotifier<WorkOrderCreationState> {
  WorkOrderCreationController(this.ref) : super(WorkOrderCreationState.initial());

  final Ref ref;
  
  /// Get current draft
  WorkOrderDraft get currentDraft => state.draft;

  /// Set work order type and auto-assign priority based on business rules
  void setWorkOrderType(WorkOrderType type) {
    state = state.copyWith(
      draft: state.draft.copyWith(type: type),
    );
    
    // Auto-assign priority based on work order type
    _setAutoPriority(type);
  }

  /// Set priority manually
  void setPriority(Priority priority) {
    state = state.copyWith(
      draft: state.draft.copyWith(priority: priority),
    );
  }

  /// Set work order description
  void setDescription(String description) {
    state = state.copyWith(
      draft: state.draft.copyWith(description: description.trim()),
    );
  }

  /// Set assigned cart ID
  void setCartId(String cartId) {
    state = state.copyWith(
      draft: state.draft.copyWith(cartId: cartId.trim()),
    );
  }

  /// Set work location
  void setLocation(String location) {
    state = state.copyWith(
      draft: state.draft.copyWith(location: location.trim()),
    );
  }

  /// Set scheduled date and time
  void setScheduledAt(DateTime scheduledAt) {
    state = state.copyWith(
      draft: state.draft.copyWith(scheduledAt: scheduledAt),
    );
  }

  /// Set assigned technician
  void setTechnician(String technician) {
    state = state.copyWith(
      draft: state.draft.copyWith(technician: technician.trim()),
    );
  }

  /// Set estimated duration
  void setEstimatedDuration(Duration duration) {
    state = state.copyWith(
      draft: state.draft.copyWith(estimatedDuration: duration),
    );
  }

  /// Set required parts
  void setParts(List<WoPart> parts) {
    state = state.copyWith(
      draft: state.draft.copyWith(parts: parts),
    );
  }

  /// Set additional notes
  void setNotes(String notes) {
    state = state.copyWith(
      draft: state.draft.copyWith(notes: notes.trim()),
    );
  }

  /// Load existing draft
  void loadDraft(WorkOrderDraft draft) {
    state = state.copyWith(draft: draft);
  }

  /// Reset controller to initial state
  void reset() {
    state = WorkOrderCreationState.initial();
  }

  /// Create work order with validation
  Future<WorkOrder> createWorkOrder(WorkOrderDraft draft) async {
    try {
      // Validate draft before creation
      final validationErrors = BusinessValidator.validateWorkOrderCreation(
        type: draft.type,
        priority: draft.priority,
        description: draft.description,
        cartId: draft.cartId,
        scheduledAt: draft.scheduledAt,
        technician: draft.technician,
      );

      if (validationErrors.isNotEmpty) {
        state = state.copyWith(error: validationErrors.join(', '));
        throw Exception(validationErrors.join(', '));
      }

      // Create work order
      final workOrder = await ref.read(workOrderRepositoryProvider).create(draft);
      
      // Clear any previous errors
      state = state.copyWith(error: null);
      
      return workOrder;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Check if user can proceed to next step
  bool canProceedToNextStep(int currentStep) {
    switch (currentStep) {
      case 0: // Type & Priority
        return state.draft.description.length >= 10;
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

  /// Check if draft can be saved
  bool canSaveDraft() {
    return state.draft.description.isNotEmpty;
  }

  /// Get validation errors for current draft
  List<String> getValidationErrors() {
    return BusinessValidator.validateWorkOrderCreation(
      type: state.draft.type,
      priority: state.draft.priority,
      description: state.draft.description,
      cartId: state.draft.cartId,
      scheduledAt: state.draft.scheduledAt,
      technician: state.draft.technician,
    );
  }

  /// Auto-assign priority based on work order type
  void _setAutoPriority(WorkOrderType type) {
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

}

/// State class for work order creation
class WorkOrderCreationState {
  final WorkOrderDraft draft;
  final bool isLoading;
  final String? error;

  const WorkOrderCreationState({
    required this.draft,
    required this.isLoading,
    this.error,
  });

  factory WorkOrderCreationState.initial() {
    return WorkOrderCreationState(
      draft: WorkOrderDraft.initial(),
      isLoading: false,
      error: null,
    );
  }

  WorkOrderCreationState copyWith({
    WorkOrderDraft? draft,
    bool? isLoading,
    String? error,
  }) {
    return WorkOrderCreationState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Provider for work order creation controller
final workOrderCreationControllerProvider = 
    StateNotifierProvider<WorkOrderCreationController, WorkOrderCreationState>((ref) {
  return WorkOrderCreationController(ref);
});
