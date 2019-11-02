import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:trivia_numbers/features/number_trivia/presentation/pages/screens/widgets.dart';
import 'package:trivia_numbers/injection_container.dart';

class NumberTriviaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (bloc, state) {
                  final h = MediaQuery.of(context).size.height;

                  if (state is Empty) {
                    return messageDisplay('Start Searching', h);
                  } else if (state is ErrorState) {
                    return messageDisplay(state.message, h);
                  } else if (state is Loaded) {
                    return triviaDisplay(state.numberTrivia, h);
                  } else {
                    return loadingWidget(h);
                  }
                },
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Placeholder(
                    fallbackHeight: 40,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      ),
                    ],
                  )
                ],
              )
              // Bottom half
            ],
          ),
        ),
      ),
    );
  }
}
