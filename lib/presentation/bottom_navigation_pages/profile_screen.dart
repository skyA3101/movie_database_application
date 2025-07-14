import 'package:movie_mania/core/utilities/imports.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              AppStrings.userName[0],
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              AppStrings.userName,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const Divider(color: Colors.white54, height: 32),
          _buildListTile(Icons.bookmark, 'Bookmarks', () {
            Navigator.pushReplacementNamed(context, '/bookmarks');
          }),
          _buildListTile(Icons.download, 'Downloads', () {}),
          _buildListTile(Icons.brightness_6, 'Dark Theme', () {
            // Theme toggle logic
          }),
          _buildListTile(Icons.info, 'App Version', () {
            showAboutDialog(
              context: context,
              applicationName: AppStrings.appName,
              applicationVersion: '1.0.0',
            );
          }),
          _buildListTile(Icons.logout, 'Logout', () {
            // Logout logic
          }),
        ],
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
      onTap: onTap,
    );
  }
}
