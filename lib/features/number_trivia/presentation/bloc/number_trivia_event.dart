part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
  @override
  List<Object> get props => [];
}

class GetConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  const GetConcreteNumberEvent({this.numberString});
  @override
  List<Object> get props => [numberString];
}

class GetRandomNumberEvent extends NumberTriviaEvent {
  const GetRandomNumberEvent();
}
