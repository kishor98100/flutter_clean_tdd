import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final String text;
  final int number;

  NumberTriviaModel({@required this.text, @required this.number}) : super(number: number, text: text);

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }

  factory NumberTriviaModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return NumberTriviaModel(
      text: map['text'],
      number: (map['number'] as num).toInt(),
    );
  }
}
