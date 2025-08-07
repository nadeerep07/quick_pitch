import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatModel {
  final String chatId;
  final UserProfileModel sender;
  final UserProfileModel receiver;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isReceiverOnline;
  final int unreadCount;

  ChatModel({
    required this.chatId,
    required this.sender,
    required this.receiver,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isReceiverOnline,
    required this.unreadCount,
  });

  // Helper methods for UI compatibility
  String get id => chatId;
  String get name => receiver.name;
  bool get isOnline => isReceiverOnline;

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'],
      sender: UserProfileModel.fromJson(map['sender']),
      receiver: UserProfileModel.fromJson(map['receiver']),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      isReceiverOnline: map['isReceiverOnline'] ?? false,
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'sender': sender.toRoleJson(),
      'receiver': receiver.toRoleJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'isReceiverOnline': isReceiverOnline,
      'unreadCount': unreadCount,
    };
  }

  ChatModel copyWith({
    String? chatId,
    UserProfileModel? sender,
    UserProfileModel? receiver,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isReceiverOnline,
    int? unreadCount,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isReceiverOnline: isReceiverOnline ?? this.isReceiverOnline,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  // Helper method for updating online status
  ChatModel copyWithOnlineStatus(bool isOnline) {
    return copyWith(isReceiverOnline: isOnline);
  }
}