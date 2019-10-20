import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List<dynamic> args = const []]) : super([args]);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia}) : super([numberTrivia]);
}

class ErrorState extends NumberTriviaState {
  final String message;

  ErrorState({@required this.message}) : super([message]);
}
