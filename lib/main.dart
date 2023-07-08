import 'package:employee_app_task/screens/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/employee_bloc.dart';
import 'data/employee_repository.dart';


void main() {
  final EmployeeRepository repository = EmployeeRepository();
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<EmployeeBloc>(
              create: (context) =>
                  EmployeeBloc(repository),
            ),

          ],
          child: MyApp()
      )
      );
}

class MyApp extends StatelessWidget {
  final EmployeeRepository repository = EmployeeRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => EmployeeBloc(repository)..add(GetEmployees()),
        child: EmployeeListScreen(),
      ),
    );
  }
}
