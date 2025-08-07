import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';

class PitchModel {
  final String id;
  final String taskId;
  final String fixerId;
  final String pitchText;
  final double budget;
  final String? hours;
  final String timeline;
  final PaymentType paymentType;
  final DateTime createdAt;
  final String status;
  final String? posterName;
  final String? posterImage;
  final String? rejectionMessage;
  final int? progress;
  final String? latestUpdate;
  final DateTime? completionDate;
  final String? completionNotes;
  final String? paymentStatus;
  final DateTime? paymentRequestedAt;
  final DateTime? updatedAt;

  PitchModel({
    required this.id,
    required this.taskId,
    required this.fixerId,
    required this.pitchText,
    required this.budget,
    this.hours,
    required this.timeline,
    required this.paymentType,
    required this.createdAt,
    this.status = 'pending',
    this.posterName,
    this.posterImage,
    this.rejectionMessage,
    this.progress,
    this.latestUpdate,
    this.completionDate,
    this.completionNotes,
    this.paymentStatus,
    this.paymentRequestedAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskId': taskId,
    'fixerId': fixerId,
    'pitchText': pitchText,
    'budget': budget,
    'hours': hours,
    'timeline': timeline,
    'paymentType': paymentType.name,
    'createdAt': createdAt,
    'status': status,
    'posterName': posterName,
    'posterImage': posterImage,
    'rejectionMessage': rejectionMessage,
    'progress': progress,
    'latestUpdate': latestUpdate,
    'completionDate': completionDate,
    'completionNotes': completionNotes,
    'paymentStatus': paymentStatus,
    'paymentRequestedAt': paymentRequestedAt,
    'updatedAt': updatedAt,
  };

  factory PitchModel.fromJson(Map<String, dynamic> json, [String? id]) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return PitchModel(
      id: json['id'] ?? '',
      taskId: json['taskId'] ?? '',
      fixerId: json['fixerId'] ?? '',
      pitchText: json['pitchText'] ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      hours: json['hours'],
      timeline: json['timeline'] ?? '',
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == json['paymentType'],
        orElse: () => PaymentType.fixed,
      ),
      createdAt: parseDate(json['createdAt']),
      status: json['status'] ?? 'pending',
      posterName: json['posterName'],
      posterImage: json['posterImage'],
      rejectionMessage: json['rejectionMessage'],
      progress: json['progress'] != null ? json['progress'] as int : null,
      latestUpdate: json['latestUpdate'],
      completionDate:
          json['completionDate'] != null
              ? parseDate(json['completionDate'])
              : null,
      completionNotes: json['completionNotes'],
      paymentStatus: json['paymentStatus'],
      paymentRequestedAt:
          json['paymentRequestedAt'] != null
              ? parseDate(json['paymentRequestedAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null ? parseDate(json['updatedAt']) : null,
    );
  }
}
