import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/chat/fixer/model/message_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getUserChats(String userId) async* {
    try {
      final userRole = await detectUserRole(userId);
      
      if (userRole == null) {
        yield [];
        return;
      }
      
      debugPrint("Loading chats for user: $userId with role: $userRole");
      
      yield* _firestore
          .collection('chats')
          .where(Filter.or(
            Filter('sender.uid', isEqualTo: userId),
            Filter('receiver.uid', isEqualTo: userId),
          ))
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
            final List<ChatModel> chats = [];

            for (final doc in snapshot.docs) {
              try {
                final data = doc.data();
                
                final senderUid = data['sender']?['uid'];
                final senderRole = data['sender']?['role'];
                final receiverUid = data['receiver']?['uid'];
                final receiverRole = data['receiver']?['role'];
                
                bool shouldIncludeChat = false;
                
                if (senderUid == userId && senderRole == userRole) {
                  shouldIncludeChat = true;
                } else if (receiverUid == userId && receiverRole == userRole) {
                  shouldIncludeChat = true;
                }
                
                if (shouldIncludeChat) {
                  final chat = ChatModel.fromMapWithContext(data, userId);
                  chats.add(chat);
                }
              } catch (e) {
                debugPrint('Error loading chat: $e');
              }
            }

            return chats;
          });
    } catch (e) {
      debugPrint('Error in getUserChats: $e');
      yield [];
    }
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required UserProfileModel sender,
    required UserProfileModel receiver,
    required String messageText,
  }) async {
    final timestamp = DateTime.now();
    final chatDoc = _firestore.collection('chats').doc(chatId);

    try {
      final batch = _firestore.batch();

      // Update chat metadata
      batch.update(chatDoc, {
        'lastMessage': messageText,
        'lastMessageTime': timestamp,
        'unreadCount': FieldValue.increment(1),
      });

      // Add message to messages subcollection
      final messageDoc = chatDoc.collection('messages').doc();
      batch.set(messageDoc, {
        'text': messageText,
        'senderId': sender.uid,
        'receiverId': receiver.uid,
        'timestamp': timestamp,
        'isRead': false,
      });

      await batch.commit();
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw e;
    }
  }

  Future<String> createOrGetChat({
    required UserProfileModel sender,
    required UserProfileModel receiver,
  }) async {
    if (sender.uid == receiver.uid) {
      throw Exception("Cannot create chat with self");
    }

    final chatId = generateChatId(
      userId1: sender.uid,
      role1: sender.role,
      userId2: receiver.uid,
      role2: receiver.role,
    );

    try {
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      
      if (!chatDoc.exists) {
        await _firestore.collection('chats').doc(chatId).set({
          'chatId': chatId,
          'sender': sender.toRoleJson(),
          'receiver': receiver.toRoleJson(),
          'lastMessage': '',
          'lastMessageTime': DateTime.now(),
          'unreadCount': 0,
          'isReceiverOnline': false,
        });
      }

      return chatId;
    } catch (e) {
      debugPrint('Error creating/getting chat: $e');
      throw e;
    }
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      final batch = _firestore.batch();
      final chatDoc = _firestore.collection('chats').doc(chatId);
      
      // Update messages
      final messages = await chatDoc
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
          
      for (final doc in messages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      
      // Update chat document
      batch.update(chatDoc, {
        'unreadCount': 0,
        'lastReadBy_$userId': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
      throw e;
    }
  }

  Future<UserProfileModel> fetchCurrentUserProfileByRole(
    String uid, {
    required String role,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('roles')
          .doc(role)
          .get();

      if (!doc.exists) throw Exception("User role not found");
      return UserProfileModel.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      throw e;
    }
  }

  Future<String?> detectUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['activeRole'] as String?;
    } catch (e) {
      debugPrint('Error detecting user role: $e');
      return null;
    }
  }

  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      final batch = _firestore.batch();
      final chats = await _firestore
          .collection('chats')
          .where(Filter.or(
            Filter('sender.uid', isEqualTo: userId),
            Filter('receiver.uid', isEqualTo: userId),
          ))
          .get();

      for (final doc in chats.docs) {
        final data = doc.data();
        if (data['receiver']?['uid'] == userId) {
          batch.update(doc.reference, {'isReceiverOnline': isOnline});
        }
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error updating online status: $e');
    }
  }

  String generateChatId({
    required String userId1,
    required String role1,
    required String userId2,
    required String role2,
  }) {
    return '${userId1}-${role1}_${userId2}-${role2}';
  }
}