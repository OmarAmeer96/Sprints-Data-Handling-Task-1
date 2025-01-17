import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sprints_data_handling_task_1/features/home/data/models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmployeeService {
  final Dio _dio = Dio();

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await _dio
          .get('https://mocki.io/v1/c2688074-6ee3-4ea6-b60f-a57bcbc3253e');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Employee> employees =
            data.map((json) => Employee.fromJson(json)).toList();
        await _cacheEmployees(employees);
        return employees;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      final cachedEmployees = await _getCachedEmployees();
      if (cachedEmployees.isNotEmpty) {
        return cachedEmployees;
      } else {
        log('Failed to load employees: $e');
        throw Exception('Failed to load employees: $e');
      }
    }
  }

  Future<void> _cacheEmployees(List<Employee> employees) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(employees.map((e) => e.toJson()).toList());
    await prefs.setString('cached_employees', encodedData);
  }

  Future<List<Employee>> _getCachedEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('cached_employees');
    if (encodedData != null) {
      List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((json) => Employee.fromJson(json)).toList();
    }
    return [];
  }
}
