import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:quick_pitch_app/features/Fixie_ai/model/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final GenerativeModel model;
  late ChatSession chatSession;
  final String apiKey = dotenv.env['GEMINI_API_KEY']!;

  static const String systemPrompt = """
You are Fixie AI, an intelligent assistant specifically designed to help with Quick Pitch. 

Your role is to:
-Your job is to help users create compelling and clear task descriptions.
-Provide guidance on structure, required skills, deadlines, and expected outcomes
- Suggest improvements for presentations
- Answer questions about pitch techniques
- Offer feedback on business ideas
- Assist with investor presentation strategies

Always respond in a professional, encouraging, and constructive manner. Focus on practical, actionable advice related to pitching and business presentations. If asked about topics unrelated to pitching, gently redirect the conversation back to pitch-related assistance.

Keep responses concise but comprehensive, and always aim to add value to the user's pitching journey.
""";

  ChatBloc() : super(ChatInitial()) {
    _initializeModel();
    
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
    on<SendQuickAction>(_onSendQuickAction);
  }

  void _initializeModel() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1000,
      ),
    );
    chatSession = model.startChat();
  }

  Future<void> _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) async {
    final welcomeMessage = ChatMessage(
      text: "Welcome to Fixie AI! I'm here to help you create amazing task pitches and presentations. Whether you need help structuring your pitch, improving your content, or getting feedback on your business idea, I've got you covered. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    emit(ChatLoaded(messages: [welcomeMessage]));
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final userMessage = ChatMessage(
        text: event.message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      // Add user message and set loading
      emit(currentState.copyWith(
        messages: [...currentState.messages, userMessage],
        isLoading: true,
      ));

      try {
        final contextualMessage = _addContextToMessage(event.message);
        final response = await chatSession.sendMessage(Content.text(contextualMessage));
        
        final aiMessage = ChatMessage(
          text: response.text ?? 'Sorry, I couldn\'t generate a response.',
          isUser: false,
          timestamp: DateTime.now(),
        );

        final updatedState = state as ChatLoaded;
        emit(updatedState.copyWith(
          messages: [...updatedState.messages, aiMessage],
          isLoading: false,
        ));
      } catch (e) {
        final errorMessage = ChatMessage(
          text: 'Error: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        );

        final updatedState = state as ChatLoaded;
        emit(updatedState.copyWith(
          messages: [...updatedState.messages, errorMessage],
          isLoading: false,
        ));
      }
    }
  }

  Future<void> _onClearChat(ClearChat event, Emitter<ChatState> emit) async {
    chatSession = model.startChat();
    add(InitializeChat());
  }

  Future<void> _onSendQuickAction(SendQuickAction event, Emitter<ChatState> emit) async {
    add(SendMessage(event.action));
  }

  String _addContextToMessage(String message) {
    if (!_isPitchRelated(message)) {
      return "$message\n\n(Please provide guidance related to business pitching, presentations, or startup advice)";
    }
    return message;
  }

  bool _isPitchRelated(String message) {
    final pitchKeywords = [
      'task pitch', 'presentation', 'investor', 'business', 'startup',
      'deck', 'slide', 'funding', 'idea', 'revenue', 'market',
      'competition', 'strategy', 'plan', 'product', 'service'
    ];
    
    return pitchKeywords.any((keyword) => 
        message.toLowerCase().contains(keyword.toLowerCase()));
  }
}
