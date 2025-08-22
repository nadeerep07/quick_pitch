import 'package:cloud_firestore/cloud_firestore.dart';

class FixerWork {
  final String id;
  final String title;
  final String description;
  final String time;
  final double amount;
  final List<String> images;
  final DateTime createdAt;
  final String fixerId;

  const FixerWork({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.amount,
    required this.images,
    required this.createdAt,
    required this.fixerId,
  });

  factory FixerWork.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FixerWork(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      fixerId: data['fixerId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'amount': amount,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
      'fixerId': fixerId,
    };
  }

  FixerWork copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    double? amount,
    List<String>? images,
    DateTime? createdAt,
    String? fixerId,
  }) {
    return FixerWork(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      amount: amount ?? this.amount,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      fixerId: fixerId ?? this.fixerId,
    );
  }
}