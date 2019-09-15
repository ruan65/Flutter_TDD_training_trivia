import 'package:flutter/foundation.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required int number, @required String text})
      : super(number, text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) =>
      NumberTriviaModel(
          number: (jsonMap["number"] as num).toInt(), text: jsonMap["text"]);

  Map<String, dynamic> toJson() => {
        "number": number,
        "text": text,
      };
}
