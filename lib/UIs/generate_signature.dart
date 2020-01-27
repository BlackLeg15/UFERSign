import 'package:flutter/material.dart';

class GenerateSignatureWidget extends StatefulWidget {
  @override
  _GenerateSignatureStateWidget createState() => _GenerateSignatureStateWidget();
}

class _GenerateSignatureStateWidget extends State<GenerateSignatureWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assinar arquivo"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }

  uploadFile(){}

  uploadPrivateKey(){}

  generateSignature(){}

  saveSignature(){}

}
