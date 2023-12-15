import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nanoid/nanoid.dart';

class Admin {
  final String id;
  final String username;
  final String password;

  const Admin({
    required this.id,
    required this.username,
    required this.password,
  });

  static Future<Admin?> login({
    required String username,
    required String password,
  }) async {
    try {
      final db = FirebaseFirestore.instance.collection("admin").where(
            "username",
            isEqualTo: username,
          );
      final admin = await db.get().then((value) => value.docs.first.data());

      if (BCrypt.checkpw(password, admin["password"])) {
        return Admin(
          id: admin["id"],
          username: admin["username"],
          password: admin["password"],
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> register({
    required String username,
    required String phoneMail,
    required String password,
  }) async {
    try {
      final db = FirebaseFirestore.instance.collection("admin");
      await db.add({
        "id": nanoid(12),
        "username": username,
        "password": BCrypt.hashpw(password, BCrypt.gensalt()),
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
