import 'enums.dart';

class TicketModel {
  final int id;
  final int cityId;
  final String description;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final Sector sector;
  final Priority priority;
  final TicketStatus status;
  final String? createdAt;
  final String? userId;

  const TicketModel({
    required this.id,
    required this.cityId,
    required this.description,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.sector,
    required this.priority,
    required this.status,
    this.createdAt,
    this.userId,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: (json['id'] as num).toInt(),
      cityId: (json['cityId'] as num).toInt(),
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sector: Sector.fromInt((json['sector'] as num).toInt()),
      priority: Priority.fromInt((json['priority'] as num? ?? 0).toInt()),
      status: TicketStatus.fromInt((json['status'] as num? ?? 0).toInt()),
      createdAt: json['createdAt'] as String?,
      userId: json['userId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityId': cityId,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'sector': sector.toInt(),
      'priority': priority.toInt(),
      'status': status.toInt(),
      if (createdAt != null) 'createdAt': createdAt,
      if (userId != null) 'userId': userId,
    };
  }
}

class TicketStats {
  final int total;
  final int pending;
  final int inProgress;
  final int resolved;
  final int closed;

  const TicketStats({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  factory TicketStats.fromJson(Map<String, dynamic> json) {
    return TicketStats(
      total: (json['total'] as num? ?? 0).toInt(),
      pending: (json['pending'] as num? ?? 0).toInt(),
      inProgress: (json['inProgress'] as num? ?? 0).toInt(),
      resolved: (json['resolved'] as num? ?? 0).toInt(),
      closed: (json['closed'] as num? ?? 0).toInt(),
    );
  }
}
