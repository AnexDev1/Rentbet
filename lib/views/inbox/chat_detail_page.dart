import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String userName;

  const ChatDetailPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(userName, style: theme.textTheme.titleLarge),
        elevation: 1,
        backgroundColor: isLightTheme
            ? theme.scaffoldBackgroundColor
            : (theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor),
        iconTheme: IconThemeData(
          color: isLightTheme
              ? Colors.black
              : (theme.appBarTheme.foregroundColor ?? theme.primaryColor),
        ),
        foregroundColor: isLightTheme
            ? Colors.black
            : (theme.appBarTheme.foregroundColor ?? theme.primaryColor),
      ),
      body: Center(
        child: Text(
          'Chat messages will appear here',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}