import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../../view_models/theme_view_model.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = ThemeViewModel();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cài đặt'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Chung'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Chế độ tối'),
                leading: Icon(Icons.dark_mode),
                initialValue: themeViewModel.isDarkMode,
                onToggle: (bool value) {
                  themeViewModel.toggleDarkMode();
                },
              ),
              SettingsTile(
                title: Text('Ngôn ngữ'),
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lựa chọn ngôn ngữ'),
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
                                child: Text('Tiếng Việt'),
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
                title: Text('Môi trường'),
                leading: Icon(Icons.cloud),
                onPressed: (BuildContext context) {
                  // Implement environment settings
                  // Example: Navigator.pushNamed(context, '/environment_settings');
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Tài khoản'),
            tiles: [
              SettingsTile(
                title: Text('Đăng xuất'),
                leading: Icon(Icons.logout),
                onPressed: (BuildContext context) {
                  // Implement logout functionality
                  // Example: Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
              SettingsTile(
                title: Text('Thay đổi mật khẩu'),
                leading: Icon(Icons.lock),
                onPressed: (BuildContext context) {
                  // Implement change password functionality
                  // Example: Navigator.pushNamed(context, '/change_password');
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Khác'),
            tiles: [
              SettingsTile(
                title: Text('Chính sách'),
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
