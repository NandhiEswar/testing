import 'package:flutter/material.dart';
import 'game.dart';
import 'bigaresmall.dart';
import 'missingletter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isLandscape) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Select an Activity',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        _buildNavButton(context, 'Open Match Game', const MatchGamePage(), isWide: true),
                        _buildNavButton(context, 'Open Activity 2', const BigSmallGamePage(), isWide: true),
                        _buildNavButton(context, 'Open Activity 3', const MissingLetterApp(), isWide: true),
                        _buildNavButton(context, 'Open Activity 4', const ActivityFour(), isWide: true),
                        _buildNavButton(context, 'Open Activity 5', const ActivityFive(), isWide: true),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Select an Activity',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildNavButton(context, 'Open Match Game', const MatchGamePage()),
                  _buildNavButton(context, 'Open Activity 2', const BigSmallGamePage()),
                  _buildNavButton(context, 'Open Activity 3', const ActivityThree()),
                  _buildNavButton(context, 'Open Activity 4', const ActivityFour()),
                  _buildNavButton(context, 'Open Activity 5', const ActivityFive()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, Widget page, {bool isWide = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isWide ? 8.0 : 40.0),
      child: SizedBox(
        width: isWide ? 300 : double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }
}

// --- Activity Pages ---

class ActivityOne extends StatelessWidget {
  const ActivityOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 1')),
      body: const Center(child: Text('Welcome to Activity 1', style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.red.shade50,
    );
  }
}

class ActivityTwo extends StatelessWidget {
  const ActivityTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 2')),
      body: const Center(child: Text('Welcome to Activity 2', style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.green.shade50,
    );
  }
}

class ActivityThree extends StatelessWidget {
  const ActivityThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 3')),
      body: const Center(child: Text('Welcome to Activity 3', style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.blue.shade50,
    );
  }
}

class ActivityFour extends StatelessWidget {
  const ActivityFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 4')),
      body: const Center(child: Text('Welcome to Activity 4', style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.orange.shade50,
    );
  }
}

class ActivityFive extends StatelessWidget {
  const ActivityFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 5')),
      body: const Center(child: Text('Welcome to Activity 5', style: TextStyle(fontSize: 20))),
      backgroundColor: Colors.purple.shade50,
    );
  }
}
