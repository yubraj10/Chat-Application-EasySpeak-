import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String recipientEmail;
  final String recipientFullName;

  ChatScreen({required this.recipientEmail, required this.recipientFullName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String _chatRoomId;
  String? _currentUserFullName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chatRoomId = getChatRoomId(_auth.currentUser!.email!, widget.recipientEmail);
    _getCurrentUserFullName();
  }

  Future<void> _getCurrentUserFullName() async {
    try {
      final currentUser = _auth.currentUser!;
      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      setState(() {
        _currentUserFullName = userDoc['fullname'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  String getChatRoomId(String userA, String userB) {
    return userA.hashCode <= userB.hashCode
        ? '$userA-$userB'
        : '$userB-$userA';
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String messageText = _messageController.text;
      _messageController.clear(); // Clear the text field immediately

      await _firestore.collection('chat_rooms').doc(_chatRoomId).collection('messages').add({
        'text': messageText,
        'sender': _currentUserFullName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientFullName),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chat_rooms')
                  .doc(_chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSender = message['sender'] == _currentUserFullName;
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: isSender ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
