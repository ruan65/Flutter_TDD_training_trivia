import 'package:dartz/dartz.dart';
import 'package:trivia_numbers/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String string) {

    try {
      var parsedInt = int.parse(string);
      if(parsedInt < 0) throw FormatException();
      return Right(parsedInt);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}