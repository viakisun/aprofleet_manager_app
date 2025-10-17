import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';

class SystemMetricsCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final IconData icon;
  final String? trend;
  final bool isCompact;

  const SystemMetricsCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    this.trend,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
          isCompact ? DesignTokens.spacingSm : DesignTokens.spacingMd),
      decoration: DesignTokens.getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingXs),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
                ),
                child: Icon(
                  icon,
                  size: DesignTokens.iconSm,
                  color: color,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: DesignTokens.getUppercaseLabelStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: trend!.startsWith('+')
                        ? DesignTokens.statusActive.withOpacity(0.1)
                        : DesignTokens.statusMaintenance.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      fontWeight: DesignTokens.fontWeightSemibold,
                      color: trend!.startsWith('+')
                          ? DesignTokens.statusActive
                          : DesignTokens.statusMaintenance,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingMd),

          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: isCompact
                      ? DesignTokens.fontSizeXl
                      : DesignTokens.fontSize2xl,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: DesignTokens.textPrimary,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingXs),
              Text(
                unit,
                style: TextStyle(
                  fontSize: isCompact
                      ? DesignTokens.fontSizeSm
                      : DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SystemMetricsGrid extends StatelessWidget {
  final List<SystemMetricsCard> cards;
  final int crossAxisCount;

  const SystemMetricsGrid({
    super.key,
    required this.cards,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DesignTokens.spacingMd,
        mainAxisSpacing: DesignTokens.spacingMd,
        childAspectRatio: 1.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }
}

class TemperatureCard extends StatelessWidget {
  final double temperature;
  final String location;

  const TemperatureCard({
    super.key,
    required this.temperature,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    if (temperature > 60) {
      color = DesignTokens.statusMaintenance;
      icon = Icons.warning;
    } else if (temperature > 40) {
      color = DesignTokens.statusIdle;
      icon = Icons.thermostat;
    } else {
      color = DesignTokens.statusActive;
      icon = Icons.thermostat;
    }

    return SystemMetricsCard(
      label: location,
      value: temperature,
      unit: '°C',
      color: color,
      icon: icon,
      trend: temperature > 50 ? '+5.2°' : null,
    );
  }
}

class VoltageCard extends StatelessWidget {
  final double voltage;
  final String circuit;

  const VoltageCard({
    super.key,
    required this.voltage,
    required this.circuit,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    if (voltage < 44 || voltage > 52) {
      color = DesignTokens.statusMaintenance;
    } else if (voltage < 46 || voltage > 50) {
      color = DesignTokens.statusIdle;
    } else {
      color = DesignTokens.statusActive;
    }

    return SystemMetricsCard(
      label: '$circuit VOLTAGE',
      value: voltage,
      unit: 'V',
      color: color,
      icon: Icons.electrical_services,
    );
  }
}

class CurrentCard extends StatelessWidget {
  final double current;
  final String component;

  const CurrentCard({
    super.key,
    required this.current,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return SystemMetricsCard(
      label: '$component CURRENT',
      value: current,
      unit: 'A',
      color: DesignTokens.statusCharging,
      icon: Icons.flash_on,
    );
  }
}

class RuntimeCard extends StatelessWidget {
  final double runtime;
  final String unit;

  const RuntimeCard({
    super.key,
    required this.runtime,
    this.unit = 'h',
  });

  @override
  Widget build(BuildContext context) {
    return SystemMetricsCard(
      label: 'RUNTIME',
      value: runtime,
      unit: unit,
      color: DesignTokens.statusActive,
      icon: Icons.access_time,
    );
  }
}

class DistanceCard extends StatelessWidget {
  final double distance;
  final String period;

  const DistanceCard({
    super.key,
    required this.distance,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return SystemMetricsCard(
      label: '$period DISTANCE',
      value: distance,
      unit: 'km',
      color: DesignTokens.statusIdle,
      icon: Icons.speed,
    );
  }
}

class EfficiencyCard extends StatelessWidget {
  final double efficiency;
  final String metric;

  const EfficiencyCard({
    super.key,
    required this.efficiency,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    if (efficiency > 85) {
      color = DesignTokens.statusActive;
    } else if (efficiency > 70) {
      color = DesignTokens.statusIdle;
    } else {
      color = DesignTokens.statusMaintenance;
    }

    return SystemMetricsCard(
      label: '$metric EFFICIENCY',
      value: efficiency,
      unit: '%',
      color: color,
      icon: Icons.trending_up,
      trend: efficiency > 80 ? '+2.1%' : null,
    );
  }
}
