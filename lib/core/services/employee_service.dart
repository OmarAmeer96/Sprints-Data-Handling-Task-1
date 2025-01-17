import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sprints_data_handling_task_1/features/home/data/models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EmployeeService {
  final Dio _dio = Dio();
  String baseUrl = 'https://mocki.io/v1/09c81238-d1f1-4a71-b41c-3c96a61cf1bb';

  Future<List<Employee>> fetchChchedEmployees() async {
    try {
      final cachedEmployees = await _getCachedEmployees();
      if (cachedEmployees.isNotEmpty) {
        return cachedEmployees;
      } else {
        await fetchEmployeesFromServer();
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
    return [];
  }

  Future<List<Employee>> fetchEmployeesFromServer() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Employee> employees =
            data.map((json) => Employee.fromJson(json)).toList();
        await _cacheEmployees(employees);
        return employees;
      } else {
        throw Exception('Failed to load employees from server');
      }
    } on DioException catch (dioError) {
      String errorMessage;
      if (dioError.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection Timeout Exception';
      } else if (dioError.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Send Timeout Exception';
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive Timeout Exception';
      } else if (dioError.type == DioExceptionType.badResponse) {
        errorMessage =
            'Response Exception: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}';
      } else if (dioError.type == DioExceptionType.cancel) {
        errorMessage = 'Request Cancelled';
      } else if (dioError.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection Error';
      } else {
        errorMessage = 'Unexpected Error';
      }
      log('$errorMessage: $dioError');
      final cachedEmployees = await _getCachedEmployees();
      if (cachedEmployees.isNotEmpty) {
        return cachedEmployees;
      } else {
        throw Exception('Failed to load employees: $errorMessage');
      }
    } catch (e) {
      log('Unexpected Error: $e');
      final cachedEmployees = await _getCachedEmployees();
      if (cachedEmployees.isNotEmpty) {
        return cachedEmployees;
      } else {
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
