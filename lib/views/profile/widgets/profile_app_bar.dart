// dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
            ),
          ),
          child: SafeArea(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.user;
                final isLoading = userProvider.isLoading;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.onPrimary, width: 3),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                          : CircleAvatar(
                        radius: 42,
                        backgroundImage: (user != null &&
                            user.profileImage != null &&
                            user.profileImage!.isNotEmpty)
                            ? NetworkImage(user.profileImage!)
                            : const AssetImage('assets/logo.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                    else
                      Text(
                        user?.username ?? "User",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    if (!isLoading)
                      Text(
                        user?.email ?? "No email available",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}