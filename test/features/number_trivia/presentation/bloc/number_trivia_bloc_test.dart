import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_numbers/core/error/failures.dart';
import 'package:trivia_numbers/core/usecases/usecase.dart';
import 'package:trivia_numbers/core/util/input_converter.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  InputConverter inputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initial state should be empty', () {
    // assert
    expect(bloc.initialState, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(1, 'test trivia');

    setUpMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      'should call the InputConverter to validate and convert input to unsigned int',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

        await untilCalled(inputConverter.stringToUnsignedInteger(any));
        // assert
        verify(inputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit the [ERROR] when the input is invalid',
      () async {
        // arrange
        when(inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        expectLater(
            bloc.state,
            emitsInOrder([
              Empty(),
              ErrorState(message: INVALID_INPUT_FAILURE_MSG),
            ]));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
        // assert
      },
    );

    test(
      'should emit [loading, loaded] when data has been gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [loading, failure] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          ErrorState(message: SERVER_FAILURE_MSG),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [loading, failure] with a propper message when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          ErrorState(message: CACHE_FAILURE_MSG),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(1, 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
      },
    );

    test(
      'should emit [loading, loaded] when data has been gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [loading, failure] when getting data fails',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          ErrorState(message: SERVER_FAILURE_MSG),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [loading, failure] with a propper message when getting data fails',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          ErrorState(message: CACHE_FAILURE_MSG),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
