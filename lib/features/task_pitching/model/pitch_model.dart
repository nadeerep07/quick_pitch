import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';

class PitchModel {
  final String id;
  final String taskId;
  final String fixerId;
  final String fixerName;
  final String fixerimageUrl;
  final String pitchText;
  final double budget;
  final String? hours;
  final String timeline;
  final PaymentType paymentType;
  final DateTime createdAt;
  final String status;
  final String posterId;
  final String? posterName;
  final String? posterImage;
  final String? rejectionMessage;
  final int? progress;
  final String? latestUpdate;
  final DateTime? completionDate;
  final String? completionNotes;
  final String? paymentStatus;
  final DateTime? paymentRequestedAt;
  final double? requestedPaymentAmount;
  final String? paymentRequestNotes;
  final String? paymentDeclineReason; // New field
  final DateTime? paymentDeclinedAt; // New field
  final DateTime? paymentCompletedAt; // New field
  final String? transactionId; // New field
  final DateTime? updatedAt;

  PitchModel({
    required this.id,
    required this.taskId,
    required this.fixerId,
    required this.pitchText,
    required this.budget,
    required this.fixerName,
    required this.fixerimageUrl,
    this.hours,
    required this.timeline,
    required this.paymentType,
    required this.createdAt,
    this.status = 'pending',
    required this.posterId,
    this.posterName,
    this.posterImage,
    this.rejectionMessage,
    this.progress,
    this.latestUpdate,
    this.completionDate,
    this.completionNotes,
    this.paymentStatus,
    this.paymentRequestedAt,
    this.requestedPaymentAmount,
    this.paymentRequestNotes,
    this.paymentDeclineReason,
    this.paymentDeclinedAt,
    this.paymentCompletedAt,
    this.transactionId,
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
    'posterId': posterId,
    'posterName': posterName,
    'posterImage': posterImage,
    'rejectionMessage': rejectionMessage,
    'progress': progress,
    'latestUpdate': latestUpdate,
    'completionDate': completionDate,
    'completionNotes': completionNotes,
    'paymentStatus': paymentStatus,
    'paymentRequestedAt': paymentRequestedAt,
    'requestedPaymentAmount': requestedPaymentAmount,
    'paymentRequestNotes': paymentRequestNotes,
    'paymentDeclineReason': paymentDeclineReason,
    'paymentDeclinedAt': paymentDeclinedAt,
    'paymentCompletedAt': paymentCompletedAt,
    'transactionId': transactionId,
    'updatedAt': updatedAt,
    'fixerName': fixerName,
    'fixerimageUrl': fixerimageUrl
  };

factory PitchModel.fromJson(Map<String, dynamic> json, [String? id]) {
  DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  return PitchModel(
    id: json['id'] as String? ?? '',
    taskId: json['taskId'] as String? ?? '',
    fixerId: json['fixerId'] as String? ?? '',
    pitchText: json['pitchText'] as String? ?? '',
    budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
    hours: json['hours'] as String?,                        // fixed
    timeline: json['timeline'] as String? ?? '',
    paymentType: PaymentType.values.firstWhere(
      (e) => e.name == json['paymentType'],
      orElse: () => PaymentType.fixed,
    ),
    createdAt: parseDate(json['createdAt']),
    status: json['status'] as String? ?? 'pending',
    fixerName: json['fixerName'] as String? ?? '',
    fixerimageUrl: json['fixerimageUrl'] as String? ?? '',
    posterId: json['posterId'] as String? ?? '',
    posterName: json['posterName'] as String?,              // fixed
    posterImage: json['posterImage'] as String?,            // fixed
    rejectionMessage: json['rejectionMessage'] as String?,  // fixed
    progress: json['progress'] is int ? json['progress'] as int : null,
    latestUpdate: json['latestUpdate'] as String?,          // fixed
    completionDate:
        json['completionDate'] != null ? parseDate(json['completionDate']) : null,
    completionNotes: json['completionNotes'] as String?,    // fixed
    paymentStatus: json['paymentStatus'] as String?,        // fixed
    paymentRequestedAt:
        json['paymentRequestedAt'] != null ? parseDate(json['paymentRequestedAt']) : null,
    requestedPaymentAmount: (json['requestedPaymentAmount'] as num?)?.toDouble(),
    paymentRequestNotes: json['paymentRequestNotes'] as String?,  // fixed
    paymentDeclineReason: json['paymentDeclineReason'] as String?,// fixed
    paymentDeclinedAt:
        json['paymentDeclinedAt'] != null ? parseDate(json['paymentDeclinedAt']) : null,
    paymentCompletedAt:
        json['paymentCompletedAt'] != null ? parseDate(json['paymentCompletedAt']) : null,
    transactionId: json['transactionId'] as String?,        // fixed
    updatedAt: json['updatedAt'] != null ? parseDate(json['updatedAt']) : null,
  );
}

}