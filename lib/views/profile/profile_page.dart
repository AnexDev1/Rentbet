import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/common/widgets/sign_out_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final userEmail = Supabase.instance.client.auth.currentUser?.email ?? '';
    final canCreateListing = (userEmail == 'anexo@gmail.com');
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
                    children: [
                      ProfileAccountCard(canCreateListing: canCreateListing),
                      const SizedBox(height: 16),
                      const ProfileSettingsCard(),
                      const SizedBox(height: 24),
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