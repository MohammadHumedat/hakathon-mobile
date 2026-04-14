class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int? targetCityId;
  final String? userId;
  final String? createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.targetCityId,
    this.userId,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      targetCityId: (json['targetCityId'] as num?)?.toInt(),
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      if (targetCityId != null) 'targetCityId': targetCityId,
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });
}
