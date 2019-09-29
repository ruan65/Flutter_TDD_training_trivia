import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_numbers/core/error/exeptions.dart';
import 'package:trivia_numbers/core/error/failures.dart';
import 'package:trivia_numbers/core/platform/network_info.dart';
import 'package:trivia_numbers/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_numbers/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_numbers/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_numbers/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  runTestsOnLine(Function body) {
    group('device is online', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true));
      body();
    });
  }

  runTestsOffLine(Function body) {
    group('device is online', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false));
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'trivia test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnLine(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          assert(result.isRight());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          assert(result.isLeft());
          expect(result, Left(ServerFailure()));
        },
      );
    });

    runTestsOffLine(() {
      test(
        'should return locally cached data when cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLast())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          Either<Failure, NumberTrivia> result =
              await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLast());
          assert(result.isRight());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLast()).thenThrow(CacheException());
          // act
          Either<Failure, NumberTrivia> result =
              await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLast());
          assert(result.isLeft());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'trivia test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnLine(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          assert(result.isRight());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act

          Either<Failure, NumberTrivia> result =
              await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          assert(result.isLeft());
          expect(result, Left(ServerFailure()));
        },
      );
    });

    runTestsOffLine(() {
      test(
        'should return locally cached data when cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLast())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          Either<Failure, NumberTrivia> result =
              await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLast());
          assert(result.isRight());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when cached data is not present',
        () async {
          // arrange
          when(mockLocalDataSource.getLast()).thenThrow(CacheException());
          // act
          Either<Failure, NumberTrivia> result =
              await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLast());
          assert(result.isLeft());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
