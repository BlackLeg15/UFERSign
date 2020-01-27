import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:tst_crypto/utils/dependency_provider.dart';
import '../utils/local_storage.dart';

class GenerateKeyPairWidget extends StatefulWidget {
  @override
  _GenerateKeyPairWidgetState createState() => _GenerateKeyPairWidgetState();
}

class _GenerateKeyPairWidgetState extends State<GenerateKeyPairWidget> {
  Future<String> futureText;
  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      futureKeyPair;
  crypto.AsymmetricKeyPair keyPair;
  final key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Gerador de chaves"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  "Gerar par de chaves",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    futureText = Future.value("");
                    futureKeyPair = generateKeyPair();
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder<
                    crypto.AsymmetricKeyPair<crypto.PublicKey,
                        crypto.PrivateKey>>(
                  future: futureKeyPair,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      this.keyPair = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MaterialButton(
                            child: Text(
                              "Mostrar chave de assinatura (privada)",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                futureText = Future.value(
                                    DependencyProvider.of(context)
                                        .getRsaKeyHelper()
                                        .encodePrivateKeyToPemPKCS1(
                                            keyPair.privateKey));
                              });
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              "Mostrar chave de verificação (pública)",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                            onPressed: () {
                              setState(() {
                                futureText = Future.value(
                                    DependencyProvider.of(context)
                                        .getRsaKeyHelper()
                                        .encodePublicKeyToPemPKCS1(
                                            keyPair.publicKey));
                              });
                            },
                          ),
                          MaterialButton(
                            child: Text(
                              "Salvar chaves",
                              style: TextStyle(color: Colors.purple),
                            ),
                            onPressed: () {
                              setState(() {
                                saveKeyPair(keyPair);
                              });
                            },
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: FutureBuilder(
                      future: futureText,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: InkWell(
                              onTap: () {
                                _copyTextToClipboard(snapshot.data);
                                key.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Chave copiada"),
                                  ),
                                );
                              },
                              child: Text(snapshot.data),
                            ),
                          );
                        } else {
                          return Center(
                              child: Text(
                                  "ATENÇÃO: Nunca divulgue sua chave privada"));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      generateKeyPair() {
    var keyHelper = DependencyProvider.of(context).getRsaKeyHelper();
    return keyHelper.computeRSAKeyPair(keyHelper.getSecureRandom());
  }

  _copyTextToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> saveKeyPair(
      crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>
          keyPair) async {
    final String path = await getPath();

    final String privK = DependencyProvider.of(context)
        .getRsaKeyHelper()
        .encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    final String pubK = DependencyProvider.of(context)
        .getRsaKeyHelper()
        .encodePublicKeyToPemPKCS1(keyPair.publicKey);

    LocalStorage().writeKey(privK, path, false);
    LocalStorage().writeKey(pubK, path, true);
  }

  Future<String> getPath() async {
    Directory extDir = await getExternalStorageDirectory();
    String keyPath;
    var now = DateTime.now();
    await Directory(
            '${extDir.path}/chaves/key_${now.year}${now.month}${now.day}${now.hour}${now.minute}')
        .create(recursive: true)
        // The created directory is returned as a Future.
        .then((Directory directory) {
      keyPath = directory.path;
    });
    return keyPath;
  }
}
