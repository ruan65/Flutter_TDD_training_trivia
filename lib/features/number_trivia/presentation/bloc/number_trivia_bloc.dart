import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia_numbers/core/error/failures.dart';
import 'package:trivia_numbers/core/usecases/usecase.dart';
import 'package:trivia_numbers/core/util/input_converter.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import './bloc.dart';

const SERVER_FAILURE_MSG = 'Server Failure';
const CACHE_FAILURE_MSG = 'Cache Failure';
const INVALID_INPUT_FAILURE_MSG =
    'The input must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final convertedEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* convertedEither.fold((failure) async* {
        yield ErrorState(message: INVALID_INPUT_FAILURE_MSG);
      }, (integer) async* {
        yield Loading();
        final numberTriviaEither =
            await getConcreteNumberTrivia(Params(number: integer));

        yield numberTriviaEither.fold(
            (failure) =>
                ErrorState(message: _mapFailureToErrorMessage(failure)),
            (numberTrivia) => Loaded(numberTrivia: numberTrivia));
      });
    }
  }

  String _mapFailureToErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MSG;
      case CacheFailure:
        return CACHE_FAILURE_MSG;
      default:
        return 'Unexpected Error';
    }
  }
}
