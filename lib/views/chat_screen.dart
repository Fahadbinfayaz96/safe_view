import 'package:flutter/material.dart';
import 'package:safe_view/untilities/app_colors.dart';
import 'package:safe_view/widgets/background_gradient_color_wiget.dart';
import 'package:safe_view/widgets/text_wiget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<_ChatMessage> messages = [
    _ChatMessage(text: "Hello! How can I help you?", isSentByMe: false),
    _ChatMessage(text: "I need assistance with the filters.", isSentByMe: true),
    _ChatMessage(text: "Sure, I can help with that!", isSentByMe: false),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(_ChatMessage(text: text, isSentByMe: true));
      });
      _controller.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue2.withOpacity(0.1),
      appBar: AppBar(
        title: TextWidget(
          text: "Recent History",
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        backgroundColor: AppColors.lightBlue2,
        automaticallyImplyLeading: true,
        scrolledUnderElevation: 0,
      ),
      body: BackgroundGradientColorWiget(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message.isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: message.isSentByMe
                            ? AppColors.drakGreen
                            : AppColors.lightGrey2,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: message.isSentByMe
                              ? const Radius.circular(12)
                              : const Radius.circular(0),
                          bottomRight: message.isSentByMe
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                        ),
                      ),
                      child: TextWidget(
                          text: message.text,
                          fontSize: 16,
                          textColor: AppColors.white),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                    
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        hintText: "Type a message...",
                           enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.blue,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: AppColors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.red)),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isSentByMe;

  _ChatMessage({required this.text, required this.isSentByMe});
}
