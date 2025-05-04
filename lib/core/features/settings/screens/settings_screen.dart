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
              AppColors.gradientStart,
              AppColors.gradientEnd,
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
                      _buildUserProfileSection(context),
                      const SizedBox(height: 24),
                      _buildAccountSettingsSection(context),
                      const SizedBox(height: 24),
                      _buildSecuritySection(context),
                      const SizedBox(height: 24),
                      _buildConnectedServicesSection(context),
                      const SizedBox(height: 24),
                      _buildDataManagementSection(context),
                      const SizedBox(height: 24),
                      _buildHelpSupportSection(context),
                      const SizedBox(height: 24),
                      _buildPremiumFeaturesSection(context),
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

  // Accent bar widget for section titles
  final Widget accentBar = const SizedBox(
    width: 5,
    height: 28,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: AppColors.accent,
      ),
    ),
  );

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          accentBar,
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        'Settings',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          fontSize: 24,
        ) ?? const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Profile'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.tealAccent.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.tealAccent),
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

  Widget _buildAccountSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Account Settings'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: const Icon(Icons.language, color: Colors.blueAccent),
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
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                  child: const Icon(Icons.dark_mode, color: Colors.tealAccent),
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

  Widget _buildConnectedServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Connected Services'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: const Icon(Icons.account_balance, color: Colors.blueAccent),
                ),
                title: const Text(
                  'Bank Accounts',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  '2 accounts connected',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                  child: const Icon(Icons.credit_card, color: Colors.purpleAccent),
                ),
                title: const Text(
                  'Payment Methods',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  '3 cards saved',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                  child: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                ),
                title: const Text(
                  'Connect New Service',
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

  Widget _buildDataManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Data Management'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amberAccent.withOpacity(0.2),
                  child: const Icon(Icons.backup, color: Colors.amberAccent),
                ),
                title: const Text(
                  'Backup & Restore',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Last backup: May 1, 2025',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
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
                  backgroundColor: Colors.tealAccent.withOpacity(0.2),
                  child: const Icon(Icons.download, color: Colors.tealAccent),
                ),
                title: const Text(
                  'Export Data',
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
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.redAccent,
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

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Security'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  child: const Icon(Icons.lock, color: Colors.redAccent),
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

  Widget _buildHelpSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Help & Support'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
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

  Widget _buildPremiumFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Premium Features'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.2),
                      Colors.blueAccent.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Upgrade to SavvySplit Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get advanced analytics, unlimited budgets, and premium support',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.amberAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purpleAccent.withOpacity(0.2),
                  child: const Icon(Icons.card_membership, color: Colors.purpleAccent),
                ),
                title: const Text(
                  'Subscription Management',
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
                  backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                  child: const Icon(Icons.redeem, color: Colors.orangeAccent),
                ),
                title: const Text(
                  'Redeem Promo Code',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderPrimary, width: 1.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              context.go('/login');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
