import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String userName;

  const ChatDetailPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Chat messages will appear here'),
      ),
    );
  }
}