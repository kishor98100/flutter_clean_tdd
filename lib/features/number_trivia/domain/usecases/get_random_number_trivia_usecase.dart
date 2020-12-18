import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/usecases/usecase.dart';
import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTriviaUsecase implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUsecase(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return repository.getRandomNumberTrivia();
  }
}
