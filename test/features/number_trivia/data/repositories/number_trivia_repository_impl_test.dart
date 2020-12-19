import 'package:clean_tdd/core/error/exceptions.dart';
import 'package:clean_tdd/core/error/failures.dart';
import 'package:clean_tdd/core/network/network_info.dart';
import 'package:clean_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUpAll(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      //act
      repository.getConcreateNumberTrivia(tNumber);
      //assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUpAll(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the call to remote data source is successful', () async {
        //arrange
        when(remoteDataSource.getConcreateNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repository.getConcreateNumberTrivia(tNumber);

        //assert
        verify(remoteDataSource.getConcreateNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test('should cache the data locally when the call to remote data source is successful', () async {
        //arrange
        when(remoteDataSource.getConcreateNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repository.getConcreateNumberTrivia(tNumber);

        //assert
        verify(remoteDataSource.getConcreateNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        //arrange
        when(remoteDataSource.getConcreateNumberTrivia(any)).thenThrow(ServerException());

        //act
        final result = await repository.getConcreateNumberTrivia(tNumber);

        //assert
        verify(remoteDataSource.getConcreateNumberTrivia(tNumber));
        expect(result, equals(Left(ServerFailure())));
      });
    });
    group('device is offline', () {
      setUpAll(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return last locally cached data when the cached data is present', () async {
        //arrange
        when(localDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreateNumberTrivia(tNumber);

        //assert
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test('should return cache failure when the cached data is not present', () async {
        //arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repository.getConcreateNumberTrivia(tNumber);

        //assert
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
