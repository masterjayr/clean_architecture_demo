import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBlocBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBlocBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBlocBloc, NumberTriviaBlocState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia,);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TriviaControl()
            ],
          ),
        ),
      ),
    );
  }
}






