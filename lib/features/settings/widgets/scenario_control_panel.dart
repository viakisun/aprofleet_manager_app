import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/via_design_tokens.dart';
import '../../../core/services/scenarios/scenario_engine.dart';
import '../../../core/services/scenarios/emergency_scenario.dart';
import '../../../domain/models/scenario_event.dart';

class ScenarioControlPanel extends ConsumerStatefulWidget {
  const ScenarioControlPanel({super.key});

  @override
  ConsumerState<ScenarioControlPanel> createState() =>
      _ScenarioControlPanelState();
}

class _ScenarioControlPanelState extends ConsumerState<ScenarioControlPanel> {
  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(scenarioEngineProvider);
    final stateAsync = ref.watch(scenarioStateProvider);
    final progressAsync = ref.watch(scenarioProgressProvider);

    final state = stateAsync.value ?? ScenarioState.idle;
    final progress = progressAsync.value ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ViaDesignTokens.surfacePrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ViaDesignTokens.borderPrimary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                color: ViaDesignTokens.textPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '시나리오 시뮬레이션',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ViaDesignTokens.textPrimary,
                ),
              ),
              const Spacer(),
              _buildStateChip(state),
            ],
          ),

          const SizedBox(height: 16),

          // Scenario selector
          _buildScenarioSelector(engine),

          if (engine.currentScenario != null) ...[
            const SizedBox(height: 16),

            // Progress bar
            _buildProgressBar(progress, engine.currentScenario!),

            const SizedBox(height: 16),

            // Playback controls
            _buildPlaybackControls(engine, state),

            const SizedBox(height: 12),

            // Speed control
            _buildSpeedControl(engine),
          ],
        ],
      ),
    );
  }

  Widget _buildStateChip(ScenarioState state) {
    Color color;
    String label;
    IconData icon;

    switch (state) {
      case ScenarioState.idle:
        color = ViaDesignTokens.textMuted;
        label = '대기';
        icon = Icons.stop;
        break;
      case ScenarioState.playing:
        color = ViaDesignTokens.statusActive;
        label = '재생 중';
        icon = Icons.play_arrow;
        break;
      case ScenarioState.paused:
        color = ViaDesignTokens.warning;
        label = '일시정지';
        icon = Icons.pause;
        break;
      case ScenarioState.completed:
        color = ViaDesignTokens.primary;
        label = '완료';
        icon = Icons.check;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSelector(ScenarioEngine engine) {
    final scenarios = [
      EmergencyScenario.scenario,
      // Add more scenarios here
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시나리오 선택',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ViaDesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...scenarios.map((scenario) => _buildScenarioCard(engine, scenario)),
      ],
    );
  }

  Widget _buildScenarioCard(ScenarioEngine engine, Scenario scenario) {
    final isSelected = engine.currentScenario?.id == scenario.id;

    return GestureDetector(
      onTap: () => engine.loadScenario(scenario),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? ViaDesignTokens.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? ViaDesignTokens.primary
                : ViaDesignTokens.borderPrimary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  size: 20,
                  color: isSelected
                      ? ViaDesignTokens.primary
                      : ViaDesignTokens.textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  scenario.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? ViaDesignTokens.textPrimary
                        : ViaDesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                scenario.description,
                style: TextStyle(
                  fontSize: 12,
                  color: ViaDesignTokens.textMuted,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Text(
                '${scenario.events.length}개 이벤트 • ${scenario.totalDuration.inMinutes}분',
                style: TextStyle(
                  fontSize: 11,
                  color: ViaDesignTokens.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int progress, Scenario scenario) {
    final totalSeconds = scenario.totalDuration.inSeconds;
    final percentage = totalSeconds > 0 ? progress / totalSeconds : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatTime(progress),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ViaDesignTokens.textSecondary,
              ),
            ),
            Text(
              _formatTime(totalSeconds),
              style: TextStyle(
                fontSize: 12,
                color: ViaDesignTokens.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: ViaDesignTokens.surfaceSecondary,
            valueColor: AlwaysStoppedAnimation<Color>(ViaDesignTokens.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(ScenarioEngine engine, ScenarioState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop button
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: state != ScenarioState.idle ? () => engine.stop() : null,
          color: ViaDesignTokens.textPrimary,
          disabledColor: ViaDesignTokens.textMuted,
        ),

        const SizedBox(width: 16),

        // Play/Pause button
        Container(
          decoration: BoxDecoration(
            color: ViaDesignTokens.primary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              state == ScenarioState.playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 32,
            onPressed: () {
              if (state == ScenarioState.playing) {
                engine.pause();
              } else {
                engine.play();
              }
            },
          ),
        ),

        const SizedBox(width: 16),

        // Skip forward button
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: state != ScenarioState.idle
              ? () => engine.skipTo(engine.currentOffsetSeconds + 30)
              : null,
          color: ViaDesignTokens.textPrimary,
          disabledColor: ViaDesignTokens.textMuted,
        ),
      ],
    );
  }

  Widget _buildSpeedControl(ScenarioEngine engine) {
    final speeds = [1, 2, 5, 10, 60];
    final currentSpeed = engine.playbackSpeed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '재생 속도',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ViaDesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: speeds.map((speed) {
            final isSelected = currentSpeed == speed;
            return Expanded(
              child: GestureDetector(
                onTap: () => engine.setPlaybackSpeed(speed),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ViaDesignTokens.primary
                        : ViaDesignTokens.surfaceSecondary,
                    borderRadius: BorderRadius.circular(6),
                    border: isSelected
                        ? null
                        : Border.all(color: ViaDesignTokens.borderPrimary),
                  ),
                  child: Text(
                    '${speed}x',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : ViaDesignTokens.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
