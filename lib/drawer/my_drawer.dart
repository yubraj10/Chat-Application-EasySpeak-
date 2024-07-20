import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/support_screen.dart';
import '../services/auth_service.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthService _authService = AuthService();
  String? _fullName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final fullName = await _authService.fetchUserFullName();
    setState(() {
      _fullName = fullName;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[600]!],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.only(top: 48),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>  ProfileScreen()),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          _fullName != null ? _fullName![0].toUpperCase() : 'U',
                          style: TextStyle(fontSize: 30, color: Colors
                              .blue[800]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _fullName ?? 'User',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(
                    icon: Icons.home_rounded,
                    text: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  buildDrawerItem(
                    icon: Icons.support_agent_rounded,
                    text: 'Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                    },
                  ),
                  buildDrawerItem(
                    icon: Icons.settings_rounded,
                    text: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    },
                  ),
                  Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
                  buildDrawerItem(
                    icon: Icons.info_outline_rounded,
                    text: 'About',
                    onTap: () {
                      // TODO: Implement About screen
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.3), thickness: 1),
            buildDrawerItem(
              icon: Icons.logout_rounded,
              text: 'Logout',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}