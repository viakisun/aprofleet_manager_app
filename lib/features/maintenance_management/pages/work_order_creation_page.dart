import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../domain/models/work_order.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/steps/stepper.dart' as custom;
import '../../../core/widgets/via/via_toast.dart';
import '../../../core/widgets/via/via_button.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../controllers/work_order_creation_controller.dart';
import '../widgets/creation/work_order_creation_step1.dart';
import '../widgets/creation/work_order_creation_step2.dart';
import '../widgets/creation/work_order_creation_step3.dart';
import '../widgets/creation/work_order_creation_step4.dart';

/// Main page for creating work orders with multi-step form
class WorkOrderCreationPage extends ConsumerStatefulWidget {
  final String? preselectedCartId;

  const WorkOrderCreationPage({
    super.key,
    this.preselectedCartId,
  });

  @override
  ConsumerState<WorkOrderCreationPage> createState() =>
      _WorkOrderCreationPageState();
}

class _WorkOrderCreationPageState extends ConsumerState<WorkOrderCreationPage> {
  late WorkOrderCreationController _controller;
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(workOrderCreationControllerProvider.notifier);

    // Check for draft
    _checkForDraft();

    // Set preselected cart if provided
    if (widget.preselectedCartId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.setCartId(widget.preselectedCartId!);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final createWoState = ref.watch(workOrderCreationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createWorkOrder),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ViaButton.ghost(
              text: 'Save Draft',
              onPressed: _canSaveDraft() ? _saveDraft : null,
              size: ViaButtonSize.small,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stepper
          custom.Stepper(
            currentStep: _currentStep,
            totalSteps: 4,
            stepTitles: const [
              'Type & Priority',
              'Cart & Location',
              'Schedule & Tech',
              'Parts & Review',
            ],
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                WorkOrderCreationStep1(controller: _controller),
                WorkOrderCreationStep2(controller: _controller),
                WorkOrderCreationStep3(controller: _controller),
                WorkOrderCreationStep4(
                  controller: _controller,
                  onCreateWorkOrder: _createWorkOrder,
                ),
              ],
            ),
          ),

          // Navigation
          _buildNavigation(createWoState),
        ],
      ),
    );
  }

  Widget _buildNavigation(createWoState) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        border: Border(
          top: BorderSide(color: DesignTokens.borderPrimary),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: ViaButton.ghost(
              text: 'PREVIOUS',
              onPressed: _currentStep > 0 ? _previousStep : null,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          // Next button
          Expanded(
            child: ViaButton.primary(
              text: 'NEXT',
              onPressed: _canProceedToNextStep() ? _nextStep : null,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkForDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('draft.wo.create');

      if (draftJson != null && mounted) {
        final draft = WorkOrderDraft.fromJson(jsonDecode(draftJson));
        _controller.loadDraft(draft);

        ViaToast.show(
          context: context,
          message: 'Draft found and loaded successfully',
          variant: ViaToastVariant.info,
        );
      }
    } catch (e) {
      // Ignore draft loading errors
    }
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = jsonEncode(_controller.currentDraft.toJson());
      await prefs.setString('draft.wo.create', draftJson);

      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Draft saved successfully',
          variant: ViaToastVariant.success,
        );
      }
    } catch (e) {
      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Failed to save draft: $e',
          variant: ViaToastVariant.error,
        );
      }
    }
  }

  Future<void> _createWorkOrder() async {
    try {
      await _controller.createWorkOrder(_controller.currentDraft);

      // Clear draft
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('draft.wo.create');

      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Work order created successfully',
          variant: ViaToastVariant.success,
        );
        context.go('/mm/list');
      }
    } catch (e) {
      if (mounted) {
        ViaToast.show(
          context: context,
          message: 'Failed to create work order: $e',
          variant: ViaToastVariant.error,
        );
      }
    } finally {
      // Cleanup if needed
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceedToNextStep() {
    return _controller.canProceedToNextStep(_currentStep);
  }

  bool _canSaveDraft() {
    return _controller.canSaveDraft();
  }

  void _showExitDialog() {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Exit Work Order Creation',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DesignTokens.textPrimary,
        ),
      ),
      child: Text(
        'Are you sure you want to exit? Any unsaved changes will be lost.',
        style: TextStyle(
          fontSize: DesignTokens.fontSizeMd,
          color: DesignTokens.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      footer: Row(
        children: [
          Expanded(
            child: ViaButton.ghost(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: ViaButton.primary(
              text: 'Exit',
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/mm/list');
              },
            ),
          ),
        ],
      ),
    );
  }
}
