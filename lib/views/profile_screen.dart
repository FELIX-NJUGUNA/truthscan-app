import 'package:flutter/material.dart';
import 'package:truthscan_app/services/auth_services.dart';
import 'package:truthscan_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();

  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String username = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User not logged in";
      email = prefs.getString('email') ?? "No email found";
      isDarkMode = prefs.getBool('darkMode') ?? false;
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear preferences on logout
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete your account? This action is irreversible.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account deleted (mock action).')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveDarkModePreference(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', val);
  }

  Future<void> _saveNotificationsPreference(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', val);
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  decoration: InputDecoration(labelText: 'Old Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // TODO: Connect to actual backend service
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password changed (mock action).')),
                  );
                },
                child: Text('Change'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('About TruthScan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("TruthScan v1.0.0"),
                SizedBox(height: 8),
                Text(
                  "An AI-powered text and document analysis tool designed to detect factual accuracy.",
                ),
                SizedBox(height: 12),
                Text("© 2025 TruthScan Inc."),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(email, style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text("Dark Mode"),
            secondary: Icon(Icons.dark_mode),
            value: isDarkMode,
            onChanged: (val) {
              setState(() => isDarkMode = val);
              _saveDarkModePreference(val);
            },
          ),
          SwitchListTile(
            title: Text("Enable Notifications"),
            secondary: Icon(Icons.notifications),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
              _saveNotificationsPreference(val);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
            onTap: () => _showChangePasswordDialog(context),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About"),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 40),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete Account", style: TextStyle(color: Colors.red)),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }
}
