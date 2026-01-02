import 'package:flutter/material.dart';

class MatchNumberGame extends StatefulWidget {
  const MatchNumberGame({super.key});

  @override
  State<MatchNumberGame> createState() => _MatchNumberGameState();
}
class MatchItem {
  final String id;
  final String image;
  final int value;

  MatchItem({
    required this.id,
    required this.image,
    required this.value,
  });
}


class _MatchNumberGameState extends State<MatchNumberGame> {
  final List<MatchItem> items = [
    MatchItem(id: "1", image: "assets/apple_1.png", value: 1),
    MatchItem(id: "2", image: "assets/apple_2.png", value: 2),
    MatchItem(id: "3", image: "assets/apple_3.png", value: 3),
  ];

  final Map<int, bool> matched = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Match the Numbers")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // LEFT: IMAGES
            Expanded(
              child: Column(
                children: items.map((item) {
                  return Draggable<int>(
                    data: item.value,
                    feedback: Image.asset(item.image, height: 80),
                    childWhenDragging:
                        Opacity(opacity: 0.3, child: Image.asset(item.image, height: 80)),
                    child: Image.asset(item.image, height: 80),
                  );
                }).toList(),
              ),
            ),

            // RIGHT: NUMBERS
            Expanded(
              child: Column(
                children: items.map((item) {
                  return DragTarget<int>(
                    onAccept: (receivedValue) {
                      setState(() {
                        matched[item.value] = receivedValue == item.value;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        margin: const EdgeInsets.all(12),
                        height: 70,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: matched[item.value] == true
                              ? Colors.green
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.value.toString(),
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
