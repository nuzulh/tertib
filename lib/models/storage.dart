import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  static Future<bool> uploadFile(
    Uint8List filePath,
    String fileName,
  ) async {
    try {
      await FirebaseStorage.instance.ref().child(fileName).putData(filePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<String> getDownloadURL(String fileName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL();
    } catch (_) {
      return "";
    }
  }

  static Future<bool> deleteFile(String fileName) async {
    try {
      await FirebaseStorage.instance.ref().child(fileName).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
