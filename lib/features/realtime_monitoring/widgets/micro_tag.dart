import 'package:flutter/material.dart';

class MicroTag extends StatelessWidget {
  final String id;
  final String? badge; // "25%" or "Charging"
  
  const MicroTag({
    super.key,
    required this.id,
    this.badge,
  });
  
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              id, 
              style: const TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Text(
                badge!, 
                style: TextStyle(
                  fontSize: 11, 
                  color: Colors.white.withOpacity(.62),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
