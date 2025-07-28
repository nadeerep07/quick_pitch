import 'package:quick_pitch_app/features/task_pitching/viewmodel/pitch_form/cubit/pitch_form_cubit.dart';

class PitchModel {
  final String taskId;     
  final String fixerId;      
  final String pitchText;
  final double budget;
  final int? hours;
  final String timeline;
  final PaymentType paymentType;
  final DateTime createdAt;

  PitchModel({
    required this.taskId,
    required this.fixerId,
    required this.pitchText,
    required this.budget,
    this.hours,
    required this.timeline,
    required this.paymentType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'fixerId': fixerId,
        'pitchText': pitchText,
        'budget': budget,
        'hours': hours,
        'timeline': timeline,
        'paymentType': paymentType.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PitchModel.fromJson(Map<String, dynamic> json) {
    return PitchModel(
      taskId: json['taskId'],
      fixerId: json['fixerId'],
      pitchText: json['pitchText'],
      budget: (json['budget'] as num).toDouble(),
      hours: json['hours'],
      timeline: json['timeline'],
        paymentType: PaymentType.values.firstWhere(
        (e) => e.name == json['paymentType'],
        orElse: () => PaymentType.fixed,
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
