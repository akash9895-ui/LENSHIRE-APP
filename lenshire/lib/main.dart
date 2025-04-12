import 'package:flutter/material.dart';

import 'package:lenshire/opening.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ajhucddnnqjebizkgfpo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqaHVjZGRubnFqZWJpemtnZnBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwNjkwMjYsImV4cCI6MjA1NjY0NTAyNn0.FrvZYy5nASt5wWQFU5wiE-kOjC8Ojto9Ubgar-dCVZo',
  );
  runApp(MainApp());
}

final supabase = Supabase.instance.client;
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: OpeningPage());
  }
}
