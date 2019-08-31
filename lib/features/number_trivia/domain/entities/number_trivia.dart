import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final int number;
  final String text;

  NumberTrivia(this.number, this.text) : super([text, number]);
}
