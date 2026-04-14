import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/ticket_model.dart';
import 'status_badge.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusBadge(status: ticket.status),
                  const SizedBox(width: 8),
                  _SectorChip(sector: ticket.sector),
                  const Spacer(),
                  _PriorityIcon(priority: ticket.priority),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${ticket.latitude.toStringAsFixed(3)}, ${ticket.longitude.toStringAsFixed(3)}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  if (ticket.createdAt != null)
                    Text(
                      _formatDate(ticket.createdAt!),
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _SectorChip extends StatelessWidget {
  final Sector sector;
  const _SectorChip({required this.sector});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        sector.name.toUpperCase(),
        style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}

class _PriorityIcon extends StatelessWidget {
  final Priority priority;
  const _PriorityIcon({required this.priority});

  @override
  Widget build(BuildContext context) {
    final colors = {
      Priority.low: Colors.green,
      Priority.medium: Colors.orange,
      Priority.high: Colors.red,
    };
    return Icon(Icons.flag, size: 18, color: colors[priority]);
  }
}
