import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class TriviaControl extends StatefulWidget {
  @override
  _TriviaControlState createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(onChanged: (value){
          inputStr= value;
        },
          onSubmitted: (_){
            dispatchConcrete();
          },
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number'
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                  child: Text('Search'),
                  color: Theme.of(context).accentColor,
                  onPressed: (){  
                    dispatchConcrete();
                  },
                  textTheme: ButtonTextTheme.primary,
                )),
            SizedBox(
              width: 10,
            ), 
            Expanded(
                child: RaisedButton(
                  child: Text('Get random trivia'),
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    dispatchRandom();
                  },
                  textTheme: ButtonTextTheme.primary,
                ))
          ],
        )
      ],
    );
  }

  void dispatchConcrete(){
    controller.clear();
    BlocProvider.of<NumberTriviaBlocBloc>(context)
      .add(GetTriviaForConcreteNumber(inputStr));
  }
  
  void dispatchRandom(){
    controller.clear();
    BlocProvider.of<NumberTriviaBlocBloc>(context)
      .add(GetTriviaForRandomNumber());
  }
}