part of 'ticket_cubit.dart';

sealed class TicketState {}

final class TicketInitial extends TicketState {}

final class TicketLoading extends TicketState {}

final class TicketsLoaded extends TicketState {
  final List<TicketModel> tickets;
  final int currentPage;
  final int totalCount;
  final bool hasMore;

  TicketsLoaded({
    required this.tickets,
    required this.currentPage,
    required this.totalCount,
    required this.hasMore,
  });
}

final class TicketDetailLoaded extends TicketState {
  final TicketModel ticket;
  TicketDetailLoaded(this.ticket);
}

final class TicketStatsLoaded extends TicketState {
  final TicketStats stats;
  TicketStatsLoaded(this.stats);
}

final class TicketSuccess extends TicketState {
  final String message;
  TicketSuccess(this.message);
}

final class TicketError extends TicketState {
  final String message;
  TicketError(this.message);
}
