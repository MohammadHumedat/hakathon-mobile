import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api;
  final StorageService _storage;

  AuthService({required ApiService api, required StorageService storage})
    : _api = api,
      _storage = storage;

  /// POST /api/Auth/Register
  Future<void> register({
    required String firstName,
    required String secondName,
    required String thirdName,
    required String lastName,
    required String phoneNumber,
    required String nationalId,
    required String userName,
    required String birthdate,
    required int cityId,
    required String email,
    required String password,
    String? roleName,
  }) async {
    await _api.post('/api/Auth/Register', {
      'firstName': firstName,
      'secondName': secondName,
      'thirdName': thirdName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'userName': userName,
      'birthdate': birthdate,
      'cityId': cityId,
      'email': email,
      'password': password,
      if (roleName != null) 'roleName': roleName,
    });
  }

  /// POST /api/Auth/Login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/api/Auth/Login', {
      'email': email,
      'password': password,
    }) as Map<String, dynamic>;

    final user = UserModel.fromJson(response);
    await _persistSession(user);
    return user;
  }

  /// POST /api/Auth/Refresh
  Future<UserModel> refreshToken() async {
    final refreshToken = _storage.getRefreshToken();
    if (refreshToken == null) throw ApiException('No refresh token stored');

    final response = await _api.post('/api/Auth/Refresh', {
      'refreshToken': refreshToken,
    }) as Map<String, dynamic>;

    final user = UserModel.fromJson(response);
    await _persistSession(user);
    return user;
  }

  /// POST /api/Auth/Logout
  Future<void> logout() async {
    final refreshToken = _storage.getRefreshToken();
    try {
      await _api.post('/api/Auth/Logout', {
        if (refreshToken != null) 'refreshToken': refreshToken,
      });
    } finally {
      _api.clearAuthToken();
      await _storage.clearAll();
    }
  }

  bool get isLoggedIn => _storage.getToken() != null;

  void restoreSession() {
    final token = _storage.getToken();
    if (token != null) {
      _api.setAuthToken(token);
    }
  }

  Future<void> _persistSession(UserModel user) async {
    if (user.token != null) {
      await _storage.saveToken(user.token!);
      _api.setAuthToken(user.token!);
    }
    if (user.refreshToken != null) {
      await _storage.saveRefreshToken(user.refreshToken!);
    }
    if (user.id.isNotEmpty) {
      await _storage.saveUserId(user.id);
    }
  }
}
