import 'package:flutter/material.dart';

import '../../controllers/analytics_controller.dart';

class CostAnalysisSection extends StatelessWidget {
  final AnalyticsController controller;

  const CostAnalysisSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
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
            'Cost Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: _buildCostAnalysisChart(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalysisChart(AnalyticsController controller) {
    final costData = controller.getCostAnalysisData();

    return Column(
      children: costData.entries.map((entry) {
        final percentage =
            entry.value / costData.values.reduce((a, b) => a + b) * 100;
        final color = _getCostColor(entry.key);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  entry.key,
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
                    color: Colors.white.withOpacity(0.1),
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

  Color _getCostColor(String category) {
    switch (category.toLowerCase()) {
      case 'total':
        return Colors.blue;
      case 'labor':
        return Colors.green;
      case 'parts':
        return Colors.orange;
      case 'other':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
