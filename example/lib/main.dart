import 'package:alerter/alerter.dart';
import 'package:flutter/material.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AlerterExample(),
    );
  }
}

class AlerterExample extends StatefulWidget {
  const AlerterExample({super.key});

  @override
  State<AlerterExample> createState() => _AlerterExampleState();
}

class _AlerterExampleState extends State<AlerterExample> {
  void showTopAlerter() {
    Alerter.show(
      context,
      title: 'Top Alert',
      message: 'This is a message.',
      position: OverlayPosition.top,
      icon: Icons.check_circle,
    );
  }

  void showBottomAlerter() {
    Alerter.show(
      context,
      position: OverlayPosition.bottom,
      title: 'Bottom Alert',
      message: 'This is a message.',
      icon: Icons.check_circle,
    );
  }

  void showTextOnlyAlerter() {
    Alerter.show(
      context,
      title: 'Text Only Alert',
      message: 'This is a message.',
    );
  }

  void showMessageOnlyAlerter() {
    Alerter.show(
      context,
      message: 'This is a message.',
    );
  }

  void showColorfulAlerter() {
    Alerter.show(
      context,
      title: 'Colorful Alert',
      message: 'This is a message.',
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
      iconColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showTopAlerter,
              child: const Text('Top Alerter'),
            ),
            ElevatedButton(
              onPressed: showBottomAlerter,
              child: const Text('Bottom Alerter'),
            ),
            ElevatedButton(
              onPressed: showTextOnlyAlerter,
              child: const Text('Text Only Alerter'),
            ),
            ElevatedButton(
              onPressed: showMessageOnlyAlerter,
              child: const Text('Message Only Alerter'),
            ),
            ElevatedButton(
              onPressed: showColorfulAlerter,
              child: const Text('Colorful Alerter'),
            ),
          ],
        ),
      ),
    );
  }
}
