import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final UserService _userService;

  AuthCubit({
    required AuthService authService,
    required UserService userService,
  }) : _authService = authService,
       _userService = userService,
       super(AuthInitial());

  Future<void> checkAuthStatus() async {
    if (_authService.isLoggedIn) {
      _authService.restoreSession();
      try {
        emit(AuthLoading());
        final user = await _userService.getProfile();
        emit(AuthAuthenticated(user));
      } catch (_) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

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
    emit(AuthLoading());
    try {
      await _authService.register(
        firstName: firstName,
        secondName: secondName,
        thirdName: thirdName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        nationalId: nationalId,
        userName: userName,
        birthdate: birthdate,
        cityId: cityId,
        email: email,
        password: password,
        roleName: roleName,
      );
      // After register, log the user in to get a session
      await login(email: email, password: password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authService.logout();
    } finally {
      emit(AuthUnauthenticated());
    }
  }
}
