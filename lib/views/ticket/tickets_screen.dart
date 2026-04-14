import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_router.dart';
import '../../models/enums.dart';
import '../../view_model/cubit/ticket_cubit.dart';
import '../widgets/status_badge.dart';
import '../widgets/ticket_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with AutomaticKeepAliveClientMixin {
  TicketStatus? _filterStatus;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<TicketCubit>().loadMyTickets();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
        actions: [
          PopupMenuButton<TicketStatus?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() => _filterStatus = status);
              context.read<TicketCubit>().loadMyTickets();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('All')),
              ...TicketStatus.values.map(
                (s) => PopupMenuItem(
                  value: s,
                  child: StatusBadge(status: s),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TicketError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<TicketCubit>().loadMyTickets(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TicketsLoaded) {
            final tickets = _filterStatus == null
                ? state.tickets
                : state.tickets
                    .where((t) => t.status == _filterStatus)
                    .toList();
            if (tickets.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('No tickets found', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TicketCubit>().loadMyTickets(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => TicketCard(
                  ticket: tickets[i],
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.ticketDetail,
                    arguments: tickets[i].id,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRouter.createTicket),
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
    );
  }
}
