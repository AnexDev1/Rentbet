import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dcvmagntezybofxgrcdq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjdm1hZ250ZXp5Ym9meGdyY2RxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1NTcxNzEsImV4cCI6MjA1NjEzMzE3MX0.0RHSdYnm0xeWvh12WBhEb4sFNQuF5K2TpLFnhNT8Zas'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        useMaterial3: true,
      ),
      home: Text('hello world')
    );
  }
}

