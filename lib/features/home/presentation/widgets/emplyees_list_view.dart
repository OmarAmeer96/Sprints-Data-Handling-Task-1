import 'package:flutter/material.dart';
import 'package:sprints_data_handling_task_1/features/home/data/models/employee.dart';
import 'package:sprints_data_handling_task_1/features/home/presentation/widgets/employee_card.dart';

class EmployeesListView extends StatelessWidget {
  const EmployeesListView({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot<List<Employee>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        Employee employee = snapshot.data![index];
        return EmployeeCard(
          child: ListTile(
            title: Text(
              employee.employeeName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Salary: \$${employee.employeeSalary}, Age: ${employee.employeeAge}',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
