import 'dart:convert';

import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';

import "package:pointycastle/export.dart";

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RSAPrivateKey privK;
  RSAPublicKey pubK;
  Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> pair;
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> pair2;
  bool busy = false;
  String pubKString = "nulo";
  String privKString = "nulo";

  Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> computeRSAKeyPair(
      SecureRandom secureRandom) async {
    return await compute(generateRSAkeyPair, secureRandom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: busy
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: Text(
                      "Gerar chaves",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      busy = true;
                      pair = computeRSAKeyPair(exampleSecureRandom());
                      busy = false;
                    },
                  ),
                  FutureBuilder<AsymmetricKeyPair<RSAPublicKey, PrivateKey>>(
                      future: pair,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // if we are waiting for a future to be completed, show a progress indicator
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          // Else, store the new keypair in this state and sbow two buttons
                          this.pair2 = snapshot.data;
                          return FloatingActionButton(
                            child: Text(
                              "Mostrar chaves",
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              setState(() {
                                pubK = pair2.publicKey;
                                privK = pair2.privateKey;
                                pubKString = encodePublicKeyToPemPKCS1(pubK);
                                privKString = encodePrivateKeyToPemPKCS1(privK);
                              });
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                  Container(
                    child: Text(""),
                  ),
                  Container(
                    child: Text(privKString),
                  )
                ],
              ),
      ),
    );
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 5),
          secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    var topLevel = new ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));

    var dataBase64 = base64.encode(topLevel.encodedBytes);
    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    var topLevel = new ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer(privateKey.exponent);
    var privateExponent = ASN1Integer(privateKey.d);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.d % (privateKey.p - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.d % (privateKey.q - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q.modInverse(privateKey.p);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
