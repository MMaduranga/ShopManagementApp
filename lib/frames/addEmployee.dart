import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final nameController = TextEditingController();
  final salaryController = TextEditingController();
  final allowanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Name',
                hintText: 'Enter Name'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: salaryController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Salary',
                hintText: 'Enter Salary'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: allowanceController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Allowance',
                hintText: 'Enter Allowance'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final salary = int.parse(salaryController.text);
                final allowance = int.parse(allowanceController.text);
                addEmployee(name, salary, allowance);
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      )),
    );
  }

  Future addEmployee(String name, int salary, int allowance) async {
    final employee = FirebaseFirestore.instance.collection('employee').doc();
    final json = {'name': name, 'salary': salary, 'allowance': allowance};
    await employee.set(json);
  }
}
