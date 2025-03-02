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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                const SizedBox(height: 16),
                const SignOutButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}