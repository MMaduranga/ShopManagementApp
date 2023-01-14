import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/frames/addEmployee.dart';

class Salary extends StatefulWidget {
  const Salary({Key? key}) : super(key: key);

  @override
  State<Salary> createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  CollectionReference employee =
      FirebaseFirestore.instance.collection('employee');
  List<String> docId = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {setState(() {
            docId=[];
          });},
        ),
      ),
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: docId.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: getName(context, docId[index]),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Employee(
                      count: docId.length,
                    )));
      }),
    );
  }

  Future getUser() async {
    await employee.get().then((snapshot) => snapshot.docs.forEach((document) {
          docId.add(document.reference.id);
        }));
  }

  getName(BuildContext context, String document) {
    return FutureBuilder<DocumentSnapshot>(
        future: employee.doc(document).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: [
                Text(data['name']),
                const SizedBox(
                  width: 10,
                ),
                Text(data['salary'].toString()),
                const SizedBox(
                  width: 10,
                ),
                Text(data['allowance'].toString()),
              ],
            );
          }
          return const Text('loading');
        }));
  }
}

class User {
  String id = '';
  final String name;
  final int salary;

  User({this.id = '', required this.name, required this.salary});

  static User fromJson(Map<String, dynamic> json) {
    var user = User(id: json['id'], name: json['id'], salary: json['salary']);
    print(user.name);
    return user;
  }
}
