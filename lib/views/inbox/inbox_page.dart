// dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_detail_page.dart';
import 'chat_list_tile.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isLightTheme ? Colors.black : theme.primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: isLightTheme
            ? theme.scaffoldBackgroundColor
            : (theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor),
        foregroundColor: isLightTheme
            ? Colors.black
            : (theme.appBarTheme.foregroundColor ?? theme.primaryColor),
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 20,
              color: isLightTheme ? Colors.black : theme.iconTheme.color,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              size: 20,
              color: isLightTheme ? Colors.black : theme.iconTheme.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          return ChatListTile(
            name: chat['name']!,
            lastMessage: chat['lastMessage']!,
            time: chat['time']!,
            avatar: chat['avatar']!,
            unreadCount: int.tryParse(chat['unreadCount'] ?? '0') ?? 0,
            isOnline: chat['isOnline'] == 'true',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(userName: chat['name']!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: isLightTheme
            ? Colors.white
            : (theme.floatingActionButtonTheme.backgroundColor ?? theme.primaryColor),
        child: Icon(
          Icons.add_comment_rounded,
          color: isLightTheme
              ? Colors.black
              : (theme.floatingActionButtonTheme.foregroundColor ?? Colors.white),
        ),
      ),
    );
  }
}

final List<Map<String, String>> _dummyChats = [
  {
    'name': 'Sarah Johnson',
    'lastMessage': 'Is the apartment still available?',
    'time': '10:24 AM',
    'avatar': 'https://randomuser.me/api/portraits/women/12.jpg',
    'unreadCount': '3',
    'isOnline': 'true',
  },
  {
    'name': 'Michael Rodriguez',
    'lastMessage': 'Thanks for the tour yesterday!',
    'time': 'Yesterday',
    'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
    'unreadCount': '0',
    'isOnline': 'false',
  },
  {
    'name': 'Emma Wilson',
    'lastMessage': 'I\'ll send the deposit today',
    'time': 'Yesterday',
    'avatar': 'https://randomuser.me/api/portraits/women/22.jpg',
    'unreadCount': '1',
    'isOnline': 'true',
  },
];