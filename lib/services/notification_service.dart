import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api;

  NotificationService({required ApiService api}) : _api = api;

  /// POST /api/Notification
  Future<void> createNotification({
    required String title,
    required String message,
    int? targetCityId,
    String? userId,
  }) async {
    await _api.post('/api/Notification', {
      'title': title,
      'message': message,
      if (targetCityId != null) 'targetCityId': targetCityId,
      if (userId != null) 'userId': userId,
    });
  }

  /// GET /api/Notification
  Future<PaginatedResult<NotificationModel>> getNotifications({
    int page = 1,
    int pageSize = 10,
  }) async {
    final params = {'page': '$page', 'pageSize': '$pageSize'};
    final response =
        await _api.get('/api/Notification', queryParams: params);
    return _parsePaginated(response);
  }

  /// GET /api/Notification/my
  Future<List<NotificationModel>> getMyNotifications() async {
    final response = await _api.get('/api/Notification/my');
    final list = response as List<dynamic>;
    return list
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// DELETE /api/Notification/{id}
  Future<void> deleteNotification(int id) async {
    await _api.delete('/api/Notification/$id');
  }

  PaginatedResult<NotificationModel> _parsePaginated(dynamic response) {
    if (response is List) {
      final items = response
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
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
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (map['page'] as num? ?? 1).toInt(),
      pageSize: (map['pageSize'] as num? ?? 10).toInt(),
      totalCount: (map['totalCount'] as num? ?? 0).toInt(),
    );
  }
}
