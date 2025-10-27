import 'package:flutter/material.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

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
      padding: EdgeInsets.all(isCompact
          ? IndustrialDarkTokens.spacingCompact
          : IndustrialDarkTokens.spacingItem),
      decoration: IndustrialDarkTokens.getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and label
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(IndustrialDarkTokens.spacingMinimal),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: IndustrialDarkTokens.getUppercaseLabelStyle(
                    fontSize: 10,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IndustrialDarkTokens.spacingMinimal,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: trend!.startsWith('+')
                        ? IndustrialDarkTokens.statusActive
                            .withValues(alpha: 0.1)
                        : IndustrialDarkTokens.statusMaintenance
                            .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: IndustrialDarkTokens.fontWeightBold,
                      color: trend!.startsWith('+')
                          ? IndustrialDarkTokens.statusActive
                          : IndustrialDarkTokens.statusMaintenance,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: isCompact
                      ? IndustrialDarkTokens.fontSizeData
                      : IndustrialDarkTokens.fontSizeDisplay,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                  color: IndustrialDarkTokens.textPrimary,
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
              Text(
                unit,
                style: TextStyle(
                  fontSize: isCompact
                      ? IndustrialDarkTokens.fontSizeSmall
                      : IndustrialDarkTokens.fontSizeLabel,
                  fontWeight: IndustrialDarkTokens.fontWeightMedium,
                  color: IndustrialDarkTokens.textSecondary,
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
        crossAxisSpacing: IndustrialDarkTokens.spacingItem,
        mainAxisSpacing: IndustrialDarkTokens.spacingItem,
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
      color = IndustrialDarkTokens.statusMaintenance;
      icon = Icons.warning;
    } else if (temperature > 40) {
      color = IndustrialDarkTokens.statusIdle;
      icon = Icons.thermostat;
    } else {
      color = IndustrialDarkTokens.statusActive;
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
      color = IndustrialDarkTokens.statusMaintenance;
    } else if (voltage < 46 || voltage > 50) {
      color = IndustrialDarkTokens.statusIdle;
    } else {
      color = IndustrialDarkTokens.statusActive;
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
      color: IndustrialDarkTokens.statusCharging,
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
      color: IndustrialDarkTokens.statusActive,
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
      color: IndustrialDarkTokens.statusIdle,
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
      color = IndustrialDarkTokens.statusActive;
    } else if (efficiency > 70) {
      color = IndustrialDarkTokens.statusIdle;
    } else {
      color = IndustrialDarkTokens.statusMaintenance;
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
