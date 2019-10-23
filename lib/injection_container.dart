import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_numbers/core/network/network_info.dart';
import 'package:trivia_numbers/core/util/input_converter.dart';
import 'package:trivia_numbers/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_numbers/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/bloc/bloc.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance; // service locator

Future init() async {
  await _initExternal();
  _initCore();
  _initFeatures();
}

_initExternal() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

_initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

_initFeatures() {
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));
  // UseCases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Data
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            networkInfo: sl(),
            localDataSource: sl(),
            remoteDataSource: sl(),
          ));
}
