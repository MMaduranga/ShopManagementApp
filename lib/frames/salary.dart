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
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                final decision = await resetAllowance(context);
                if (decision == 'OK') {
                  docId.forEach((document) {
                    employee.doc(document).update({
                      'allowance': 0,
                    });
                  });
                  setState(() {
                    docId = [];
                  });
                }
              },
              child: const Text('Reset'),
            ),
          ],
        ),
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
      },child:const Icon(Icons.add),),
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

  Future<String?> resetAllowance(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Reset Allowance'),
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: ListTile(
                onTap: () async {
                  final allowanceVal = await displayTextInputDialog(context);
                  if (allowanceVal!.isNotEmpty) {
                    final docUser = employee.doc(document);
                    docUser.update({
                      'allowance': data['allowance'] + int.parse(allowanceVal),
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
                    icon: const Icon(Icons.delete,color: Colors.blue,)),
                title: Row(
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Mechanical'),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Salary       : ', style:  TextStyle(color: Colors.grey, fontSize: 15),),
                        Text(
                          data['salary'].toString(),
                          style: const TextStyle(color: Colors.black,fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Allowance    : ', style:  TextStyle(color: Colors.grey, fontSize: 15),),
                        Text(
                          data['allowance'].toString(),
                          style: const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Remaining Salary : ', style:  TextStyle(color: Colors.grey, fontSize: 15),),
                        Text(
                          (data['salary'] - data['allowance']).toString(),
                          style: const TextStyle(color: Colors.green, fontSize: 25),
                        ),
                      ],
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
