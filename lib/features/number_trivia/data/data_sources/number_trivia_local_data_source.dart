import 'dart:convert';

import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;

  NumberTriviaLocalDataSourceImpl({@required this.preferences});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel model) async {
    return preferences.setString("CACHED_NUMBER_TRIVIA", jsonEncode(model.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = preferences.getString("CACHED_NUMBER_TRIVIA");
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
