part of 'notification_cubit.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int currentPage;
  final int totalCount;

  NotificationsLoaded({
    required this.notifications,
    required this.currentPage,
    required this.totalCount,
  });
}

final class NotificationSuccess extends NotificationState {
  final String message;
  NotificationSuccess(this.message);
}

final class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
