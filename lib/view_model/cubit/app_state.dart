part of 'app_cubit.dart';

sealed class AppState {}

final class AppInitial extends AppState {}

final class AppLoading extends AppState {}

final class AppReady extends AppState {}

final class AppError extends AppState {
  final String message;
  AppError(this.message);
}
