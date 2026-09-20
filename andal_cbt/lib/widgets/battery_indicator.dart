import 'package:flutter/material.dart';

class BatteryIndicator extends StatefulWidget {
  const BatteryIndicator({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.batteryLevel,
  });

  final IconData icon;
  final Color? iconColor;
  final String batteryLevel;

  @override
  State<BatteryIndicator> createState() => _BatteryIndicatorState();
}

class _BatteryIndicatorState extends State<BatteryIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 28, color: widget.iconColor),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Battery Level:",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                widget.batteryLevel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
