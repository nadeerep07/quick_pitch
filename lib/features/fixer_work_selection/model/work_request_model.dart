import 'package:cloud_firestore/cloud_firestore.dart';

class HireRequest {
  final String id;
  final String workId;
  final String fixerId;
  final String posterId;
  final String posterName;
  final String posterImage;
  final String workTitle;
  final String workDescription;
  final double workAmount;
  final List<String> workImages;
  final String workTime;
  final HireRequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final String? message;

  const HireRequest({
    required this.id,
    required this.workId,
    required this.fixerId,
    required this.posterId,
    required this.posterName,
    required this.posterImage,
    required this.workTitle,
    required this.workDescription,
    required this.workAmount,
    required this.workImages,
    required this.workTime,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.message,
  });

  factory HireRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HireRequest(
      id: doc.id,
      workId: data['workId'] ?? '',
      fixerId: data['fixerId'] ?? '',
      posterId: data['posterId'] ?? '',
      posterName: data['posterName'] ?? '',
      posterImage: data['posterImage'] ?? '',
      workTitle: data['workTitle'] ?? '',
      workDescription: data['workDescription'] ?? '',
      workAmount: (data['workAmount'] ?? 0.0).toDouble(),
      workImages: List<String>.from(data['workImages'] ?? []),
      workTime: data['workTime'] ?? '',
      status: HireRequestStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => HireRequestStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      respondedAt: data['respondedAt'] != null
          ? (data['respondedAt'] as Timestamp).toDate()
          : null,
      message: data['message'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'workId': workId,
      'fixerId': fixerId,
      'posterId': posterId,
      'posterName': posterName,
      'posterImage': posterImage,
      'workTitle': workTitle,
      'workDescription': workDescription,
      'workAmount': workAmount,
      'workImages': workImages,
      'workTime': workTime,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'message': message,
    };
  }

  HireRequest copyWith({
    String? id,
    String? workId,
    String? fixerId,
    String? posterId,
    String? posterName,
    String? posterImage,
    String? workTitle,
    String? workDescription,
    double? workAmount,
    List<String>? workImages,
    String? workTime,
    HireRequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    String? message,
  }) {
    return HireRequest(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      fixerId: fixerId ?? this.fixerId,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      posterImage: posterImage ?? this.posterImage,
      workTitle: workTitle ?? this.workTitle,
      workDescription: workDescription ?? this.workDescription,
      workAmount: workAmount ?? this.workAmount,
      workImages: workImages ?? this.workImages,
      workTime: workTime ?? this.workTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }
}

enum HireRequestStatus {
  pending,
  accepted,
  declined,
  completed,
  cancelled,
}

extension HireRequestStatusExtension on HireRequestStatus {
  String get displayName {
    switch (this) {
      case HireRequestStatus.pending:
        return 'Pending';
      case HireRequestStatus.accepted:
        return 'Accepted';
      case HireRequestStatus.declined:
        return 'Declined';
      case HireRequestStatus.completed:
        return 'Completed';
      case HireRequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive {
    return this == HireRequestStatus.pending || this == HireRequestStatus.accepted;
  }

  bool get canRespond {
    return this == HireRequestStatus.pending;
  }
}