import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_numbers/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/json_file_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('from json', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final String jsonString = fixture('trivia.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        // act

        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(jsonString, isA<String>());
        expect(jsonMap, isA<Map<String, dynamic>>());
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as double',
      () async {
        // arrange
        final String jsonString = fixture('double_trivia.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        // act

        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(jsonString, isA<String>());
        expect(jsonMap, isA<Map<String, dynamic>>());
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('to json', () {
    test(
      'should return a map containing a proper data',
      () async {
        // act

        final result = tNumberTriviaModel.toJson();
        // assert
        expect(result, {
          "text": "test text",
          "number": 1,
        });
      },
    );
  });
}
