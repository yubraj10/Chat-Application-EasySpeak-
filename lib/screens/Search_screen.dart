import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _isSearching = true;
              });
              _searchUsers(value);
            } else {
              setState(() {
                _isSearching = false;
                _searchResults.clear();
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _isSearching = false;
                _searchResults.clear();
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (!_isSearching) {
      return Center(child: Text('Type to search users'));
    }

    if (_searchResults.isEmpty) {
      return Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user['fullname'][0].toUpperCase()),
          ),
          title: Text(user['fullname']),
          subtitle: Text(user['email']),
          onTap: () {
            _authService.navigateToChatScreen(
              recipientEmail: user['email'],
              recipientFullName: user['fullname'],
            );
          },
        );
      },
    );
  }

  void _searchUsers(String searchTerm) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('fullname', isGreaterThanOrEqualTo: searchTerm)
        .where('fullname', isLessThan: searchTerm + 'z')
        .get();

    setState(() {
      _searchResults = result.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((user) => user['email'] != _authService.currentUser!.email)
          .toList();
    });
  }
}