import 'dart:io';

class LocalStorage {
  static LocalStorage _storage;
  factory LocalStorage() => _storage ??= LocalStorage._();

  LocalStorage._();

  Future<File> writeKey(String key, String path, bool type) async {
    if(type == false){
      final file = File('$path/privK.txt');
      return file.writeAsString('$key');
    }
    else{
      final file = File('$path/pubK.txt');
      return file.writeAsString('$key');
    }
  }

}
