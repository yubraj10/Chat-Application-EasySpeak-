import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_chatapplication/my_drawer.dart';
import 'package:online_chatapplication/users_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          _fullName = userDoc['fullname'];

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '$_fullName',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight
                    .bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => UsersScreen()),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Start Chatting',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
