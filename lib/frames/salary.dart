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
  final textFieldController = TextEditingController();
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
          onPressed: () {
            setState(() {
              docId = [];
            });
          },
        ),
      ),
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: docId.length,
              itemBuilder: (context, index) {
                return getListTile(context, docId[index], index);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Employee()));
      }),
    );
  }

  Future getUser() async {
    await employee.get().then((snapshot) => snapshot.docs.forEach((document) {
          docId.add(document.reference.id);
        }));
  }

  Future<String?> displayTextInputDialog(BuildContext context) async {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Allowance'),
            content: TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              controller: textFieldController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(textFieldController.text);
                    textFieldController.clear();
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  Future<String?> deleteUser(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  getListTile(BuildContext context, String document, int index) {
    return FutureBuilder<DocumentSnapshot>(
        future: employee.doc(document).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 3, left: 10, right: 10),
              child: ListTile(
                onTap: () async {
                  final allowanceVal = await displayTextInputDialog(context);
                  if (allowanceVal!.isNotEmpty) {
                    final docUser = employee.doc(document);
                    docUser.update({
                      'allowance': data['allowance']+int.parse(allowanceVal),
                    });
                    setState(() {
                      docId = [];
                    });
                  }
                },
                tileColor: Colors.white,
                trailing: IconButton(
                    onPressed: () async {
                      final decision = await deleteUser(context);
                      if (decision == 'OK') {
                        final docUser = employee.doc(document);
                        docUser.delete();
                        setState(() {
                          docId = [];
                        });
                      }
                    },
                    icon: const Icon(Icons.delete)),
                title: Row(
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      (data['salary'] - data['allowance']).toString(),
                      style: const TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ],
                ),
                leading: Text((++index).toString()),
                subtitle: Row(
                  children: [
                    Text(
                      data['salary'].toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      data['allowance'].toString(),
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ],
                ),
              ),
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
