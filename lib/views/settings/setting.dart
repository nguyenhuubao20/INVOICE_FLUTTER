import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: [
              SettingsTile(
                title: Text('Language'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Language'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('English'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              GestureDetector(
                                child: Text('Vietnamese'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SettingsTile(
                title: Text('Environment'),
                leading: Icon(Icons.cloud),
                onPressed: (BuildContext context) {
                  // Implement environment settings
                  // Example: Navigator.pushNamed(context, '/environment_settings');
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Account'),
            tiles: [
              SettingsTile(
                title: Text('Signout'),
                leading: Icon(Icons.logout),
                onPressed: (BuildContext context) {
                  // Implement logout functionality
                  // Example: Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
              SettingsTile(
                title: Text('Change password'),
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {
                  // Implement change password functionality
                  // Example: Navigator.pushNamed(context, '/change_password');
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Misc'),
            tiles: [
              SettingsTile(
                title: Text('Policy'),
                leading: Icon(Icons.policy),
                onPressed: (BuildContext context) {
                  // Implement policy settings
                  // Example: Navigator.pushNamed(context, '/policy_settings');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
