import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  mixed, // text + image
}

class AttachmentModel {
  final String url;
  final String type; // 'image', 'video', etc.
  final String? fileName;
  final int? fileSize;

  AttachmentModel({
    required this.url,
    required this.type,
    this.fileName,
    this.fileSize,
  });

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      url: map['url'] ?? '',
      type: map['type'] ?? 'image',
      fileName: map['fileName'],
      fileSize: map['fileSize'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'type': type,
      'fileName': fileName,
      'fileSize': fileSize,
    };
  }
}

class MessageModel {
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final MessageType messageType;
  final List<AttachmentModel> attachments;
  final bool isRead;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.attachments = const [],
    this.isRead = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    List<AttachmentModel> attachmentList = [];
    if (map['attachments'] != null) {
      attachmentList = (map['attachments'] as List)
          .map((attachment) => AttachmentModel.fromMap(attachment))
          .toList();
    }

    return MessageModel(
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      messageType: MessageType.values.firstWhere(
        (type) => type.name == map['messageType'],
        orElse: () => MessageType.text,
      ),
      attachments: attachmentList,
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'messageType': messageType.name,
      'attachments': attachments.map((attachment) => attachment.toMap()).toList(),
      'isRead': isRead,
    };
  }
}