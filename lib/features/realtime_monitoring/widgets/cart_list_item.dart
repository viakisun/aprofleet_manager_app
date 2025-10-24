import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  const CartListItem({
    super.key,
    required this.name,
    required this.batteryPercent,
    required this.statusColor,
    this.showBattery = false,
    this.isSelected = false,
    this.onTap,
  });

  final String name;            // 좌측 정렬
  final int batteryPercent;
  final Color statusColor;      // 좌측 2px BAR
  final bool showBattery;       // <=30% or charging일 때만 true
  final bool isSelected;       // 선택된 카트인지 여부
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dim = Theme.of(context).colorScheme.onSurface.withOpacity(.62);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(.08) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(.12), width: 1),
          ),
        ),
        child: Row(
          children: [
            // 상태 BAR
            Container(width: 2, height: 16, color: statusColor),
            const SizedBox(width: 8),
            // 카트 ID: 좌측 정렬, 우선순위 가장 높음
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            if (showBattery) ...[
              const SizedBox(width: 8),
              Icon(_batteryIcon(batteryPercent), size: 14, color: dim),
              const SizedBox(width: 4),
              Text('$batteryPercent%', style: TextStyle(fontSize: 12, color: dim)),
            ],
          ],
        ),
      ),
    );
  }

  IconData _batteryIcon(int p) {
    if (p >= 95) return Icons.battery_full;
    if (p >= 75) return Icons.battery_6_bar;
    if (p >= 50) return Icons.battery_5_bar;
    if (p >= 30) return Icons.battery_3_bar;
    if (p >  10) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }
}
