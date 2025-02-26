import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rentbet/views/onboarding/onboarding_page.dart';
void main() async{
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

final String anonKey = dotenv.env['SUPABASE_ANONKEY']?? "";
  await Supabase.initialize(
    url: 'https://dcvmagntezybofxgrcdq.supabase.co' ,
    anonKey:anonKey
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: OnboardingPage(),
    );
  }
}

