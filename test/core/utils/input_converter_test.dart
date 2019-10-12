import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_numbers/core/error/failures.dart';
import 'package:trivia_numbers/core/util/input_converter.dart';

main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignInt', () {
    test(
      'should return int when string represents unsigned integer',
      () {
        // arrange
        final str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string in not an integer',
          () {
        // arrange
        final str1 = 'a123';
        final str2 = '0.1';
        final str3 = '-0.5';
        // act
        final result1 = inputConverter.stringToUnsignedInteger(str1);
        final result2 = inputConverter.stringToUnsignedInteger(str2);
        final result3 = inputConverter.stringToUnsignedInteger(str3);
        // assert
        expect(result1, Left(InvalidInputFailure()));
        expect(result2, Left(InvalidInputFailure()));
        expect(result3, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string in a negative integer',
          () {
        // arrange
        final str1 = '-1';
        // act
        final result1 = inputConverter.stringToUnsignedInteger(str1);
        // assert
        expect(result1, Left(InvalidInputFailure()));
      },
    );
  });
}
