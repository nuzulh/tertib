import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tertib/models/storage.dart';

class Laporan {
  final String gambarUrl;
  final String deskripsi;
  final String alamat;
  final GeoPoint lokasi;
  final Timestamp dilaporPada;
  final String tipeMasalah;
  final bool selesai;
  final Timestamp? selesaiPada;

  const Laporan({
    required this.gambarUrl,
    required this.deskripsi,
    required this.alamat,
    required this.lokasi,
    required this.dilaporPada,
    this.tipeMasalah = "Hewan ternak",
    this.selesai = false,
    this.selesaiPada,
  });

  static Laporan fromJson(Map<String, dynamic> json) => Laporan(
        gambarUrl: json["gambarUrl"],
        deskripsi: json["deskripsi"],
        alamat: json["alamat"],
        lokasi: json["lokasi"],
        dilaporPada: json["dilaporPada"],
        tipeMasalah: json["tipeMasalah"],
        selesai: json["selesai"],
        selesaiPada: json["selesaiPada"],
      );

  static Map<String, dynamic> toJson(Laporan laporan) => {
        "gambarUrl": laporan.gambarUrl,
        "deskripsi": laporan.deskripsi,
        "alamat": laporan.alamat,
        "lokasi": laporan.lokasi,
        "dilaporPada": laporan.dilaporPada,
        "tipeMasalah": laporan.tipeMasalah,
        "selesai": laporan.selesai,
        "selesaiPada": laporan.selesaiPada,
      };

  static Future<bool> kirimLaporan(Laporan laporan) async {
    final db = FirebaseFirestore.instance.collection("laporan");

    try {
      final fileName = laporan.gambarUrl.split("/").last;
      final isUploaded = await Storage.uploadFile(
        File(laporan.gambarUrl).readAsBytesSync(),
        fileName,
      );

      if (!isUploaded) return false;

      await db.add(
        toJson(
          Laporan(
            gambarUrl: fileName,
            deskripsi: laporan.deskripsi,
            alamat: laporan.alamat,
            lokasi: laporan.lokasi,
            tipeMasalah: laporan.tipeMasalah,
            dilaporPada: laporan.dilaporPada,
          ),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> selesaiLaporan(Laporan laporan) async {
    final db = FirebaseFirestore.instance.collection("laporan");

    try {
      final docId = await db
          .where("gambarUrl", isEqualTo: laporan.gambarUrl)
          .get()
          .then((value) => value.docs.first.id);

      await db.doc(docId).update({
        "selesai": true,
        "selesaiPada": Timestamp.now(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
