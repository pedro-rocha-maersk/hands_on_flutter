# Tech Session - Hands on Flutter

## Requirements

### Flutter

Mac:

    > brew install wget
    > wget https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.0.5-stable.zip
    > unzip flutter_macos_arm64_3.0.5-stable.zip
    > export PATH="$PATH:`pwd`/flutter/bin"

Windows:

    > https://docs.flutter.dev/get-started/install/windows (no need to setup Android)

## Exercise

### Description

Build a memory card game

A one-player version of the game:

- The deck consists of n different card types (either n pairs of cards or n sets of 4 cards), labelled A, B, C, ... etc.
- Each turn, you flip over two cards (one at a time, so you can see the first one before picking the second)
- If the two cards match, then they are removed from the game, otherwise they are returned
- The game ends when all the cards are removed

### Steps

#### 1. Create the starter Flutter app

    > flutter channel 'stable'
    > flutter upgrade
    > flutter create hands_on_flutter
    > cd hands_on_flutter
    > flutter run
        Note: select Chrome when asked

Your dummy app is now running.

### 2. Replace the content of lib/main.dart

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

                    @override
                    void initState() {
                        super.initState();
                    }

                    @override
                    Widget build(BuildContext context) {
                        return Scaffold(
                            body: Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text(
                                        'This is my memory game',
                                        ),
                                    ],
                                ),
                            ),
                        );
                    }
                }

Press R in the terminal to perform hot-restart and you will notice that your app was updated.

### 3. Add card assets

Create a folder named 'assets' in your root folder and a folder named 'images' inside it

Download the assets from the repository and copy them to the images folder

### 4. Set card grid system

On main.dart, replace your Text widget (line 44) with a [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html). You will need to set some arguments:

- width: 800
- height: 600
- child: should be a [GridView](https://www.javatpoint.com/flutter-gridview) with each column being the index of the grid position

           GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    children: List.generate(
                        16,
                        (index) =>
                            SizedBox(child: Center(child: Text('Item $index'))))),

The result of this step must be similar to:

<img src="https://i.imgur.com/hPyWhgB.png" alt="grid" width="600"/>

### 5. Cards positions

In MemoryGameState, create a list 'cards' and a function that randomly fills the cards list with numbers from 1 to 8 that must be included twice. (Useful links: https://www.cloudhadoop.com/dart-create-sequence-numbers/)

Use [setState](https://api.flutter.dev/flutter/widgets/State/setState.html) to update the cards list.
Return example: [1,2,1,3,8,7,3,6,6,2,5,4,5,4,7,8]
Note: Dart List has a shuffle function

Update initState to include the function you just created:

            @override
            void initState() {
                super.initState();
                fulfillCards();
            }

Update your grid view to display each 'cards' value

The result of this step must be similar to:

<img src="https://i.imgur.com/A5nyJkp.png" alt="grid" width="600"/>

Notice that everytime you refresh you app, the 'cards' array gets updated.

### 6. Display an image for each card number

Replace the card index with associated the [Image](<(https://api.flutter.dev/flutter/widgets/Image-class.html)>)

Example: Image.asset('images/card1.png')

The result of this step must be similar to:

<img src="https://i.imgur.com/nusN0iO.png" alt="grid" width="600"/>

### 7. User choices

Create the logic necessary to save the user choices

- one variable ChoiceOne (with a set function)
- one variable ChoiceTwo (with a set function)

Update image asset source in order to only display the card image when it is one of the user choices or when it is matched (in order to handle the image click, look into [GestureDetector](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)).

Example

            handleChoide(){

            }

            GestureDetector(
                onTap: () {
                    handleChoice();
                },
                child: Image.asset('images/card1.png')
            ),

Note: you may want to convert the list of cards to a list of an object 'GamingCard'

            import 'dart:convert';

            class GamingCard {
                int index;
                bool matched;

                GamingCard(
                    this.index,
                    this.matched,
                ) {
                    this.index = index;
                    this.matched = matched;
                }

                GamingCard copyWith({
                    int? index,
                    bool? matched,
                }) {
                    return GamingCard(
                        index ?? this.index,
                        matched ?? this.matched,
                    );
                }

                Map<String, dynamic> toMap() {
                    return {
                        'index': index,
                        'matched': matched,
                    };
                }

                factory GamingCard.fromMap(Map<String, dynamic> map) {
                    return GamingCard(
                        map['index']?.toInt() ?? 0,
                        map['matched'] ?? false,
                    );
                }

                String toJson() => json.encode(toMap());

                factory GamingCard.fromJson(String source) =>
                    GamingCard.fromMap(json.decode(source));

                @override
                String toString() => 'GamingCard(index: $index, matched: $matched)';

                @override
                bool operator ==(Object other) {
                    if (identical(this, other)) return true;

                    return other is GamingCard &&
                        other.index == index &&
                        other.matched == matched;
                }

                @override
                int get hashCode => index.hashCode ^ matched.hashCode;
            }

If you want to wait for handleChoice, use:

            await Future.delayed(const Duration(milliseconds: 800));

### 8. Track number of turns

Create a row in order to keep track of the number of turns (Use [Row](https://api.flutter.dev/flutter/widgets/Row-class.html) and [Text](https://api.flutter.dev/flutter/widgets/Text-class.html))

### 9. Add a 'New game' button

Add a button to allow user to create a new game

### 10. Add a unit test to verify the correctness of new game creation logic

Useful links:

- https://docs.flutter.dev/testing#unit-tests
- https://medium.com/nonstopio/unit-testing-in-flutter-80554f68316
