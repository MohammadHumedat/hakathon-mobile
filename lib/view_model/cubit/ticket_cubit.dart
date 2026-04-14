import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_service.dart';

part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final TicketService _ticketService;

  TicketCubit(this._ticketService) : super(TicketInitial());

  Future<void> loadTickets({
    int page = 1,
    int pageSize = 10,
    TicketStatus? status,
    int? cityId,
    Sector? sector,
  }) async {
    emit(TicketLoading());
    try {
      final result = await _ticketService.getTickets(
        page: page,
        pageSize: pageSize,
        status: status,
        cityId: cityId,
        sector: sector,
      );
      emit(TicketsLoaded(
        tickets: result.items,
        currentPage: result.page,
        totalCount: result.totalCount,
        hasMore: result.items.length >= pageSize,
      ));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> loadMyTickets({int page = 1, int pageSize = 10}) async {
    emit(TicketLoading());
    try {
      final result = await _ticketService.getMyTickets(
        page: page,
        pageSize: pageSize,
      );
      emit(TicketsLoaded(
        tickets: result.items,
        currentPage: result.page,
        totalCount: result.totalCount,
        hasMore: result.items.length >= pageSize,
      ));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> loadTicketById(int id) async {
    emit(TicketLoading());
    try {
      final ticket = await _ticketService.getTicketById(id);
      emit(TicketDetailLoaded(ticket));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> loadStats() async {
    emit(TicketLoading());
    try {
      final stats = await _ticketService.getStats();
      emit(TicketStatsLoaded(stats));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> createTicket({
    required int cityId,
    required String description,
    required double latitude,
    required double longitude,
    required Sector sector,
    String? imageUrl,
    Priority priority = Priority.low,
  }) async {
    emit(TicketLoading());
    try {
      await _ticketService.createTicket(
        cityId: cityId,
        description: description,
        latitude: latitude,
        longitude: longitude,
        sector: sector,
        imageUrl: imageUrl,
        priority: priority,
      );
      emit(TicketSuccess('Ticket created successfully'));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> updateTicket(
    int id, {
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    Sector? sector,
    Priority? priority,
  }) async {
    emit(TicketLoading());
    try {
      await _ticketService.updateTicket(
        id,
        description: description,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
        sector: sector,
        priority: priority,
      );
      emit(TicketSuccess('Ticket updated successfully'));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> updateTicketStatus(
    int id, {
    required TicketStatus status,
    Priority? priority,
  }) async {
    emit(TicketLoading());
    try {
      await _ticketService.updateTicketStatus(
        id,
        status: status,
        priority: priority,
      );
      emit(TicketSuccess('Status updated'));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> deleteTicket(int id) async {
    emit(TicketLoading());
    try {
      await _ticketService.deleteTicket(id);
      emit(TicketSuccess('Ticket deleted'));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }
}
