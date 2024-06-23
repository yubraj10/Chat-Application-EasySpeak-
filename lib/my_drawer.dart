import 'package:flutter/material.dart';
import 'package:online_chatapplication/login_screen.dart';
import 'package:online_chatapplication/support_screen.dart';
import 'package:online_chatapplication/users_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerItem(
                    icon: Icons.home,
                    text: 'HOME',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Home screen if applicable
                    },
                  ),
                  buildDrawerItem(
                    icon: Icons.person,
                    text: 'USERS',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UsersScreen()));
                    },
                  ),
                  buildDrawerItem(
                    icon: Icons.contact_mail,
                    text: 'SUPPORT',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SupportScreen()));
                    },
                  ),
                ],
              ),
            ),
            buildDrawerItem(
              icon: Icons.logout,
              text: 'LOGOUT',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
