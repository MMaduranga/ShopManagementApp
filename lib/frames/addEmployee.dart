import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Employee extends StatefulWidget {
  final int? count;
  const Employee({Key? key,this.count}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState(idCount: count);
}

class _EmployeeState extends State<Employee> {
  final nameController = TextEditingController();
  final salaryController = TextEditingController();
 int? idCount;
  _EmployeeState({this.idCount});
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
          ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final salary = int.parse(salaryController.text);
                addEmployee(name, salary);
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      )),
    );
  }

  Future addEmployee(String name, int salary) async {
    String id = 'id-${idCount!+1}';
    final employee = FirebaseFirestore.instance.collection('employee').doc(id);
    final json = {'id': id, 'name': name, 'salary': salary, 'allowance': 0};
    await employee.set(json);
  }
}
