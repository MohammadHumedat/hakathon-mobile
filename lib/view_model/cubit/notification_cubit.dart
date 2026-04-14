import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;

  NotificationCubit(this._notificationService) : super(NotificationInitial());

  Future<void> loadNotifications({int page = 1, int pageSize = 10}) async {
    emit(NotificationLoading());
    try {
      final result = await _notificationService.getNotifications(
        page: page,
        pageSize: pageSize,
      );
      emit(NotificationsLoaded(
        notifications: result.items,
        currentPage: result.page,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> loadMyNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications =
          await _notificationService.getMyNotifications();
      emit(NotificationsLoaded(
        notifications: notifications,
        currentPage: 1,
        totalCount: notifications.length,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> sendNotification({
    required String title,
    required String message,
    int? targetCityId,
    String? userId,
  }) async {
    emit(NotificationLoading());
    try {
      await _notificationService.createNotification(
        title: title,
        message: message,
        targetCityId: targetCityId,
        userId: userId,
      );
      emit(NotificationSuccess('Notification sent'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(int id) async {
    emit(NotificationLoading());
    try {
      await _notificationService.deleteNotification(id);
      emit(NotificationSuccess('Notification deleted'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
