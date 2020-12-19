import 'dart:convert';

import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences preferences;
  setUp(() {
    preferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(preferences: preferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test('should return number trivia from sharedpreferences when there is one  cache', () async {
      //arrange
      when(preferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      //act
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(preferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw CacheException when there is no cached value', () async {
      //arrange
      when(preferences.getString(any)).thenReturn(null);

      //act
      final call = dataSource.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cache number trivial', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Trivia');
    test('should call sharedpreferences to cache data', () async {
      //act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      //assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(preferences.setString(
        'CACHED_NUMBER_TRIVIA',
        expectedJsonString,
      ));
    });
    // test('should throw CacheException when there is no cached value', () async {
    //   //arrange
    //   when(preferences.getString(any)).thenReturn(null);

    //   //act
    //   final call = dataSource.getLastNumberTrivia;

    //   //assert
    //   expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    // });
  });
}
