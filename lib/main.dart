import 'package:flutter/material.dart';
import 'game.dart';
import 'bigaresmall.dart';
import 'missingletter.dart';
import  'count_letters.dart';
// AlphabetGame inlined below (moved from alphabetsgame.dart)

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
                        _buildNavButton(context, 'Open Match Game', () => const MatchGamePage(), isWide: true),
                        _buildNavButton(context, 'Open Activity 2', () => const BigSmallGamePage(), isWide: true),
                        _buildNavButton(context, 'Open Activity 3', () => const MissingLetterApp(), isWide: true),
                        _buildNavButton(context, 'Open Activity 4', () => const MatchNumberGame(), isWide: true),
                        _buildNavButton(context, 'Open Activity 5', () => AlphabetGame(letter: 'A'), isWide: true),
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
                  _buildNavButton(context, 'Open Match Game', () => const MatchGamePage()),
                  _buildNavButton(context, 'Open Activity 2', () => const BigSmallGamePage()),
                  _buildNavButton(context, 'Open Activity 3', () => const ActivityThree()),
                  _buildNavButton(context, 'Open Activity 4', () => const MatchNumberGame()),
                  _buildNavButton(context, 'Open Activity 5', () => AlphabetGame(letter: 'A')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, Widget Function() pageBuilder, {bool isWide = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isWide ? 8.0 : 40.0),
      child: SizedBox(
        width: isWide ? 300 : double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => pageBuilder()),
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

/* ===== Inlined AlphabetGame (from alphabetsgame.dart) ===== */

class AlphabetGame extends StatefulWidget {
  final String letter;
  const AlphabetGame({super.key, required this.letter});

  @override
  State<AlphabetGame> createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> {
  final List<Offset> userPoints = [];
  bool? isCorrect;

  void clearTrace() {
    setState(() {
      userPoints.clear();
      isCorrect = null;
    });
  }

  void checkTrace(Size size) {
    final reference = _getLetterAPath(size);
    final result = _validateTrace(userPoints, reference);
    setState(() => isCorrect = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace the Letter ${widget.letter}'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Use your finger to trace the dotted letter',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasSize =
                    Size(constraints.maxWidth, constraints.maxHeight);

                return GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      userPoints.add(details.localPosition);
                    });
                  },
                  onPanEnd: (_) {
                    userPoints.add(Offset.infinite);
                  },
                  child: CustomPaint(
                    size: canvasSize,
                    painter: _TracePainter(
                      userPoints: userPoints,
                      referencePoints: _getLetterAPath(canvasSize),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isCorrect != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                isCorrect! ? '✅ Correct!' : '❌ Try Again',
                style: TextStyle(
                  fontSize: 20,
                  color: isCorrect! ? Colors.green : Colors.red,
                ),
              ),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: clearTrace,
                child: const Text('Clear Trace'),
              ),
              ElevatedButton(
                onPressed: () {
                  final box = context.findRenderObject() as RenderBox;
                  checkTrace(box.size);
                },
                child: const Text('Check'),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final List<Offset> userPoints;
  final List<Offset> referencePoints;

  _TracePainter({
    required this.userPoints,
    required this.referencePoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dottedPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (final point in referencePoints) {
      canvas.drawCircle(point, 4, dottedPaint);
    }

    final drawPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < userPoints.length - 1; i++) {
      if (userPoints[i] != Offset.infinite &&
          userPoints[i + 1] != Offset.infinite) {
        canvas.drawLine(userPoints[i], userPoints[i + 1], drawPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

List<Offset> _getLetterAPath(Size size) {
  final w = size.width;
  final h = size.height;

  return [
    Offset(w * 0.5, h * 0.15),
    Offset(w * 0.4, h * 0.3),
    Offset(w * 0.32, h * 0.45),
    Offset(w * 0.28, h * 0.6),
    Offset(w * 0.5, h * 0.15),
    Offset(w * 0.6, h * 0.3),
    Offset(w * 0.68, h * 0.45),
    Offset(w * 0.72, h * 0.6),
    Offset(w * 0.38, h * 0.45),
    Offset(w * 0.62, h * 0.45),
  ];
}

bool _validateTrace(List<Offset> user, List<Offset> reference) {
  const double tolerance = 30;
  int matched = 0;

  for (final ref in reference) {
    for (final u in user) {
      if (u != Offset.infinite &&
          (ref - u).distance <= tolerance) {
        matched++;
        break;
      }
    }
  }

  return matched >= reference.length * 0.7;
}
