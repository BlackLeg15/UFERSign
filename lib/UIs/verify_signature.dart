import 'dart:typed_data';

import 'package:flutter/material.dart';

class VerifySignatureWidget extends StatefulWidget {
  @override
  _VerifySignatureStateWidget createState() => _VerifySignatureStateWidget();
}

class _VerifySignatureStateWidget extends State<VerifySignatureWidget> {
  Future<String> futurePubK;
  Future<Uint8List> futureSignature;
  Future<Uint8List> futureFile;

  String pubK;
  String signature;
  String file;

  final key = GlobalKey<ScaffoldState>();
  bool test = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(
          "Verificar arquivo",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                color: Colors.green,
                child: Text(
                  "Selecione a chave para verificação (pública)",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: uploadPublicKey,
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
              ),
              MaterialButton(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                color: Color.fromARGB(255, 255, 195, 0),
                child: Text(
                  "Selecione o arquivo a ser verificado",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: uploadFile,
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
              ),
              MaterialButton(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                color: Colors.orange,
                child: Text("Selecione a assinatura",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: uploadSignature,
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
              ),
              MaterialButton(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                color: Theme.of(context).accentColor,
                child: Text(
                  "Verificar arquivo",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  bool result = verifySignature();
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Resultado",
                            style: TextStyle(fontSize: 24),
                          ),
                          content: Text(
                            "Arquivo ${result ? "Autêntico" : "Inautêntico"}",
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadPublicKey() {}

  uploadSignature() {}

  uploadFile() {}

  bool verifySignature() {
    var aux = test;
    test = !test;
    return aux;
  }
}
