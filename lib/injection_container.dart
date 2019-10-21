import 'package:get_it/get_it.dart';
import 'package:trivia_numbers/core/util/input_converter.dart';
import 'package:trivia_numbers/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/bloc/bloc.dart';

import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl = GetIt.instance; // service locator

init() {
  _initCore();
  _initFeatures();
}

_initCore() {
  sl.registerLazySingleton(() => InputConverter());
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
}
