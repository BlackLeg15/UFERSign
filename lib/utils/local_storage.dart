import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static LocalStorage _storage;
  factory LocalStorage() => _storage ??= LocalStorage._();

  LocalStorage._();

  Future<File> writeKey(String key, String path, bool type) async {
    if (type == false) {
      final file = File('$path/privada.txt');
      return file.writeAsString('$key');
    } else {
      final file = File('$path/publica.txt');
      return file.writeAsString('$key');
    }
  }

  Future<String> getPath(bool sit) async {
    Directory extDir = await getExternalStorageDirectory();
    String path;
    var now = DateTime.now();
    if (sit == false) {
      await Directory(
              '${extDir.path}/chaves/key_${now.year}${now.month}${now.day}${now.hour}${now.minute}')
          .create(recursive: true)
          .then((Directory directory) {
        path = directory.path;
      });
    } else {
      await Directory(
              '${extDir.path}/assinaturas/signature_${now.year}${now.month}${now.day}${now.hour}${now.minute}')
          .create(recursive: true)
          .then((Directory directory) {
        path = directory.path;
      });
    }
    return path;
  }
}
