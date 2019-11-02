import 'package:flutter/material.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';

Widget triviaDisplay(NumberTrivia trivia, double h) {
  return Container(
    height: h / 3,
    child: Center(
        child: Column(
      children: <Widget>[
        Text(
          trivia.number.toString(),
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Text(trivia.text, style: TextStyle(fontSize: 25))),
        ),
      ],
    )),
  );
}

Widget messageDisplay(String msg, double h) {
  return Container(
    height: h / 3,
    child: Center(
        child: SingleChildScrollView(
            child: Text(msg, style: TextStyle(fontSize: 25)))),
  );
}

Widget loadingWidget(double h) => Container(
      height: h / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
