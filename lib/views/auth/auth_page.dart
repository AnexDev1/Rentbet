import 'package:flutter/material.dart';
import 'package:rentbet/views/auth/signup_tab.dart';
import 'login_tab.dart';

class AuthPage extends StatelessWidget {
  final bool showSignup;

  const AuthPage({Key? key, this.showSignup = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: showSignup ? 1 : 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  r'assets/logo.png',
                  width: 120,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Welcome to RentBet",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  r"Sign up or log in to unlock access to a curated selection of properties.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.black54,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Login"),
                  Tab(text: "Sign up"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    LoginTab(),
                    SignupTab()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}