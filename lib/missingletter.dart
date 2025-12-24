import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MissingLetterApp());
}

class MissingLetterApp extends StatelessWidget {
  const MissingLetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Missing Letter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MissingLetterPage(),
    );
  }
}

class MissingLetterPage extends StatefulWidget {
  const MissingLetterPage({super.key});

  @override
  State<MissingLetterPage> createState() => _MissingLetterPageState();
}

class _MissingLetterPageState extends State<MissingLetterPage> {
  final Random _random = Random();

  final List<Map<String, String>> _words = [
    {'emoji': '🦁', 'word': 'LION'},
    {'emoji': '🐶', 'word': 'DOG'},
    {'emoji': '🐱', 'word': 'CAT'},
    {'emoji': '🐘', 'word': 'ELEPHANT'},
    {'emoji': '🐼', 'word': 'PANDA'},
  ];

  late Map<String, String> _current;
  late int _missingIndex;
  late String _correctLetter;
  late List<String> _options;

  int _score = 0;
  Color? _feedbackColor;
  String _feedbackText = '';

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    _current = _words[_random.nextInt(_words.length)];
    final word = _current['word']!;
    _missingIndex = _random.nextInt(word.length);
    _correctLetter = word[_missingIndex];

    _options = {_correctLetter}
        .union(_randomLetters(3))
        .toList()
      ..shuffle();

    setState(() {
      _feedbackColor = null;
      _feedbackText = '';
    });
  }

  Set<String> _randomLetters(int count) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final set = <String>{};
    while (set.length < count) {
      set.add(letters[_random.nextInt(letters.length)]);
    }
    return set;
  }

  void _onLetterTap(String letter) {
    final isCorrect = letter == _correctLetter;

    setState(() {
      _feedbackColor = isCorrect ? Colors.green : Colors.red;
      _feedbackText = isCorrect ? 'Correct!' : 'Try Again';
      if (isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 900), _nextQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Missing Letter'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final emojiSize =
                  isPortrait ? width * 0.25 : width * 0.18;
              final letterSize =
                  isPortrait ? width * 0.08 : width * 0.06;

              return Padding(
                padding: EdgeInsets.all(isPortrait ? 16 : 8),
                child: Column(
                  children: [
                    Text(
                      'Score: $_score',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _feedbackColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Fill the missing letter',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_feedbackText.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _feedbackText,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      _current['emoji']!,
                      style: TextStyle(fontSize: emojiSize),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _current['word']!.length,
                        (i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 2),
                            ),
                            child: Text(
                              i == _missingIndex
                                  ? '_'
                                  : _current['word']![i],
                              style: TextStyle(
                                fontSize: letterSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Wrap(
                      spacing: 16,
                      children: _options.map((letter) {
                        return GestureDetector(
                          onTap: () => _onLetterTap(letter),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: letterSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
