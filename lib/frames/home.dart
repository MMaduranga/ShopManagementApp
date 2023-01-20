import 'package:flutter/material.dart';
import 'package:shop_manager/frames/salary.dart';
import 'package:shop_manager/frames/stock.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color tapColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset('assets/horse-removebg-preview.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
           Center(
              child: Text(
            "Gamini Motors",
            style: TextStyle(
              shadows: [Shadow(
                color: Colors.blue.withOpacity(0.4),
                offset: const Offset(10, 7),
                blurRadius: 7,
              )],
                color: Colors.blue,
                fontSize: 70,
                fontFamily: 'Mechanical',
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40, left: 80, right: 80),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 7,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              title:  Row(
                children:  [
                  const Icon(Icons.attach_money,color: Colors.blue,size: 30,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  const Text(
                    "Salary",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontFamily: 'Mechanical'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Salary()));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40, left: 80, right: 80),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              title: Row(
                children:  [
                  const Icon(Icons.motorcycle,color: Colors.blue,size: 30,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  const Text(
                    "Stock",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontFamily: 'Mechanical'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Stock()));
              },
            ),
          ),
        ],
      )),
    );
  }
}
