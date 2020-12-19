import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/usecases/usecase.dart';
import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:clean_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTriviaUsecase extends Mock implements GetConcreteNumberTriviaUsecase {}

class MockGetRandomNumberTriviaUsecase extends Mock implements GetRandomNumberTriviaUsecase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTriviaUsecase concreteUsecase;
  MockGetRandomNumberTriviaUsecase randomUsecase;
  MockInputConverter converter;

  setUpAll(() {
    concreteUsecase = MockGetConcreteNumberTriviaUsecase();
    randomUsecase = MockGetRandomNumberTriviaUsecase();
    converter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concreteUsecase: concreteUsecase,
      randomUsecase: randomUsecase,
      converter: converter,
    );
  });

  test('initial state should be Empty ', () async {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    test('should call the InputConvert to validate and convert the string to an unsigned integer', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
      await untilCalled(converter.stringToUnsignedInt(any));
      //assert
      verify(converter.stringToUnsignedInt(tNumberString));
    });
    test('should emit [Error] when input is invalid', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Left(InvalidInputFailure()));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
    });
    test('should get data from usecase', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      when(concreteUsecase(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
      await untilCalled(concreteUsecase(any));
      //assert
      verify(concreteUsecase(Params(number: tNumberParsed)));
    });

    test('should emit [Loading,Loaded] when data is gotten successfully', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      when(concreteUsecase(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Loaded(numberTrivia: tNumberTrivia),
          ]));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
    });
    test('should emit [Loading,Error] when data is not gotten successfully', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      when(concreteUsecase(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
    });
    test('should emit [Loading,Error] with proper message when data is not gotten successfully', () async {
      //arrange
      when(converter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
      when(concreteUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetConcreteNumberEvent(numberString: tNumberString));
    });
  });
  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    test('should get data from usecase', () async {
      //arrange
      when(randomUsecase(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetRandomNumberEvent());
      await untilCalled(randomUsecase(any));
      //assert
      verify(randomUsecase(NoParams()));
    });

    test('should emit [Loading,Loaded] when data is gotten successfully', () async {
      //arrange
      when(randomUsecase(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Loaded(numberTrivia: tNumberTrivia),
          ]));
      //act
      bloc.add(GetRandomNumberEvent());
    });
    test('should emit [Loading,Error] when data is not gotten successfully', () async {
      //arrange
      when(randomUsecase(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetRandomNumberEvent());
    });
    test('should emit [Loading,Error] with proper message when data is not gotten successfully', () async {
      //arrange
      when(randomUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc,
          emitsInOrder([
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetRandomNumberEvent());
    });
  });

  tearDownAll(() {
    bloc?.close();
  });
}
