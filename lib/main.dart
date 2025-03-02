import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rentbet/common/utils/app_theme.dart';
import 'package:rentbet/providers/listings_provider.dart';
import 'package:rentbet/providers/theme_providers.dart';
import 'package:rentbet/providers/user_provider.dart';
import 'package:rentbet/providers/wishlist_provider.dart';
import 'package:rentbet/views/auth/auth_page.dart';
import 'package:rentbet/views/home/home_page.dart';
import 'package:rentbet/views/onboarding/onboarding_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String anonKey = dotenv.env['SUPABASE_ANONKEY'] ?? "";
  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? "";
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ListingsProvider>(
            create: (_) => ListingsProvider()),
        ChangeNotifierProvider<WishlistProvider>(
            create: (_) => WishlistProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<ThemeProviders>(
            create: (_) => ThemeProviders()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.seenOnboarding}) : super(key: key);
  final bool seenOnboarding;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviders>(context);
    final User? user = Supabase.instance.client.auth.currentUser;
    final Widget startPage = seenOnboarding
        ? (user != null ? HomePage() : AuthPage())
        : OnboardingPage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: startPage,
    );
  }
}