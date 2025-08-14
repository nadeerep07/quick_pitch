import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }
}