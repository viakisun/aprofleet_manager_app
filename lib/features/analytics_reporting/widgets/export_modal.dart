import 'package:flutter/material.dart';
import '../../../../domain/models/kpi.dart';
import '../../../core/widgets/shared_widgets.dart';

class ExportModal extends StatelessWidget {
  final AnalyticsRange range;
  final Function(ExportFormat) onExport;

  const ExportModal({
    super.key,
    required this.range,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'EXPORT ANALYTICS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(color: Colors.grey),

          // Export options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Range info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Export Range',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        range.displayName,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Format options
                const Text(
                  'SELECT FORMAT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                _buildExportOption(
                  icon: Icons.table_chart,
                  title: 'CSV',
                  subtitle: 'Comma-separated values',
                  onTap: () => _exportAndClose(context, ExportFormat.csv),
                ),

                const SizedBox(height: 12),

                _buildExportOption(
                  icon: Icons.picture_as_pdf,
                  title: 'PDF',
                  subtitle: 'Portable Document Format',
                  onTap: () => _exportAndClose(context, ExportFormat.pdf),
                ),

                const SizedBox(height: 12),

                _buildExportOption(
                  icon: Icons.table_view,
                  title: 'Excel',
                  subtitle: 'Microsoft Excel format',
                  onTap: () => _exportAndClose(context, ExportFormat.excel),
                ),

                const SizedBox(height: 20),

                // Export button
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    text: 'Export Data',
                    onPressed: () => _exportAndClose(context, ExportFormat.csv),
                    type: ActionButtonType.primary,
                    icon: Icons.download,
                  ),
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _exportAndClose(BuildContext context, ExportFormat format) {
    onExport(format);
    Navigator.of(context).pop();
  }
}

enum ExportFormat {
  csv,
  pdf,
  excel,
}
