import 'package:flutter/material.dart';
import 'package:hajj_app/models/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class EmergencyPage extends StatefulWidget {
  static const String id = 'EmergencyPage';

  static const apiKey = "AIzaSyD86XwJzBs7VD2HZW-f4MXxyybGOBjienk";

  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final TextEditingController _userInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final model = GenerativeModel(model: 'gemini-pro', apiKey: EmergencyPage.apiKey);

  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();

    // Listen for focus changes to detect when the keyboard is shown
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  Future<void> sendMessage() async {
    final message = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    // Clear the input field
    _userInput.clear();

    // Hide the keyboard
    FocusScope.of(context).unfocus();

    // Scroll to the end of the list after adding user's message
    _scrollToBottom();

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    // Scroll to the end of the list after receiving the response
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _userInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff323232),
        title: const Text(
          'المساعدة',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop),
                image: const AssetImage('assets/images/chat.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Messages(
                          isUser: message.isUser,
                          message: message.message,
                          date: DateFormat('HH:mm').format(message.date));
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: Container(
                      color: const Color(0xffBDBDBD),
                      child: TextFormField(
                        focusNode: _focusNode,
                        style: const TextStyle(
                            color: Colors.black,
                            backgroundColor: Color(0xffBDBDBD),
                            fontSize: 22),
                        controller: _userInput,
                        decoration: InputDecoration(
                          focusColor: const Color(0xffBDBDBD),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                          hintText:
                            'Enter Your Message',
                            // style:
                            // TextStyle(color: Colors.black, fontSize: 16),
                          
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      padding: const EdgeInsets.all(12),
                      iconSize: 30,
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black),
                          foregroundColor:
                          MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(const CircleBorder())),
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


