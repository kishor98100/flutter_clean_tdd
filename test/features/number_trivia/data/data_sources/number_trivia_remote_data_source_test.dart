import 'dart:convert';

import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: httpClient);
  });
  void setUpMockHttpClient200() {
    when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClient404() {
    when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Something Went Wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint with application/json header', () async {
      //arrange
      setUpMockHttpClient200();
      //act
      await dataSource.getConcreateNumberTrivia(tNumber);
      //assert
      verify(httpClient.get('http://numbersapi.com/$tNumber', headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when response code is 200', () async {
      //arrange
      setUpMockHttpClient200();
      //act
      final result = await dataSource.getConcreateNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException  when response code is 404 or other', () async {
      //arrange
      setUpMockHttpClient404();
      //act
      final call = dataSource.getConcreateNumberTrivia;

      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint with application/json header', () async {
      //arrange
      setUpMockHttpClient200();
      //act
      await dataSource.getRandomNumberTrivia();
      //assert
      verify(httpClient.get('http://numbersapi.com/random', headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when response code is 200', () async {
      //arrange
      setUpMockHttpClient200();
      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException  when response code is 404 or other', () async {
      //arrange
      setUpMockHttpClient404();
      //act
      final call = dataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
