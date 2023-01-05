// ignore_for_file: invalid_required_positional_param

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => CounterBloc()),
      child: MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Testing Bloc'),
            ),
            body: BlocConsumer<CounterBloc, CouterState>(
                listener: ((context, state) {
              _controller.clear();
            }), builder: ((context, state) {
              final invalidValue = (state is InvalidCounterStateNumber)
                  ? state.invalidString
                  : '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Current Value => ${state.value}.'),
                  Visibility(
                    visible: state is InvalidCounterStateNumber,
                    child: Text('Invalid Input:$invalidValue'),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter A number here'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(IncreamentEvent(_controller.text));
                          },
                          child: const Text('Add  number')),
                      TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(DecreamentEvent(_controller.text));
                          },
                          child: const Text('Minus this number')),
                    ],
                  ),
                ],
              );
            }))),
      ),
    );
  }
}

@immutable
abstract class CouterState {
  final int value;
  const CouterState(this.value);
}

class CounterStateValid extends CouterState {
  const CounterStateValid(int value) : super(value);
}

class InvalidCounterStateNumber extends CouterState {
  final String invalidString;

  const InvalidCounterStateNumber({
    required this.invalidString,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String passedValue;
  const CounterEvent(this.passedValue);
}

class IncreamentEvent extends CounterEvent {
  const IncreamentEvent(String passedValue) : super(passedValue);
}

class DecreamentEvent extends CounterEvent {
  const DecreamentEvent(String passedValue) : super(passedValue);
}

class CounterBloc extends Bloc<CounterEvent, CouterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncreamentEvent>((event, emit) {
      final integer = int.tryParse(event.passedValue);
      if (integer == null) {
        emit(InvalidCounterStateNumber(
          invalidString: event.passedValue,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecreamentEvent>((event, emit) {
      final integer = int.tryParse(event.passedValue);
      if (integer == null) {
        emit(InvalidCounterStateNumber(
          invalidString: event.passedValue,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
