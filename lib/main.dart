import 'package:flutter/material.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/pages/screens/number_trivia_screen.dart';

import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: NumberTriviaScreen(),
    );
  }
}
