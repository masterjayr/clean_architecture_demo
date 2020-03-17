import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBlocBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBlocBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteTrivia', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test Text');

    void setUpMockInputConverterSuccess()=> 
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));
    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure())); 
      //assert later
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      
    });

    test('bloc should get data from the concrete usecase', ()async{
      //arrange
      setUpMockInputConverterSuccess(); 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit loading and loaded when data is gotten successfully', ()async {
        //arrange
      setUpMockInputConverterSuccess(); 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [loading and Error] when getting data fails', ()async {
        //arrange
      setUpMockInputConverterSuccess(); 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    }); 


    test('should emit [loading and Error] with a proper message for the error when getting data fails', ()async {
        //arrange
      setUpMockInputConverterSuccess(); 
      when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });


  group('GetTriviaForRandomTrivia', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'Test Text');


    test('bloc should get data from the random usecase', ()async{
      //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit loading and loaded when data is gotten successfully', ()async {
        //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [loading and Error] when getting data fails', ()async {
        //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForRandomNumber());
    }); 


    test('should emit [loading and Error] with a proper message for the error when getting data fails', ()async {
        //arrange
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.state,expected);
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
