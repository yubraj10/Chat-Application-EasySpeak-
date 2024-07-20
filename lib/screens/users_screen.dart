import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class UsersScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
      ),
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

          return ListView.builder(
            itemCount: otherUsers.length,
            itemBuilder: (context, index) {
              var user = otherUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user['fullname'][0].toUpperCase()),
                ),
                title: Text(user['fullname']),
                onTap: () => _authService.navigateToChatScreen(
                  recipientEmail: user['email'],
                  recipientFullName: user['fullname'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
