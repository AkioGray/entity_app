import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';
import '../data/chat_repository.dart';
import '../globals.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatRepository _repository = ChatRepository();
  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(_repository.getMessages());
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    
    final userText = _controller.text.trim();
    _controller.clear();

    final userMsg = ChatMessage(
      id: DateTime.now().toString(),
      text: userText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMsg);
      _repository.addMessage(userMsg);
      _isTyping = true;
    });

    final aiMsgId = DateTime.now().toString() + "_ai";
    String currentAiText = "";

    setState(() {
      _messages.insert(0, ChatMessage(
        id: aiMsgId,
        text: currentAiText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    await for (final chunk in _repository.getAiResponseStream(userText)) {
      if (!mounted) return;
      currentAiText += chunk;
      setState(() {
        _messages[0] = ChatMessage(
          id: aiMsgId,
          text: currentAiText,
          isUser: false,
          timestamp: DateTime.now(),
        );
      });
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _repository.addMessage(_messages[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: globalIsDarkMode,
      builder: (context, isDark, _) {
        final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final Color cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
        final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
        final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
        final Color borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardBgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textPrimary),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryCyan.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.smart_toy_rounded, color: primaryCyan, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Entity AI', style: GoogleFonts.spaceGrotesk(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: borderColor, height: 1),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildBubble(msg, primaryCyan, cardBgColor, textPrimary, isDark);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(color: textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Задайте вопрос...',
                              hintStyle: TextStyle(color: textSecondary),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _isTyping ? null : _sendMessage,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryCyan,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: primaryCyan.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))
                            ],
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildBubble(ChatMessage msg, Color primaryCyan, Color cardBgColor, Color textPrimary, bool isDark) {
    final bool isUser = msg.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? primaryCyan : cardBgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: isUser ? null : Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          msg.text,
          style: GoogleFonts.inter(
            color: isUser ? Colors.white : textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}