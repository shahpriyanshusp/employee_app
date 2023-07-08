

import 'package:intl/intl.dart';

import '../model/employee.dart';
import 'database_helper.dart';

class EmployeeRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Employee>> getEmployees() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (index) {
      return Employee(
        id: maps[index]['id'],
        name: maps[index]['name'],
        role: maps[index]['role'],
        fromDate: DateTime.parse(maps[index]['fromDate']),
        toDate:DateTime.parse(maps[index]['toDate']),
      );
    });
  }

  Future<void> addEmployee(Employee employee) async {
    final db = await _databaseHelper.database;
    await db.insert('employees', employee.toMap());
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await _databaseHelper.database;
    await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<void> deleteEmployee(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
