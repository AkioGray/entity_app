import 'dart:async';
import '../models/chat_message.dart';

class ChatRepository {
  static final ChatRepository _instance = ChatRepository._internal();
  
  factory ChatRepository() {
    return _instance;
  }
  
  ChatRepository._internal();

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'sys_1',
      text: 'Сәлем! Я Entity - твой ИИ-помощник. Чем могу помочь с ЕНТ или выбором ВУЗа?',
      isUser: false,
      timestamp: DateTime.now(),
    )
  ];

  List<ChatMessage> getMessages() {
    return _messages;
  }

  void addMessage(ChatMessage msg) {
    _messages.insert(0, msg);
  }

  Stream<String> getAiResponseStream(String query) async* {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final response = 'Это симуляция потокового ответа нейросети на ваш запрос: "$query". В будущем этот стриминг будет подключен к реальному бэкенду.';
    final words = response.split(' ');
    
    for (var word in words) {
      await Future.delayed(const Duration(milliseconds: 80));
      yield '$word ';
    }
  }
}