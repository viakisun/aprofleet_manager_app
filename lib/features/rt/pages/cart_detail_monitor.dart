import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../domain/models/cart.dart';
import '../../../domain/models/telemetry.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import 'controllers/cart_detail_controller.dart';

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
    _telemetrySubscription =
        ref.read(telemetryStreamProvider(widget.cartId).stream).listen(
      (telemetry) {
        if (mounted) {
          setState(() {
            _currentTelemetry = telemetry;
          });
        }
      },
    );

    // Subscribe to alerts for this cart
    _alertSubscription = ref.read(alertStreamProvider.stream).listen(
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
    final localizations = AppLocalizations.of(context);
    final cartAsync = ref.watch(cartProvider(widget.cartId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.details} - ${widget.cartId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(cartProvider(widget.cartId));
            },
          ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) => _buildCartDetail(context, cart),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // LIVE indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: SizedBox.expand(),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const Spacer(),
          CartStatusChip(status: cart.status),
        ],
      ),
    );
  }

  Widget _buildPrimaryTelemetry(Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIMARY TELEMETRY',
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
              // Battery Gauge
              Expanded(
                child: _buildBatteryGauge(cart.batteryPct),
              ),
              const SizedBox(width: 16),
              // Speed Gauge
              Expanded(
                child: _buildSpeedGauge(cart.speedKph),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                    color: Colors.white.withOpacity(0.2),
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
                  '${speedKph.toStringAsFixed(1)}',
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM METRICS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          // Grid of metrics
          Row(
            children: [
              Expanded(
                child: TelemetryWidget(
                  label: 'Temperature',
                  value: telemetry?.temperature ?? 0.0,
                  unit: '°C',
                  color: (telemetry?.temperature ?? 0) > 60
                      ? Colors.red
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TelemetryWidget(
                  label: 'Voltage',
                  value: telemetry?.voltage ?? 0.0,
                  unit: 'V',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TelemetryWidget(
                  label: 'Current',
                  value: telemetry?.current ?? 0.0,
                  unit: 'A',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TelemetryWidget(
                  label: 'Runtime',
                  value: telemetry?.runtime ?? 0.0,
                  unit: 'h',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TelemetryWidget(
                  label: 'Distance',
                  value: telemetry?.distance ?? 0.0,
                  unit: 'km',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TelemetryWidget(
                  label: 'Efficiency',
                  value: telemetry != null && telemetry.battery > 0
                      ? telemetry.distance / telemetry.battery
                      : 0.0,
                  unit: 'km/%',
                ),
              ),
            ],
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
          color: Colors.white.withOpacity(0.06),
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
          if (cart.batteryPct < AppConstants.batteryWarningThreshold)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Battery level critical: ${cart.batteryPct.toStringAsFixed(1)}%',
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
          color: Colors.white.withOpacity(0.06),
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
          color: Colors.red.withOpacity(0.3),
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
