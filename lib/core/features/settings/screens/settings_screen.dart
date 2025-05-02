import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF010D21),
              const Color(0xFF060121),
              const Color(0xFF000046),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(context),
                      const SizedBox(height: 24),
                      _buildPreferencesSection(context),
                      const SizedBox(height: 24),
                      _buildSecuritySection(context),
                      const SizedBox(height: 24),
                      _buildSupportSection(context),
                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Settings',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.tealAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.tealAccent,
                  ),
                ),
                title: const Text(
                  'Account Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.purpleAccent,
                  ),
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.language,
                    color: Colors.blueAccent,
                  ),
                ),
                title: const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'English (US)',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amberAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.currency_exchange,
                    color: Colors.amberAccent,
                  ),
                ),
                title: const Text(
                  'Currency',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'USD (\$)',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              SwitchListTile(
                secondary: CircleAvatar(
                  backgroundColor: Colors.tealAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.dark_mode,
                    color: Colors.tealAccent,
                  ),
                ),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: true,
                activeColor: Colors.tealAccent,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                  ),
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              SwitchListTile(
                secondary: CircleAvatar(
                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.fingerprint,
                    color: Colors.greenAccent,
                  ),
                ),
                title: const Text(
                  'Biometric Authentication',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: false,
                activeColor: Colors.tealAccent,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.help_outline,
                    color: Colors.orangeAccent,
                  ),
                ),
                title: const Text(
                  'Help Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigoAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.indigoAccent,
                  ),
                ),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
              const Divider(
                color: Colors.white10,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                title: const Text(
                  'About SavvySplit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          context.go('/login');
        },
        icon: const Icon(Icons.logout),
        label: const Text('Log Out'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
