import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hands on Flutter',
      home: MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  State<MemoryGame> createState() => MemoryGameState();
}

@visibleForTesting
class MemoryGameState extends State<MemoryGame> {
  List<Map<String, dynamic>> cards = [];
  int choiceOne = -1;
  int choiceTwo = -1;
  int turns = 0;
  bool validatingChoice = false;

  @override
  void initState() {
    super.initState();
    fulfillCards();
  }

  void fulfillCards() {
    List<Map<String, dynamic>> tempCards = [
      {"value": 1, "matched": false},
      {"value": 1, "matched": false},
      {"value": 2, "matched": false},
      {"value": 2, "matched": false},
      {"value": 3, "matched": false},
      {"value": 3, "matched": false},
      {"value": 4, "matched": false},
      {"value": 4, "matched": false},
      {"value": 5, "matched": false},
      {"value": 5, "matched": false},
      {"value": 6, "matched": false},
      {"value": 6, "matched": false},
      {"value": 7, "matched": false},
      {"value": 7, "matched": false},
      {"value": 8, "matched": false},
      {"value": 8, "matched": false},
    ];
    setState(() {
      tempCards.shuffle();
      cards = tempCards;
    });
  }

  void handleChoice(int choice) {
    if (choiceOne == -1) {
      setState(() {
        choiceOne = choice;
      });
    } else if (choice != choiceOne) {
      setState(() {
        choiceTwo = choice;
        validatingChoice = true;
      });
      validatePair();
      setState(() {
        validatingChoice = false;
        turns++;
      });
    }
  }

  void validatePair() async {
    if (cards[choiceOne]["value"] == cards[choiceTwo]["value"]) {
      setState(() {
        cards[choiceOne]["matched"] = true;
        cards[choiceTwo]["matched"] = true;
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        choiceOne = -1;
        choiceTwo = -1;
      });
    }
  }

  void createNewGame() {
    fulfillCards();
    setState(() {
      choiceOne = -1;
      choiceTwo = -1;
      turns = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Number of turns: $turns',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Container(
                    height: 36,
                    margin: const EdgeInsets.only(left: 48),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                top: 8, left: 16, bottom: 8, right: 16)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        createNewGame();
                      },
                      child: const Text(
                        'New game',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                width: 800,
                height: 600,
                child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    mainAxisSpacing: 16,
                    children: List.generate(
                        16,
                        (index) => GestureDetector(
                            onTap: () {
                              if (validatingChoice) {
                                return;
                              }
                              handleChoice(index);
                            },
                            child: SizedBox(
                                child: Center(
                                    child: Image.asset(
                              index == choiceOne ||
                                      index == choiceTwo ||
                                      cards[index]["matched"]
                                  ? 'images/card${cards[index]["value"]}.png'
                                  : 'images/card0.png',
                            ))))))),
          ],
        ),
      ),
    );
  }
}
