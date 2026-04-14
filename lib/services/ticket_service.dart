import '../models/enums.dart';
import '../models/notification_model.dart';
import '../models/ticket_model.dart';
import 'api_service.dart';

class TicketService {
  final ApiService _api;

  TicketService({required ApiService api}) : _api = api;

  /// POST /api/Ticket
  Future<void> createTicket({
    required int cityId,
    required String description,
    required double latitude,
    required double longitude,
    required Sector sector,
    String? imageUrl,
    Priority priority = Priority.low,
  }) async {
    await _api.post('/api/Ticket', {
      'cityId': cityId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'sector': sector.toInt(),
      'priority': priority.toInt(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    });
  }

  /// GET /api/Ticket
  Future<PaginatedResult<TicketModel>> getTickets({
    int page = 1,
    int pageSize = 10,
    TicketStatus? status,
    int? cityId,
    Sector? sector,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (status != null) 'status': '${status.toInt()}',
      if (cityId != null) 'cityId': '$cityId',
      if (sector != null) 'sector': '${sector.toInt()}',
    };
    final response = await _api.get('/api/Ticket', queryParams: params);
    return _parsePaginated(response);
  }

  /// GET /api/Ticket/stats
  Future<TicketStats> getStats() async {
    final response =
        await _api.get('/api/Ticket/stats') as Map<String, dynamic>;
    return TicketStats.fromJson(response);
  }

  /// GET /api/Ticket/my
  Future<PaginatedResult<TicketModel>> getMyTickets({
    int page = 1,
    int pageSize = 10,
  }) async {
    final params = {'page': '$page', 'pageSize': '$pageSize'};
    final response = await _api.get('/api/Ticket/my', queryParams: params);
    return _parsePaginated(response);
  }

  /// GET /api/Ticket/{id}
  Future<TicketModel> getTicketById(int id) async {
    final response =
        await _api.get('/api/Ticket/$id') as Map<String, dynamic>;
    return TicketModel.fromJson(response);
  }

  /// PATCH /api/Ticket/{id}
  Future<void> updateTicket(
    int id, {
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    Sector? sector,
    Priority? priority,
  }) async {
    await _api.patch('/api/Ticket/$id', {
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (sector != null) 'sector': sector.toInt(),
      if (priority != null) 'priority': priority.toInt(),
    });
  }

  /// PUT /api/Ticket/{id}/status
  Future<void> updateTicketStatus(
    int id, {
    required TicketStatus status,
    Priority? priority,
  }) async {
    await _api.put('/api/Ticket/$id/status', {
      'status': status.toInt(),
      if (priority != null) 'priority': priority.toInt(),
    });
  }

  /// DELETE /api/Ticket/{id}
  Future<void> deleteTicket(int id) async {
    await _api.delete('/api/Ticket/$id');
  }

  PaginatedResult<TicketModel> _parsePaginated(dynamic response) {
    if (response is List) {
      final items = response
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResult(
        items: items,
        page: 1,
        pageSize: items.length,
        totalCount: items.length,
      );
    }
    final map = response as Map<String, dynamic>;
    final rawItems = (map['items'] ?? map['data'] ?? []) as List<dynamic>;
    return PaginatedResult(
      items: rawItems
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (map['page'] as num? ?? 1).toInt(),
      pageSize: (map['pageSize'] as num? ?? 10).toInt(),
      totalCount: (map['totalCount'] as num? ?? 0).toInt(),
    );
  }
}
