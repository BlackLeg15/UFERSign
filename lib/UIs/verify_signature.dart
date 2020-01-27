import 'package:flutter/material.dart';

class VerifySignatureWidget extends StatefulWidget {
  @override
  _VerifySignatureStateWidget createState() => _VerifySignatureStateWidget();
}

class _VerifySignatureStateWidget extends State<VerifySignatureWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verificar assinatura"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
