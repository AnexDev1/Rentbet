// lib/views/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/common/widgets/sign_out_button.dart';
import '../../providers/user_provider.dart';
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_stats_card.dart';
import 'widgets/profile_account_card.dart';
import 'widgets/profile_settings_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (!userProvider.isDataLoaded) {
        userProvider.fetchUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          const ProfileAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileStatsCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: const [
                      ProfileAccountCard(),
                      SizedBox(height: 16),
                      ProfileSettingsCard(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                // Add some space before the sign-out button
                const SizedBox(height: 16),
                // Add the sign-out button separated from other cards
                const SignOutButton(),
                const SizedBox(height: 32), // Extra space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}