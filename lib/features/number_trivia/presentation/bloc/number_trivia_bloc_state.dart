
part of 'number_trivia_bloc_bloc.dart';

abstract class NumberTriviaBlocState extends Equatable {
  const NumberTriviaBlocState();
}

class Empty extends NumberTriviaBlocState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaBlocState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaBlocState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia});
  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaBlocState {
  final String message;

  Error({@required this.message});
  @override
  List<Object> get props => [message];
}
