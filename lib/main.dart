import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_manager/frames/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MaterialApp(
    home:  Home(),
    debugShowCheckedModeBanner: false,
  ));
}
