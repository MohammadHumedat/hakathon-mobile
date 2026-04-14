import 'package:flutter/material.dart';

import '../../models/enums.dart';

class StatusBadge extends StatelessWidget {
  final TicketStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _config[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.$1.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.$1),
      ),
      child: Text(
        config.$2,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: config.$1),
      ),
    );
  }

  static final _config = {
    TicketStatus.pending: (Colors.orange, 'PENDING'),
    TicketStatus.inProgress: (Colors.blue, 'IN PROGRESS'),
    TicketStatus.resolved: (Colors.green, 'RESOLVED'),
    TicketStatus.closed: (Colors.grey, 'CLOSED'),
  };
}
