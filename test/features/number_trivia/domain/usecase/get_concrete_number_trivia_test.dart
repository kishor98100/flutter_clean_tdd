import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTriviaUsecase usecase;
  MockNumberTriviaRepository repository;
  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUsecase(repository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(repository.getConcreateNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(Params(number: tNumber));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(repository.getConcreateNumberTrivia(tNumber));
    verifyNoMoreInteractions(repository);
  });
}
