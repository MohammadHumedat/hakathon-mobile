import '../models/user_model.dart';
import '../models/notification_model.dart';
import 'api_service.dart';

class UserService {
  final ApiService _api;

  UserService({required ApiService api}) : _api = api;

  /// GET /api/User/profile
  Future<UserModel> getProfile() async {
    final response =
        await _api.get('/api/User/profile') as Map<String, dynamic>;
    return UserModel.fromJson(response);
  }

  /// PUT /api/User/profile
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    int? cityId,
  }) async {
    await _api.put('/api/User/profile', {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (cityId != null) 'cityId': cityId,
    });
  }

  /// GET /api/User  (admin)
  Future<PaginatedResult<UserModel>> getUsers({
    int page = 1,
    int pageSize = 10,
    String? role,
  }) async {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (role != null) 'role': role,
    };
    final response = await _api.get('/api/User', queryParams: params);
    if (response is List) {
      final items = response
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResult(
        items: items,
        page: page,
        pageSize: pageSize,
        totalCount: items.length,
      );
    }
    final map = response as Map<String, dynamic>;
    final rawItems = (map['items'] ?? map['data'] ?? []) as List<dynamic>;
    return PaginatedResult(
      items: rawItems
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (map['page'] as num? ?? 1).toInt(),
      pageSize: (map['pageSize'] as num? ?? 10).toInt(),
      totalCount: (map['totalCount'] as num? ?? 0).toInt(),
    );
  }
}
