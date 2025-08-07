import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_pitch_app/features/messages/fixer/model/chat_model.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---- OLD CHATS ----
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('sender.uid', isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data()))
            .toList());
  }

  // ---- NEW CHATS BASED ON TASKS ----
  Stream<List<ChatModel>> getChatsFromPosterTasks(String fixerId) {
    return _firestore
        .collection('poster_tasks')
        .where('assignedFixerId', isEqualTo: fixerId)
        .where('status', whereIn: ['accepted', 'completed'])
        .snapshots()
        .asyncMap((snapshot) async {
          final sender = await fetchCurrentUserProfile(fixerId);

          final futures = snapshot.docs.map((doc) async {
            final data = doc.data();
            final receiverId = data['posterId'];

            final receiverSnap = await _firestore
                .collection('users')
                .doc(receiverId)
                .get();

            if (!receiverSnap.exists) return null;

            final receiver = UserProfileModel.fromJson(receiverSnap.data()!);

            return ChatModel(
              chatId: doc.id,
              sender: sender,
              receiver: receiver,
              lastMessage: data['lastMessage'] ?? '',
              lastMessageTime:
                  (data['lastMessageTime'] as Timestamp?)?.toDate() ??
                      DateTime.now(),
              isReceiverOnline: true, // you can implement real status
              unreadCount: 0,
            );
          });

          final chats = await Future.wait(futures);
          return chats.whereType<ChatModel>().toList(); // Remove nulls
        });
  }

  // 🧱 Helper: Fetch fixer profile
  Future<UserProfileModel> fetchCurrentUserProfile(String uid) async {
    final userSnap = await _firestore.collection('users').doc(uid).collection('roles').doc('fixer').get();
    if (!userSnap.exists) {
      throw Exception("User not found");
    }
    return UserProfileModel.fromJson(userSnap.data()!);
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required UserProfileModel sender,
    required UserProfileModel receiver,
    required String messageText,
  }) async {
    final timestamp = DateTime.now();

    final chatDoc = _firestore.collection('chats').doc(chatId);

    await chatDoc.set({
      'chatId': chatId,
      'sender': sender.toRoleJson(),
      'receiver': receiver.toRoleJson(),
      'lastMessage': messageText,
      'lastMessageTime': timestamp,
      'unreadCount': FieldValue.increment(1),
      'isReceiverOnline': false,
    }, SetOptions(merge: true));

    await chatDoc.collection('messages').add({
      'text': messageText,
      'senderId': sender.uid,
      'receiverId': receiver.uid,
      'timestamp': timestamp,
    });
  }

  // Create chat
  Future<String> createChat({
    required UserProfileModel sender,
    required UserProfileModel receiver,
  }) async {
    final chatId = '${sender.uid}_${receiver.uid}';

    final chatDoc = _firestore.collection('chats').doc(chatId);

    await chatDoc.set({
      'chatId': chatId,
      'sender': sender.toRoleJson(),
      'receiver': receiver.toRoleJson(),
      'lastMessage': '',
      'lastMessageTime': DateTime.now(),
      'unreadCount': 0,
      'isReceiverOnline': false,
    });

    return chatId;
  }

  // Update online status
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    final chatsQuery = await _firestore
        .collection('chats')
        .where('receiver.uid', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();

    for (final doc in chatsQuery.docs) {
      batch.update(doc.reference, {'isReceiverOnline': isOnline});
    }

    await batch.commit();
  }
}
