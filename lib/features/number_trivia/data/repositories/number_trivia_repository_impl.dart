import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_numbers/core/error/exeptions.dart';
import 'package:trivia_numbers/core/error/failures.dart';
import 'package:trivia_numbers/core/platform/network_info.dart';
import 'package:trivia_numbers/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_numbers/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:trivia_numbers/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    NumberTrivia nTrivia;
    if (await networkInfo.isConnected) {
      try {
        nTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(nTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        nTrivia = await localDataSource.getLast();
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    return Right(nTrivia);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
