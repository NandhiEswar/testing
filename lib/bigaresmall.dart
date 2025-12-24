import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BigSmallGameApp());
}

class BigSmallGameApp extends StatelessWidget {
  const BigSmallGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Big or Small',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const BigSmallGamePage(),
    );
  }
}

class BigSmallGamePage extends StatefulWidget {
  const BigSmallGamePage({super.key});

  @override
  State<BigSmallGamePage> createState() => _BigSmallGamePageState();
}

class _BigSmallGamePageState extends State<BigSmallGamePage> {
  final Random _random = Random();
  final List<String> _objects = ['🍎', '🍌', '🍓', '🍊', '🍉'];

  late String _smallItem;
  late String _bigItem;
  late bool _askForBig;

  int _score = 0;
  Color? _feedbackColor;
  String _feedbackText = '';

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _smallItem = _objects[_random.nextInt(_objects.length)];
      _bigItem = _objects[_random.nextInt(_objects.length)];
      _askForBig = _random.nextBool();
      _feedbackColor = null;
      _feedbackText = '';
    });
  }

  void _onItemTapped(bool tappedBig) {
    final isCorrect = tappedBig == _askForBig;

    setState(() {
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
      _feedbackText = isCorrect ? 'Correct!' : 'Try Again';
      if (isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 900), _nextRound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: const Text('Big or Small'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isPortrait = orientation == Orientation.portrait;

              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              final emojiSize = isPortrait
                  ? screenWidth * 0.18
                  : screenHeight * 0.28;

              final bigScale = isPortrait ? 1.4 : 1.6;
              final smallScale = isPortrait ? 0.8 : 0.7;

              final spacing = isPortrait ? 24.0 : 12.0;

              return Padding(
                padding: EdgeInsets.all(isPortrait ? 16 : 8),
                child: isPortrait
                    ? Column(
                        children: [
                          _buildScoreText(isPortrait),
                          SizedBox(height: spacing),
                          _buildInstructionBox(isPortrait),
                          SizedBox(height: spacing),
                          Expanded(child: _buildGameRow(smallScale, bigScale, emojiSize)),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildScoreText(isPortrait),
                                SizedBox(height: spacing),
                                _buildInstructionBox(isPortrait),
                              ],
                            ),
                          ),
                          Expanded(child: _buildGameRow(smallScale, bigScale, emojiSize)),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScoreText(bool isPortrait) {
    return Text(
      'Score: $_score',
      style: TextStyle(
        fontSize: isPortrait ? 22 : 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInstructionBox(bool isPortrait) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _feedbackColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            _askForBig ? 'Tap the BIG one' : 'Tap the SMALL one',
            style: TextStyle(
              fontSize: isPortrait ? 26 : 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (_feedbackText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _feedbackText,
                style: TextStyle(
                  fontSize: isPortrait ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameRow(double smallScale, double bigScale, double emojiSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => _onItemTapped(false),
          child: Transform.scale(
            scale: smallScale,
            child: _buildItem(_smallItem, emojiSize),
          ),
        ),
        GestureDetector(
          onTap: () => _onItemTapped(true),
          child: Transform.scale(
            scale: bigScale,
            child: _buildItem(_bigItem, emojiSize),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(String emoji, double size) {
    return Container(
      padding: EdgeInsets.all(size * 0.25),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: size),
      ),
    );
  }
}
