import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tst_crypto/UIs/generate_key_pair.dart';
import 'package:tst_crypto/UIs/generate_signature.dart';
import 'package:tst_crypto/UIs/verify_signature.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UFERSign"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
                color: Colors.blue,
                splashColor: Colors.lightBlueAccent,
                child: Text(
                  "Assinar arquivo",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateSignatureWidget()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            MaterialButton(
              color: Colors.lightGreen,
              splashColor: Colors.lightGreenAccent,
              child: Text(
                "Verificar assinatura",
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifySignatureWidget()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.red,
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenerateKeyPairWidget()));
              },
              label: Text("Gerar par de chaves"),
            )
          ],
        ),
      ),
    );
  }
}
