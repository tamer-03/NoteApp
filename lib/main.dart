import 'package:flutter/material.dart';
import 'package:note_app/screen/home_page.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 236, 236, 130),
            primary: const Color.fromARGB(255, 234, 245, 22)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
