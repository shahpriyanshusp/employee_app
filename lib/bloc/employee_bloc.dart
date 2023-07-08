import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/employee_repository.dart';
import '../model/employee.dart';


// Events
abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  const AddEmployee(this.employee);

  @override
  List<Object> get props => [employee];
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  const UpdateEmployee(this.employee);

  @override
  List<Object> get props => [employee];
}

class DeleteEmployee extends EmployeeEvent {
  final int id;

  const DeleteEmployee(this.id);

  @override
  List<Object> get props => [id];
}

// States
abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoadSuccess extends EmployeeState {
  final List<Employee> employees;

  const EmployeeLoadSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeOperationFailure extends EmployeeState {}
class EmployeeNoDataFound extends EmployeeState {}

// BLoC
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeInitial());

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is GetEmployees) {
      yield* _mapGetEmployeesToState();
    } else if (event is AddEmployee) {
      yield* _mapAddEmployeeToState(event.employee);
    } else if (event is UpdateEmployee) {
      yield* _mapUpdateEmployeeToState(event.employee);
    } else if (event is DeleteEmployee) {
      yield* _mapDeleteEmployeeToState(event.id);
    }
  }

  Stream<EmployeeState> _mapGetEmployeesToState() async* {
    try {
      final employees = await repository.getEmployees();
      if(employees.length>0)
      yield EmployeeLoadSuccess(employees);
      else yield EmployeeNoDataFound();
    } catch (_) {
      yield EmployeeOperationFailure();
    }
  }

  Stream<EmployeeState> _mapAddEmployeeToState(Employee employee) async* {
    try {
      await repository.addEmployee(employee);
      yield* _mapGetEmployeesToState();
    } catch (_) {
      yield EmployeeOperationFailure();
    }
  }

  Stream<EmployeeState> _mapUpdateEmployeeToState(Employee employee) async* {
    try {
      await repository.updateEmployee(employee);
      yield* _mapGetEmployeesToState();
    } catch (_) {
      yield EmployeeOperationFailure();
    }
  }

  Stream<EmployeeState> _mapDeleteEmployeeToState(int id) async* {
    try {
      await repository.deleteEmployee(id);
      yield* _mapGetEmployeesToState();
    } catch (_) {
      yield EmployeeOperationFailure();
    }
  }
}
