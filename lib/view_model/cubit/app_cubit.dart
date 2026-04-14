import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_cubit.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final AuthCubit _authCubit;

  AppCubit(this._authCubit) : super(AppInitial());

  Future<void> initialize() async {
    emit(AppLoading());
    try {
      await _authCubit.checkAuthStatus();
      emit(AppReady());
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }
}
