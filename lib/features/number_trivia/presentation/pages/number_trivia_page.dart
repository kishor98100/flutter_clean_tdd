import 'package:clean_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatefulWidget {
  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => sl<NumberTriviaBloc>(),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Searching');
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      trivia: state.numberTrivia,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 10.0),
              Builder(builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                            onPressed: () {
                              context.read<NumberTriviaBloc>().add(GetConcreteNumberEvent(numberString: _controller.text));
                              _controller.clear();
                            },
                            child: Text('Search'),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor)),
                            onPressed: () {
                              context.read<NumberTriviaBloc>().add(GetRandomNumberEvent());
                            },
                            child: Text('Get Random'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
