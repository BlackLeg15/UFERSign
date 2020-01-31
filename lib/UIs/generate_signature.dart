import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as crypto;
import 'package:tst_crypto/utils/dependency_provider.dart';

class GenerateSignatureWidget extends StatefulWidget {
  @override
  _GenerateSignatureStateWidget createState() =>
      _GenerateSignatureStateWidget();
}

class _GenerateSignatureStateWidget extends State<GenerateSignatureWidget> {
  crypto.RSAPrivateKey privK;
  Uint8List file;
  String signature;

  Future<crypto.RSAPrivateKey> futurePrivK;
  Future<Uint8List> futureFile;
  Future<String> futureSignature;

  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assinar arquivo",
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
                height: 50,
                color: Colors.red,
                child: Text(
                  "Selecione a chave para assinatura (privada)",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  final path = await FilePicker.getFilePath(
                      type: FileType.CUSTOM, fileExtension: 'txt');
                  setState(() {
                    futurePrivK = uploadPrivateKey(path);
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder<crypto.RSAPrivateKey>(
                  future: futurePrivK,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      this.privK = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MaterialButton(
                            height: 50,
                            color: Color.fromRGBO(255, 195, 0, 1),
                            child: Text(
                              "Selecione um arquivo",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              final path = await FilePicker.getFilePath(
                                  type: FileType.ANY);
                              setState(() {
                                futureFile = uploadFile(path);
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(6.0),
                          ),
                          Expanded(
                            child: FutureBuilder<Uint8List>(
                              future: futureFile,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  file = snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      MaterialButton(
                                        height: 50,
                                        color: Colors.orange,
                                        child: Text(
                                          "Gerar assinatura",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            futureSignature =
                                                generateSignature();
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                      ),
                                      Expanded(
                                        child: FutureBuilder<String>(
                                          future: futureSignature,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasData) {
                                              signature = snapshot.data;
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  MaterialButton(
                                                    height: 50,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    child: Text(
                                                      "Salvar assinatura",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () {},
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<crypto.RSAPrivateKey> uploadPrivateKey(path) async {
    if (path != null && path.isNotEmpty) {
      return DependencyProvider.of(context)
          .getRsaKeyHelper()
          .parsePrivateKeyFromPem(File(path).readAsStringSync());
    }
    return null;
  }

  Future<Uint8List> uploadFile(path) async {
    if (path != null && path.isNotEmpty) {
      return File(path).readAsBytesSync();
    }
    return null;
  }

  Future<String> generateSignature() async {
    // if (privK != null) {
    //   if (file != null) {
    //     return DependencyProvider.of(context)
    //         .getRsaKeyHelper()
    //         .signBytes(file, privK);
    //   }
    //   print("Erro: Arquivo");
    //   return null;
    // }
    // print("Erro: Chave privada");
    // return null;
    return "ok";
  }

  saveSignature() async {
    //final String path = await LocalStorage().getPath(true);
  }
}
