import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_numbers/core/constants.dart';
import 'package:trivia_numbers/core/error/exeptions.dart';
import 'package:trivia_numbers/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_numbers/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/json_file_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences preferences;

  setUp(() {
    preferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(preferences);
  });

  group('get last number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from prefs when there is one in the cache',
      () async {
        // arrange
        when(preferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLast();
        // assert
        verify(preferences.getString(CACHED_NUMBER_TRIVIA));

        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a CacheException when there is empty cache',
      () async {
        // arrange
        when(preferences.getString(any)).thenReturn(null);
        // assert

        expect(
            () => dataSource.getLast(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cache number trivia', () {
    final tNumberTrivia = NumberTriviaModel(number: 1, text: 'test trivia');

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange

        // act

        dataSource.cacheNumberTrivia(tNumberTrivia);
        // assert
        verify(preferences.setString(
            CACHED_NUMBER_TRIVIA, json.encode(tNumberTrivia.toJson())));
      },
    );
  });
}
