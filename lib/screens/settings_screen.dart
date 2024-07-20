import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildListTile(
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Privacy',
            icon: Icons.privacy_tip,
            onTap: () {},
          ),
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            secondary: const Icon(Icons.notifications),
            value: notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
            value: darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                darkModeEnabled = value;
              });
            },
          ),
          _buildSectionHeader('Appearance'),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: fontSize,
              min: 12,
              max: 24,
              divisions: 4,
              label: fontSize.round().toString(),
              onChanged: (double value) {
                setState(() {
                  fontSize = value;
                });
              },
            ),
          ),
          _buildSectionHeader('About'),
          _buildListTile(
            title: 'App Version',
            subtitle: '1.0.0',
            icon: Icons.info,
          ),
          _buildListTile(
            title: 'Terms of Service',
            icon: Icons.description,
            onTap: () {},
          ),
          _buildListTile(
            title: 'Privacy Policy',
            icon: Icons.policy,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: Icon(icon),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}