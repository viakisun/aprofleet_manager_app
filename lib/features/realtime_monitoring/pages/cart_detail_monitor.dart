import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../domain/models/cart.dart';
import '../../../domain/models/telemetry.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/design_tokens.dart';
import '../widgets/telemetry_gauge.dart';
import '../widgets/system_metrics_card.dart';

class CartDetailMonitor extends ConsumerStatefulWidget {
  final String cartId;

  const CartDetailMonitor({
    super.key,
    required this.cartId,
  });

  @override
  ConsumerState<CartDetailMonitor> createState() => _CartDetailMonitorState();
}

class _CartDetailMonitorState extends ConsumerState<CartDetailMonitor> {
  late StreamSubscription _telemetrySubscription;
  late StreamSubscription _alertSubscription;
  Telemetry? _currentTelemetry;
  bool _isEmergencyStopPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
  }

  void _initializeStreams() {
    // Subscribe to telemetry updates for this cart
    final mockWsHub = ref.read(mockWsHubProvider);
    _telemetrySubscription = mockWsHub.telemetryStream
        .where((t) => t.cartId == widget.cartId)
        .listen(
      (telemetry) {
        if (mounted) {
          setState(() {
            _currentTelemetry = telemetry;
          });
        }
      },
    );

    // Subscribe to alerts for this cart
    _alertSubscription = mockWsHub.alertStream.listen(
      (alert) {
        if (alert.cartId == widget.cartId && mounted) {
          _showAlertToast(alert);
        }
      },
    );
  }

  @override
  void dispose() {
    _telemetrySubscription.cancel();
    _alertSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider(widget.cartId));

    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      appBar: AppBar(
        backgroundColor: DesignTokens.bgPrimary,
        foregroundColor: DesignTokens.textPrimary,
        title: Row(
          children: [
            // LIVE indicator
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: DesignTokens.statusMaintenance,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            const Text(
              'LIVE',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                fontWeight: DesignTokens.fontWeightBold,
                color: DesignTokens.statusMaintenance,
                letterSpacing: DesignTokens.letterSpacingWide,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Text(
                widget.cartId,
                style: const TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: DesignTokens.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: DesignTokens.textPrimary,
            ),
            onPressed: () {
              ref.invalidate(cartProvider(widget.cartId));
            },
          ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) =>
            cart != null ? _buildCartDetail(context, cart) : Container(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading cart: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(cartProvider(widget.cartId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartDetail(BuildContext context, Cart cart) {
    final localizations = AppLocalizations.of(context);
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with LIVE indicator
          _buildHeader(cart, statusColor),

          const SizedBox(height: 24),

          // Primary Telemetry
          _buildPrimaryTelemetry(cart),

          const SizedBox(height: 24),

          // System Metrics
          _buildSystemMetrics(),

          const SizedBox(height: 24),

          // Alerts Section
          _buildAlertsSection(cart),

          const SizedBox(height: 24),

          // Remote Controls
          _buildRemoteControls(cart, localizations),

          const SizedBox(height: 24),

          // Emergency Stop
          _buildEmergencyStop(cart, localizations),
        ],
      ),
    );
  }

  Widget _buildHeader(Cart cart, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: DesignTokens.getCardDecoration(),
      child: Row(
        children: [
          // LIVE indicator with pulsing animation
          _buildLiveIndicator(),
          const SizedBox(width: DesignTokens.spacingSm),
          const Text(
            'LIVE',
            style: TextStyle(
              color: DesignTokens.statusCritical,
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightBold,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
          const Spacer(),
          CartStatusChip(status: cart.status),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Container(
          width: DesignTokens.spacingSm,
          height: DesignTokens.spacingSm,
          decoration: BoxDecoration(
            color: DesignTokens.statusCritical.withValues(alpha: value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: DesignTokens.statusCritical.withValues(alpha: value * 0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // Restart animation
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildPrimaryTelemetry(Cart cart) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: DesignTokens.getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIMARY TELEMETRY',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textPrimary,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              // Battery Gauge
              Expanded(
                child: BatteryGauge(
                  batteryLevel: cart.batteryLevel ?? 0.0,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              // Speed Gauge
              Expanded(
                child: SpeedMeter(
                  speed: cart.speed ?? 0.0,
                  maxSpeed: 30.0, // Typical golf cart max speed
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildBatteryGauge(double batteryPct) {
    final color = batteryPct > 50
        ? Colors.green
        : batteryPct > 20
            ? Colors.orange
            : Colors.red;

    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              // Background circle
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 8,
                  ),
                ),
              ),
              // Progress circle
              CircularProgressIndicator(
                value: batteryPct / 100,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              // Center text
              Center(
                child: Text(
                  '${batteryPct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'BATTERY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildSpeedGauge(double speedKph) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              // Background arc
              CustomPaint(
                size: const Size(80, 80),
                painter: SpeedGaugePainter(
                  value: speedKph / 25.0, // Max speed 25 km/h
                  color: Colors.blue,
                ),
              ),
              // Center text
              Center(
                child: Text(
                  speedKph.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'SPEED',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSystemMetrics() {
    final telemetry = _currentTelemetry;

    final metrics = [
      TemperatureCard(
        temperature: telemetry?.temperature ?? 0.0,
        location: 'MOTOR',
      ),
      VoltageCard(
        voltage: telemetry?.voltage ?? 0.0,
        circuit: 'MAIN',
      ),
      CurrentCard(
        current: telemetry?.current ?? 0.0,
        component: 'MOTOR',
      ),
      RuntimeCard(
        runtime: telemetry?.runtime ?? 0.0,
      ),
      DistanceCard(
        distance: telemetry?.distance ?? 0.0,
        period: 'DAILY',
      ),
      EfficiencyCard(
        efficiency: telemetry != null && telemetry.battery > 0
            ? (telemetry.distance / telemetry.battery * 100)
            : 0.0,
        metric: 'ENERGY',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: DesignTokens.getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: DesignTokens.textSecondary,
                size: DesignTokens.iconMd,
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              const Text(
                'SYSTEM METRICS',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightSemibold,
                  color: DesignTokens.textPrimary,
                  letterSpacing: DesignTokens.letterSpacingWide,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: DesignTokens.spacingMd,
              mainAxisSpacing: DesignTokens.spacingMd,
              childAspectRatio: 1.2,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) => metrics[index],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ALERTS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          if ((cart.batteryPct ?? 0) < AppConstants.batteryWarningThreshold)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Battery level critical: ${(cart.batteryPct ?? 0).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              'No active alerts',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRemoteControls(Cart cart, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REMOTE CONTROLS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: 'Speed Limit',
                  onPressed: () => _showSpeedLimitDialog(),
                  type: ActionButtonType.secondary,
                  icon: Icons.speed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
                  text: 'Message',
                  onPressed: () => _showMessageDialog(),
                  type: ActionButtonType.secondary,
                  icon: Icons.message,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: 'Return to Base',
                  onPressed: () => _sendReturnToBaseCommand(),
                  type: ActionButtonType.secondary,
                  icon: Icons.home,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionButton(
                  text: 'Lock Cart',
                  onPressed: () => _sendLockCommand(),
                  type: ActionButtonType.secondary,
                  icon: Icons.lock,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStop(Cart cart, AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EMERGENCY CONTROLS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              text: 'EMERGENCY STOP',
              onPressed: _isEmergencyStopPressed
                  ? null
                  : () => _showEmergencyStopDialog(cart),
              type: ActionButtonType.destructive,
              icon: Icons.stop,
              isLoading: _isEmergencyStopPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _showSpeedLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Set Speed Limit',
            style: TextStyle(color: Colors.white)),
        content: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter speed limit (km/h)',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showToast('Speed limit set');
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title:
            const Text('Send Message', style: TextStyle(color: Colors.white)),
        content: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter message for operator',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showToast('Message sent');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendReturnToBaseCommand() {
    _showToast('Return to base command sent');
  }

  void _sendLockCommand() {
    _showToast('Cart locked');
  }

  void _showEmergencyStopDialog(Cart cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'EMERGENCY STOP',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will immediately stop the cart. This action cannot be undone. Are you sure?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _executeEmergencyStop(cart);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('STOP CART'),
          ),
        ],
      ),
    );
  }

  void _executeEmergencyStop(Cart cart) {
    setState(() {
      _isEmergencyStopPressed = true;
    });

    // Simulate emergency stop
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isEmergencyStopPressed = false;
        });
        _showToast(
            'Emergency stop executed - Cart status changed to MAINTENANCE');
      }
    });
  }

  void _showAlertToast(alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New alert: ${alert.message}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1A1A1A),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class SpeedGaugePainter extends CustomPainter {
  final double value;
  final Color color;

  SpeedGaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc from -90 degrees to 90 degrees (top half)
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -1.57, // -90 degrees in radians
      3.14 * value, // 180 degrees * value
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(SpeedGaugePainter oldDelegate) {
    return value != oldDelegate.value || color != oldDelegate.color;
  }
}
