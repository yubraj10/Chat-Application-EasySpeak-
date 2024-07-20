import 'package:flutter/material.dart';
import '../drawer/my_drawer.dart';
import '../screens/home_page.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../services/auth_service.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  String? _fullName;
  bool _isLoading = true;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProfileScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final fullName = await _authService.fetchUserFullName();
      setState(() {
        _fullName = fullName;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _selectedIndex == 0
            ? Text(
          "Hi, ${_fullName ?? 'User'}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
            : _selectedIndex == 1
            ? const Text('Profile')
            : const Text('Settings'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const MyDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.3),
        onTap: _onItemTapped,
      ),
    );
  }
}
