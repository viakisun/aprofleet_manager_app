import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../controllers/analytics_controller.dart';

class CostAnalysisSection extends StatelessWidget {
  final AnalyticsController controller;

  const CostAnalysisSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
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
          Text(
            localizations.analyticsCostAnalysis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildCostAnalysisChart(controller, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalysisChart(AnalyticsController controller, AppLocalizations localizations) {
    final costData = controller.getCostAnalysisData();

    return Column(
      children: costData.entries.map((entry) {
        final percentage =
            entry.value / costData.values.reduce((a, b) => a + b) * 100;
        final color = _getCostColor(entry.key);
        final localizedLabel = _getLocalizedCostLabel(entry.key, localizations);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  localizedLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                  '\$${entry.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getLocalizedCostLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'costTotal':
        return localizations.costTotal;
      case 'costLabor':
        return localizations.costLabor;
      case 'costParts':
        return localizations.costParts;
      case 'costOther':
        return localizations.costOther;
      default:
        return key;
    }
  }

  Color _getCostColor(String category) {
    switch (category.toLowerCase()) {
      case 'costtotal':
        return Colors.blue;
      case 'costlabor':
        return Colors.green;
      case 'costparts':
        return Colors.orange;
      case 'costother':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
