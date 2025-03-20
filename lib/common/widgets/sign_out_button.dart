// lib/views/profile/widgets/sign_out_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/services/user_service.dart';
import 'package:rentbet/views/auth/auth_page.dart';
import '../../../services/auth_service.dart';
import '../../providers/user_provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});
void logout (context){
  Provider.of<UserProvider>(context).clearUser();
}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.redAccent,
          size: 24,
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onTap: () async {
          // Show confirmation dialog
          final bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
              title: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 12.0),
                  const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
              content: const Text(
                'Are you sure you want to sign out of your account?',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xDE000000),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              actions: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.only(bottom: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=> AuthPage(),
                        ),
                        ),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ) ?? false;

          // If confirmed, sign out
          if (confirm && context.mounted) {

            try {
              await AuthService().signOut();
              // Navigate to login or handle in your auth state listener
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error signing out: ${e.toString()}')),
              );
            }
          }
        },
      ),
    );
  }
}