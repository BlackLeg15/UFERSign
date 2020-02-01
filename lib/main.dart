import 'package:flutter/material.dart';
import 'package:tst_crypto/UIs/home.dart';
import 'UIs/home.dart';
import 'utils/dependency_provider.dart';

void main() => runApp(DependencyProvider(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UFERSign',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
