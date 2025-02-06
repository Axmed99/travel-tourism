import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Somali';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF008080),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: (value) => setState(() => _darkModeEnabled = value),
          ),
          ListTile(
            title: const Text('Luqadda'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Dooro Luqadda'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        setState(() => _selectedLanguage = 'Somali');
                        Navigator.pop(context);
                      },
                      child: const Text('Somali'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        setState(() => _selectedLanguage = 'English');
                        Navigator.pop(context);
                      },
                      child: const Text('English'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 