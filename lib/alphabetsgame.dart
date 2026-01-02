import 'package:flutter/material.dart';

class AlphabetGame extends StatefulWidget {
  final String letter;
  const AlphabetGame({super.key, required this.letter});

  @override
  State<AlphabetGame> createState() => _AlphabetGameState();
}

class _AlphabetGameState extends State<AlphabetGame> {
  final List<Offset> userPoints = [];

  double progress = 0.0;
  bool completed = false;

  void clearTrace() {
    setState(() {
      userPoints.clear();
      progress = 0.0;
      completed = false;
    });
  }

  void manualCheck() {
    setState(() {
      completed = progress > 0.8;
    });
  }

  void updateProgress(Size size) {
    final points =
        userPoints.where((p) => p != Offset.infinite).toList();
    if (points.isEmpty) return;

    int left = 0, right = 0, middle = 0;

    for (final p in points) {
      if (p.dx < size.width * 0.45) left++;
      if (p.dx > size.width * 0.55) right++;
      if (p.dy > size.height * 0.42 &&
          p.dy < size.height * 0.48) middle++;
    }

    setState(() {
      progress = ((left + right + middle) /
              (points.length * 3))
          .clamp(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace the Letter ${widget.letter}'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /// MAIN CONTENT
            Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Use your finger to trace the dotted letter',
                  style: TextStyle(fontSize: 16),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color:
                        completed ? Colors.green : Colors.orange,
                  ),
                ),

                /// DRAWING AREA (LIMITED HEIGHT)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );

                      return GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            userPoints
                                .add(details.localPosition);
                          });
                          updateProgress(size);
                        },
                        onPanEnd: (_) =>
                            userPoints.add(Offset.infinite),
                        child: CustomPaint(
                          size: size,
                          painter: _TracePainter(
                            userPoints: userPoints,
                            referencePoints:
                                _getLetterAPath(size),
                            completed: completed,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 80), // space for buttons
              ],
            ),

            /// 🔒 FIXED BUTTON BAR (ALWAYS VISIBLE)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                        ),
                        onPressed: clearTrace,
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 14),
                        ),
                        onPressed: manualCheck,
                        child: const Text(
                          'Check',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= PAINTER ================= */

class _TracePainter extends CustomPainter {
  final List<Offset> userPoints;
  final List<Offset> referencePoints;
  final bool completed;

  _TracePainter({
    required this.userPoints,
    required this.referencePoints,
    required this.completed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dottedPaint = Paint()
      ..color = completed ? Colors.green : Colors.grey
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (final p in referencePoints) {
      canvas.drawCircle(p, 3.5, dottedPaint);
    }

    final drawPaint = Paint()
      ..color = completed ? Colors.green : Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < userPoints.length - 1; i++) {
      if (userPoints[i] != Offset.infinite &&
          userPoints[i + 1] != Offset.infinite) {
        canvas.drawLine(
            userPoints[i], userPoints[i + 1], drawPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/* ================= LETTER A PATH ================= */

List<Offset> _getLetterAPath(Size size) {
  final w = size.width;
  final h = size.height;
  List<Offset> path = [];

  for (double t = 0; t <= 1; t += 0.05) {
    path.add(Offset(
      _lerp(w * 0.5, w * 0.28, t),
      _lerp(h * 0.15, h * 0.6, t),
    ));
  }

  for (double t = 0; t <= 1; t += 0.05) {
    path.add(Offset(
      _lerp(w * 0.5, w * 0.72, t),
      _lerp(h * 0.15, h * 0.6, t),
    ));
  }

  for (double t = 0; t <= 1; t += 0.08) {
    path.add(Offset(
      _lerp(w * 0.38, w * 0.62, t),
      h * 0.45,
    ));
  }

  return path;
}

double _lerp(double a, double b, double t) {
  return a + (b - a) * t;
}
