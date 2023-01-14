import 'package:flutter/material.dart';
import 'package:shop_manager/frames/salary.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            TextButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => const Salary()));
            }, child: const Text("Salary")),
            TextButton(onPressed: () {}, child: const Text("Stock")),
            TextButton(onPressed: () {}, child: const Text("Salary"))
        ],
      ),
          )),
    );
  }
}
