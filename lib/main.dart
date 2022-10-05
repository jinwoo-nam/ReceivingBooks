import 'package:flutter/material.dart';
import 'package:receiving_books/data/google_sheeet_api.dart';
import 'package:receiving_books/presentation/home/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleSheetApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instapay 입고처리',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
