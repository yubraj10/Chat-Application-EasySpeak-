import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';

class UsersScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Users', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;
          final currentUserEmail = _auth.currentUser!.email;

          final otherUsers = users
              .where((user) => user['email'] != currentUserEmail)
              .toList();

          return ListView.builder(
            itemCount: otherUsers.length,
            itemBuilder: (context, index) {
              var user = otherUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  // You can modify this as per your user avatar setup
                  child: Text(user['fullname'][0].toUpperCase()),
                ),
                title: Text(user['fullname']),
                subtitle: Text(user['email']),
                onTap: () => Get.to(() => ChatScreen(
                  recipientEmail: user['email'],
                  recipientFullName: user['fullname'],
                )),
              );
            },
          );
        },
      ),
    );
  }
}
