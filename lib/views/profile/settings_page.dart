// lib/views/profile/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_providers.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProviders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(context, 'Appearance'),
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                _buildThemeOption(
                  context,
                  'Light Theme',
                  Icons.light_mode,
                  themeProvider.isLightMode,
                      () => themeProvider.setThemeMode(ThemeMode.light),
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _buildThemeOption(
                  context,
                  'Dark Theme',
                  Icons.dark_mode,
                  themeProvider.isDarkMode,
                      () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _buildThemeOption(
                  context,
                  'System Theme',
                  Icons.settings_system_daydream,
                  themeProvider.isSystemMode,
                      () => themeProvider.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      String title,
      IconData icon,
      bool isSelected,
      VoidCallback onTap,
      ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.textTheme.bodyLarge?.color),
      title: Text(title),
      trailing: isSelected ? Icon(Icons.check_circle, color: theme.primaryColor) : null,
      onTap: onTap,
    );
  }
}