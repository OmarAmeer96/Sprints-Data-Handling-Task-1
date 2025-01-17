// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprints_data_handling_task_1/core/services/employee_service.dart';
import 'package:sprints_data_handling_task_1/features/home/data/models/employee.dart';
import 'package:sprints_data_handling_task_1/features/home/presentation/widgets/employee_card.dart';
import 'package:sprints_data_handling_task_1/features/home/presentation/widgets/emplyees_list_view.dart';

class EmployeeListView extends StatefulWidget {
  const EmployeeListView({super.key});

  @override
  State<EmployeeListView> createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  final EmployeeService _employeeService = EmployeeService();
  late Future<List<Employee>> _futureEmployees;

  @override
  void initState() {
    super.initState();
    _futureEmployees = _employeeService.fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureEmployees = _employeeService.fetchEmployees();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Employee List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.8),
                  Colors.purple.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey.withOpacity(0.1),
                Colors.white.withOpacity(0.5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FutureBuilder<List<Employee>>(
            future: _futureEmployees,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerList();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No employees found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              } else {
                return EmployeesListView(
                  snapshot: snapshot,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          child: EmployeeCard(
            child: ListTile(
              title: Container(
                height: 16,
                color: Colors.grey,
              ),
              subtitle: Container(
                height: 14,
                margin: EdgeInsets.only(top: 8),
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
