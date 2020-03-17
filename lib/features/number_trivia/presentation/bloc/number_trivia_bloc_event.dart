part of 'number_trivia_bloc_bloc.dart';

abstract class NumberTriviaBlocEvent extends Equatable {
  const NumberTriviaBlocEvent();
}

class GetTriviaForConcreteNumber extends NumberTriviaBlocEvent{
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object> get props => [numberString]; 
}

class GetTriviaForRandomNumber extends NumberTriviaBlocEvent{
  @override
  List<Object> get props => null;

}