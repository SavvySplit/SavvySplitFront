import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../constants/colors.dart';
import 'personal_information_screen.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.gradientStart,
          appBar: AppBar(
            title: const Text('Account Information'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildAccountDetails(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userName = authProvider.userName ?? 'User';
        final userEmail = authProvider.userEmail ?? 'user@example.com';
        
        return Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.borderPrimary,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: AppColors.gradientEnd,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountDetails(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderPrimary, width: 1.0),
      ),
      child: Column(
        children: [
          _buildDetailItem(
            context: context,
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Update your name, email, and phone',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalInformationScreen(),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildDetailItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {},
          ),
          _buildDivider(),
          _buildDetailItem(
            context: context,
            icon: Icons.credit_card,
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            onTap: () {},
          ),
          _buildDivider(),
          _buildDetailItem(
            context: context,
            icon: Icons.notifications_none,
            title: 'Notification Preferences',
            subtitle: 'Manage your notifications',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.accentGradientMiddle.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.accentGradientMiddle),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white10,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
