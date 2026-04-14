import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/ticket_model.dart';
import '../../view_model/cubit/ticket_cubit.dart';
import '../widgets/status_badge.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;
  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TicketCubit>().loadTicketById(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Detail')),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TicketError) {
            return Center(child: Text(state.message));
          }
          if (state is TicketDetailLoaded) {
            return _buildDetail(context, state.ticket);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, TicketModel ticket) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ticket.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ticket.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatusBadge(status: ticket.status),
              const SizedBox(width: 8),
              _PriorityBadge(priority: ticket.priority),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Sector', value: ticket.sector.name.toUpperCase()),
          _InfoRow(
            label: 'Location',
            value:
                '${ticket.latitude.toStringAsFixed(4)}, ${ticket.longitude.toStringAsFixed(4)}',
          ),
          if (ticket.createdAt != null)
            _InfoRow(label: 'Created', value: ticket.createdAt!),
          const SizedBox(height: 16),
          Text('Description',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(ticket.description),
          const SizedBox(height: 32),
          _StatusUpdateSection(ticketId: ticket.id, current: ticket.status),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final Priority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final colors = {
      Priority.low: Colors.green,
      Priority.medium: Colors.orange,
      Priority.high: Colors.red,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[priority]!.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[priority]!),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors[priority]),
      ),
    );
  }
}

class _StatusUpdateSection extends StatelessWidget {
  final int ticketId;
  final TicketStatus current;
  const _StatusUpdateSection(
      {required this.ticketId, required this.current});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Update Status',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TicketStatus.values
              .where((s) => s != current)
              .map(
                (s) => OutlinedButton(
                  onPressed: () {
                    context
                        .read<TicketCubit>()
                        .updateTicketStatus(ticketId, status: s);
                    Navigator.pop(context);
                  },
                  child: StatusBadge(status: s),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
