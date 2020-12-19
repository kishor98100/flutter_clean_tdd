import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/usecases/usecase.dart';
import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid Input - Number must be positive integer ";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUsecase concreteUsecase;
  final GetRandomNumberTriviaUsecase randomUsecase;
  final InputConverter converter;

  NumberTriviaBloc({
    @required this.concreteUsecase,
    @required this.randomUsecase,
    @required this.converter,
  })  : assert(concreteUsecase != null),
        assert(randomUsecase != null),
        assert(converter != null),
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetConcreteNumberEvent) {
      final inputEither = converter.stringToUnsignedInt(event.numberString);
      yield* inputEither.fold((l) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (number) async* {
        yield Loading();
        final result = await concreteUsecase(Params(number: number));
        yield result.fold((failure) => Error(message: _mapFailureToMessage(failure)), (r) => Loaded(numberTrivia: r));
      });
    } else if (event is GetRandomNumberEvent) {
      yield Loading();
      final result = await randomUsecase(NoParams());
      yield result.fold((failure) => Error(message: _mapFailureToMessage(failure)), (r) => Loaded(numberTrivia: r));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'UnExpected Error';
    }
  }
}
