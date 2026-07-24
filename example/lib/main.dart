import 'package:flutter/material.dart';
import 'package:ghost_text/ghost_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghost Text Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ghost Font Animation'),
      ),
      body: const Center(
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: GhostFont(
            text: 'GHOST',
            fontSize: 100,
            patternColor: Colors.black,
            backgroundColor: Colors.white,
            speed: 50.0,
            noiseScale: 2.0,
          ),
        ),
      ),
    );
  }
}
