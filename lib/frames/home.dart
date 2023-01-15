import 'package:flutter/material.dart';
import 'package:shop_manager/frames/salary.dart';
import 'package:shop_manager/frames/stock.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(height: 20,),
          Container(
            margin: const EdgeInsets.only(bottom: 20,left: 10,right: 10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius:const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: Colors.lightBlue.shade100,
            ),
            child: ListTile(
              title: const Center(child: Text("Salary")),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Salary()));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20,left: 10,right: 10),
            decoration: BoxDecoration(
              border: Border.all(),
                borderRadius:const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
            color: Colors.lightBlue.shade100,
            ),
            child: ListTile(
              title: const Center(child: Text("Stock")),
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
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextButton(

// child: ),
// TextButton(
// onPressed: () {
// Navigator.push(context,
// MaterialPageRoute(builder: (context) => const Stock()));
// },
// child: const Text("Stock")),
// TextButton(onPressed: () {}, child: const Text("Salary"))
// ],
// ),
