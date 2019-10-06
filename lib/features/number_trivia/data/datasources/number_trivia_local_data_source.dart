import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_numbers/core/constants.dart';
import 'package:trivia_numbers/core/error/exeptions.dart';
import 'package:trivia_numbers/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLast();

  Future cacheNumberTrivia(NumberTriviaModel number);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;

  NumberTriviaLocalDataSourceImpl(this.preferences);

  @override
  Future<NumberTriviaModel> getLast() {
    String jsonString = preferences.getString(CACHED_NUMBER_TRIVIA);
    if (null != jsonString) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future cacheNumberTrivia(NumberTriviaModel number) {
    return preferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(number.toJson()));
  }
}
