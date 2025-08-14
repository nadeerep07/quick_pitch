import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('chats');

  CollectionReference<Map<String, dynamic>> _messages(String chatId) =>
      _chats.doc(chatId).collection('messages');

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatsSnapshot(String userId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('sender.uid', isEqualTo: userId),
          Filter('receiver.uid', isEqualTo: userId),
        ))
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesSnapshot(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> updateChatAndSendMessage({
    required String chatId,
    required Map<String, dynamic> messageData,
    required Map<String, dynamic> chatUpdates,
  }) async {
    final chatDoc = _firestore.collection('chats').doc(chatId);
    final batch = _firestore.batch();

    batch.update(chatDoc, chatUpdates);
    batch.set(chatDoc.collection('messages').doc(), messageData);

    await batch.commit();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserRoleDoc(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfileDoc(
    String uid,
    String role,
  ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('roles')
        .doc(role)
        .get();
  }

  Future<void> createChat(String chatId, Map<String, dynamic> data) {
    return _firestore.collection('chats').doc(chatId).set(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getChatsForStatusUpdate(String userId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('sender.uid', isEqualTo: userId),
          Filter('receiver.uid', isEqualTo: userId),
        ))
        .get();
  }
    Future<void> markMessagesAsRead(String chatId, String userId) async {
    final batch = _firestore.batch();
    final chatRef = _chats.doc(chatId);

    final unread = await _messages(chatId)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final d in unread.docs) {
      batch.update(d.reference, {'isRead': true});
    }

    batch.update(chatRef, {
      'unreadCount.$userId': 0,
      'lastReadBy_$userId': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Helper used below by the repo when creating chat
  Future<DocumentSnapshot<Map<String, dynamic>>> getChatDoc(String chatId) {
    return _chats.doc(chatId).get();
  }


}
