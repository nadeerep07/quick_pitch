import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:quick_pitch_app/core/services/cloudninary/cloudinary_services.dart';
import 'package:quick_pitch_app/features/chat/model/message_model.dart';
import 'package:quick_pitch_app/features/chat/repository/chat_repository.dart';
import 'package:quick_pitch_app/features/profile_completion/model/user_profile_model.dart';

part 'individual_chat_state.dart';

class IndividualChatCubit extends Cubit<IndividualChatState> {
  final ChatRepository chatRepository;
  final String chatId;
  final String currentUserId;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  IndividualChatCubit({
    required this.chatRepository,
    required this.chatId,
    required this.currentUserId,
  }) : super(IndividualChatLoading());

  void loadMessages() {
    emit(IndividualChatLoading());
        
    _messagesSubscription?.cancel();
        
    _messagesSubscription = chatRepository.getChatMessages(chatId).listen(
      (messages) {
        if (!isClosed) emit(IndividualChatLoaded(messages));
      },
      onError: (e) {
        if (!isClosed) emit(IndividualChatError(e.toString()));
      },
    );
  }

  Future<void> sendMessage(
    String text, 
    UserProfileModel sender, 
    UserProfileModel receiver,
    {List<File>? images}
  ) async {
    try {
      // Show sending state if we have a current loaded state
      if (state is IndividualChatLoaded) {
        final currentState = state as IndividualChatLoaded;
        emit(IndividualChatSending(currentState.messages));
      }

      List<AttachmentModel> attachments = [];
      MessageType messageType = MessageType.text;

      // Upload images if any
      if (images != null && images.isNotEmpty) {
        try {
          final imageUrls = await _cloudinaryService.uploadImagesToCloudinary(images);
          
          attachments = imageUrls.map((url) => AttachmentModel(
            url: url,
            type: 'image',
            fileName: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          )).toList();

          messageType = text.isNotEmpty ? MessageType.mixed : MessageType.image;
        } catch (uploadError) {
          if (!isClosed) {
            emit(IndividualChatError('Failed to upload images: $uploadError'));
          }
          return;
        }
      }

      await chatRepository.sendMessage(
        chatId: chatId,
        sender: sender,
        receiver: receiver,
        messageText: text,
        messageType: messageType,
        attachments: attachments,
      );

      // Reset to loaded state after successful send
      if (state is IndividualChatSending) {
        // The stream will automatically update with the new message
      }

    } catch (e) {
      if (!isClosed) {
        emit(IndividualChatError(e.toString()));
        // Try to recover to the previous state
        loadMessages();
      }
    }
  }

  Future<void> sendTextMessage(String text, UserProfileModel sender, UserProfileModel receiver) async {
    return sendMessage(text, sender, receiver);
  }

  Future<void> sendImageMessage(List<File> images, UserProfileModel sender, UserProfileModel receiver, {String? caption}) async {
    return sendMessage(caption ?? '', sender, receiver, images: images);
  }

  void markAsRead() {
    chatRepository.markMessagesAsRead(chatId, currentUserId);
  }

  void retryLastMessage() {
    // Implement retry logic if needed
    loadMessages();
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}