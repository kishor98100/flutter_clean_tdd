import 'package:clean_tdd/core/usecases/usecase.dart';
import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTriviaUsecase usecase;
  MockNumberTriviaRepository repository;
  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUsecase(repository);
  });

  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository', () async {
    //arrange
    when(repository.getRandomNumberTrivia()).thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
