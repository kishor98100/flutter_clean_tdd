import 'package:clean_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter converter;
  setUp(() {
    converter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return unsigned integer when string represents unsigned integer', () async {
      //arrange
      final str = '123';
      //act
      final result = converter.stringToUnsignedInt(str);

      //assert
      expect(result, Right(123));
    });
    test('should return InvalidInputFailure when string is not an integer', () async {
      //arrange
      final str = 'abc';
      //act
      final result = converter.stringToUnsignedInt(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return InvalidInputFailure when string is  a negative integer', () async {
      //arrange
      final str = '-123';
      //act
      final result = converter.stringToUnsignedInt(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
