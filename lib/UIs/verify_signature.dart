import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as crypto;
import 'package:tst_crypto/utils/dependency_provider.dart';

class VerifySignatureWidget extends StatefulWidget {
  @override
  _VerifySignatureStateWidget createState() => _VerifySignatureStateWidget();
}

class _VerifySignatureStateWidget extends State<VerifySignatureWidget> {
  Future<crypto.RSAPublicKey> futurePubK;
  Future<crypto.RSASignature> futureSignature;
  Future<Uint8List> futureFile;

  crypto.RSAPublicKey pubK;
  crypto.RSASignature signature;
  Uint8List file;

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
                onPressed: () async {
                  final path = await FilePicker.getFilePath(
                      type: FileType.CUSTOM, fileExtension: 'txt');
                  setState(() {
                    futurePubK = uploadPublicKey(path);
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
              ),
              Expanded(
                child: FutureBuilder(
                  future: futurePubK,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      pubK = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MaterialButton(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            color: Color.fromARGB(255, 255, 195, 0),
                            child: Text(
                              "Selecione o arquivo a ser verificado",
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
                            child: FutureBuilder(
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
                                          padding: EdgeInsets.only(
                                              top: 12.0, bottom: 12.0),
                                          color: Colors.orange,
                                          child: Text("Selecione a assinatura",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          onPressed: () async {
                                            final path =
                                                await FilePicker.getFilePath(
                                                    type: FileType.CUSTOM,
                                                    fileExtension: 'txt');
                                            setState(() {
                                              futureSignature =
                                                  uploadSignature(path);
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                        ),
                                        Expanded(
                                          child: FutureBuilder(
                                            future: futureSignature,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasData) {
                                                return Column(
                                                  children: <Widget>[
                                                    MaterialButton(
                                                      padding: EdgeInsets.only(
                                                          top: 12.0,
                                                          bottom: 12.0),
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      child: Text(
                                                        "Verificar arquivo",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        int result =
                                                            verifySignature();
                                                        if (result != 0) {
                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    "Resultado",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            24),
                                                                  ),
                                                                  content: Text(
                                                                    "Arquivo ${(result == 1) ? "Autêntico" : "Inautêntico"}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                        child:
                                                                            Text(
                                                                          "OK",
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        })
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      },
                                                    ),
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
                                }),
                          ),
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

  Future<crypto.RSAPublicKey> uploadPublicKey(String path) async {
    if (path != null && path.isNotEmpty) {
      return DependencyProvider.of(context)
          .getRsaKeyHelper()
          .parsePublicKeyFromPem(File(path).readAsStringSync());
    }
    return null;
  }

  Future<Uint8List> uploadFile(String path) async {
    if (path != null && path.isNotEmpty) {
      return File(path).readAsBytesSync();
    }
    return null;
  }

  Future<crypto.RSASignature> uploadSignature(String path) async {
    if (path != null && path.isNotEmpty) {
      return crypto.RSASignature(base64.decode(File(path).readAsStringSync()));
    }
    return null;
  }

  int verifySignature() {
    var result;
    if (pubK != null && file != null && signature != null) {
      result = DependencyProvider.of(context)
          .getRsaKeyHelper()
          .verifyBytes(file, pubK, signature);
      if (result == true) {
        return 1;
      } else {
        return 2;
      }
    }
    return 0;
  }
}
