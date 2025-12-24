import 'package:flutter/material.dart';


class MatchGameApp extends StatelessWidget {
  const MatchGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Match the Following',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MatchGamePage(),
    );
  }
}

class MatchGamePage extends StatefulWidget {
  const MatchGamePage({super.key});

  @override
  State<MatchGamePage> createState() => _MatchGamePageState();
}

class _MatchGamePageState extends State<MatchGamePage> {
  final Map<String, String> _gameData = {
    '🍎': 'Apple',
    '🐶': 'Dog',
    '🐱': 'Cat',
    '🦁': 'Lion',
    '🦆': 'Duck',
  };

  late List<String> _questions;
  late List<String> _answers;

  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  final Map<String, String> _matches = {}; // correct matches
  Map<String, String>? _wrongMatch;        // temporary wrong match

  String? _currentDragStart;
  Offset? _currentDragEnd;

  int _score = 0;

  final GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _questions = _gameData.keys.toList();
    _answers = _gameData.values.toList()..shuffle();

    _matches.clear();
    _wrongMatch = null;
    _currentDragStart = null;
    _currentDragEnd = null;
    _score = 0;

    _leftKeys.clear();
    _rightKeys.clear();

    for (final q in _questions) {
      _leftKeys[q] = GlobalKey();
    }
    for (final a in _answers) {
      _rightKeys[a] = GlobalKey();
    }

    setState(() {});
  }

  void _onPanStart(DragStartDetails d, String q) {
    if (_matches.containsKey(q)) return;
    setState(() {
      _currentDragStart = q;
      _currentDragEnd = d.globalPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_currentDragStart == null) return;
    setState(() => _currentDragEnd = d.globalPosition);
  }

  void _onPanEnd(DragEndDetails d) {
    if (_currentDragStart == null || _currentDragEnd == null) return;

    final start = _currentDragStart!;
    final correct = _gameData[start];
    String? dropped;

    for (final a in _answers) {
      final box =
          _rightKeys[a]?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final local = box.globalToLocal(_currentDragEnd!);
      if (box.paintBounds.contains(local)) {
        dropped = a;
        break;
      }
    }

    if (dropped == null) {
      _resetDrag();
      return;
    }

    if (dropped == correct) {
      setState(() {
        _matches[start] = dropped!;
        _score++;
      });

      if (_score == _gameData.length) {
        _showGameOver();
      }
    } else {
      // WRONG MATCH → show red line briefly
      setState(() {
        _wrongMatch = {start: dropped!};
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() => _wrongMatch = null);
        }
      });
    }

    _resetDrag();
  }

  void _resetDrag() {
    setState(() {
      _currentDragStart = null;
      _currentDragEnd = null;
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Excellent! 🎉'),
        content: const Text('You matched everything correctly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match the Following'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return Padding(
            padding: EdgeInsets.all(isPortrait ? 16 : 8),
            child: Stack(
              key: _stackKey,
              children: [
                Column(
                  children: [
                    Text(
                      'Score: $_score / ${_gameData.length}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: isPortrait ? 20 : 8),
                    Expanded(
                      child: Row(
                        children: [
                          _buildLeftColumn(isPortrait),
                          SizedBox(width: isPortrait ? 40 : 20),
                          _buildRightColumn(isPortrait),
                        ],
                      ),
                    ),
                  ],
                ),
                IgnorePointer(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: LinePainter(
                      stackKey: _stackKey,
                      leftKeys: _leftKeys,
                      rightKeys: _rightKeys,
                      matches: _matches,
                      wrongMatch: _wrongMatch,
                      currentDragStart: _currentDragStart,
                      currentDragEnd: _currentDragEnd,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftColumn(bool isPortrait) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _questions.map((q) {
          return GestureDetector(
            onPanStart: (d) => _onPanStart(d, q),
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FittedBox(
                  child: Text(
                    q,
                    style: TextStyle(fontSize: isPortrait ? 40 : 32),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.circle,
                  key: _leftKeys[q],
                  size: isPortrait ? 16 : 12,
                  color:
                      _matches.containsKey(q) ? Colors.green : Colors.blue,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRightColumn(bool isPortrait) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _answers.map((a) {
          return Row(
            children: [
              Icon(
                Icons.circle,
                key: _rightKeys[a],
                size: isPortrait ? 16 : 12,
                color:
                    _matches.containsValue(a) ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              FittedBox(
                child: Text(
                  a,
                  style: TextStyle(fontSize: isPortrait ? 20 : 16),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final GlobalKey stackKey;
  final Map<String, GlobalKey> leftKeys;
  final Map<String, GlobalKey> rightKeys;
  final Map<String, String> matches;
  final Map<String, String>? wrongMatch;
  final String? currentDragStart;
  final Offset? currentDragEnd;

  LinePainter({
    required this.stackKey,
    required this.leftKeys,
    required this.rightKeys,
    required this.matches,
    this.wrongMatch,
    this.currentDragStart,
    this.currentDragEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stackBox =
        stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    final paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw correct matches (GREEN)
    paint.color = Colors.green;
    matches.forEach((l, r) {
      _drawLine(canvas, paint, stackBox, l, r);
    });

    // Draw wrong match (RED - temporary)
    if (wrongMatch != null) {
      paint.color = Colors.red;
      wrongMatch!.forEach((l, r) {
        _drawLine(canvas, paint, stackBox, l, r);
      });
    }

    // Draw dragging line (BLUE)
    if (currentDragStart != null && currentDragEnd != null) {
      final lb = leftKeys[currentDragStart!]
          ?.currentContext
          ?.findRenderObject() as RenderBox?;
      if (lb == null) return;

      paint.color = Colors.blue;

      final start = stackBox.globalToLocal(
        lb.localToGlobal(lb.size.center(Offset.zero)),
      );
      final end = stackBox.globalToLocal(currentDragEnd!);
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawLine(Canvas canvas, Paint paint, RenderBox stackBox,
      String left, String right) {
    final lb =
        leftKeys[left]?.currentContext?.findRenderObject() as RenderBox?;
    final rb =
        rightKeys[right]?.currentContext?.findRenderObject() as RenderBox?;
    if (lb == null || rb == null) return;

    final p1 = stackBox.globalToLocal(
      lb.localToGlobal(lb.size.center(Offset.zero)),
    );
    final p2 = stackBox.globalToLocal(
      rb.localToGlobal(rb.size.center(Offset.zero)),
    );
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
