import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/usecases/usecase.dart';
import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTriviaUsecase implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTriviaUsecase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return repository.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});
  @override
  List<Object> get props => [number];
}
