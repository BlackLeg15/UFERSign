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
        title: Text(
          "UFERSign",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                  height: 40,
                  color: Colors.red,
                  splashColor: Colors.redAccent,
                  child: Text(
                    "Assinar arquivo",
                    style: TextStyle(fontSize: 24, color: Colors.white),
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
                height: 40,
                color: Colors.lightGreen,
                splashColor: Colors.lightGreenAccent,
                child: Text(
                  "Verificar arquivo",
                  style: TextStyle(fontSize: 24, color: Colors.white),
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
                backgroundColor: Colors.blue,
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateKeyPairWidget()));
                },
                label: Text(
                  "Gerar par de chaves",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
