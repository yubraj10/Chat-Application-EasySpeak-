import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

import 'Search_screen.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _authService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;
          final currentUserEmail = _authService.currentUser!.email;

          final otherUsers = users.where((user) => user['email'] != currentUserEmail).toList();

          if (otherUsers.isEmpty) {
            return const Center(child: Text('No other users found.'));
          }

          return ListView.separated(
            itemCount: otherUsers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              var user = otherUsers[index];
              return ChatListItem(user: user, authService: _authService, currentUserEmail: currentUserEmail!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Get.to(()=>
       SearchScreen()),
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final AuthService authService;
  final String currentUserEmail;

  const ChatListItem({
    Key? key,
    required this.user,
    required this.authService,
    required this.currentUserEmail
  }) : super(key: key);

  String getChatRoomId(String a, String b) {
    if (a.compareTo(b) > 0) return '$b\_$a';
    return '$a\_$b';
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomId = getChatRoomId(currentUserEmail, user['email']);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        String lastMessage = 'Tap to Message';
        String lastMessageTime = '';

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var lastMessageDoc = snapshot.data!.docs.first;
          lastMessage = lastMessageDoc['message'];
          lastMessageTime = _formatTimestamp(lastMessageDoc['timestamp'] as Timestamp);
        }

        return ListTile(
          leading: GestureDetector(
            onTap: () => _navigateToChat(context),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue,
              child: Text(
                user['fullname'][0].toUpperCase(),
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          title: Text(
            user['fullname'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            lastMessage,
            style: const TextStyle(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: lastMessageTime.isNotEmpty
              ? Text(
            lastMessageTime,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
              : null,
          onTap: () => _navigateToChat(context),
        );
      },
    );
  }

  void _navigateToChat(BuildContext context) {
    authService.navigateToChatScreen(
      recipientEmail: user['email'],
      recipientFullName: user['fullname'],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.isAfter(today)) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (dateTime.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}