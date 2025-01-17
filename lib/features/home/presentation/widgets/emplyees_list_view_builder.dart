import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sprints_data_handling_task_1/features/home/data/models/employee.dart';
import 'package:sprints_data_handling_task_1/features/home/presentation/widgets/employee_card.dart';

class EmployeesListViewBuilder extends StatelessWidget {
  const EmployeesListViewBuilder({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot<List<Employee>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        Employee employee = snapshot.data![index];
        return InkWell(
          borderRadius: BorderRadius.circular(20 + 8),
          onTap: () => log('Employee: ${employee.employeeName}'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmployeeCard(
              name: employee.employeeName,
              position: 'Employee',
              profileImageUrl: employee.profileImage,
              age: employee.employeeAge,
              salary: employee.employeeSalary,
            ),
          ),
        );
      },
    );
  }
}
