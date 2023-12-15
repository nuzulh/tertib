import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tertib/components/input_field.dart';
import 'package:tertib/helpers/constants.dart';
import 'package:tertib/models/laporan.dart';

class FormulirScreen extends StatefulWidget {
  const FormulirScreen({super.key});

  @override
  State<FormulirScreen> createState() => _FormulirScreenState();
}

class _FormulirScreenState extends State<FormulirScreen> {
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  final descriptionController = TextEditingController();

  String tipeMasalah = tipeMasalahList.first;
  File? image;
  String? address;
  Position? location;
  bool isLoading = false;
  bool isSending = false;

  Future<void> pickImage() async {
    setState(() {
      isLoading = true;
    });
    final permission = await geolocator.requestPermission();
    try {
      if (permission == LocationPermission.denied) return;

      final currentLocation = await geolocator.getCurrentPosition();
      final addresses =
          await GeocodingPlatform.instance.placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );
      final first = addresses.first;
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (pickedImage == null) return;

      setState(() {
        image = File(pickedImage.path);
        location = currentLocation;
        address = """${first.thoroughfare}, ${first.subLocality}
${first.locality}, ${first.subAdministrativeArea}
${first.administrativeArea} ${first.postalCode} - ${first.country} (${first.isoCountryCode})
${currentLocation.latitude}, ${currentLocation.longitude}""";
      });
    } on PlatformException catch (_) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onSubmit() async {
    try {
      setState(() {
        isSending = true;
      });
      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Harap mengaktifkan lokasi dan foto lokasi terlebih dahulu!",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
        return;
      }
      await Laporan.kirimLaporan(
        Laporan(
          gambarUrl: image!.path,
          alamat: address!,
          deskripsi: descriptionController.text,
          lokasi: GeoPoint(location!.latitude, location!.longitude),
          dilaporPada: Timestamp.now(),
          tipeMasalah: tipeMasalah,
        ),
      ).then(
        (isSuccess) => {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isSuccess
                          ? "Laporan berhasil dikirim!"
                          : "Laporan gagal dikirim!",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        },
      );
    } catch (_) {
    } finally {
      setState(() {
        isSending = false;
        image = null;
        location = null;
        address = null;
        descriptionController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          "Formulir Laporan",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    "Pilih masalah",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                DropdownMenu(
                  initialSelection: tipeMasalahList.first,
                  textStyle: GoogleFonts.poppins(fontSize: 14),
                  onSelected: (value) => setState(() {
                    tipeMasalah = value!;
                  }),
                  dropdownMenuEntries: tipeMasalahList
                      .map(
                        (value) => DropdownMenuEntry(
                          value: value,
                          label: value,
                        ),
                      )
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "Foto lokasi",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          child: SingleChildScrollView(
                            child: Image.file(
                              image!,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              address ?? "-",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => setState(() {
                              image = null;
                            }),
                            child: Container(
                              width: 48,
                              height: 48,
                              padding:
                                  const EdgeInsets.only(bottom: 8, left: 8),
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OutlinedButton(
                    onPressed: () => isLoading ? null : pickImage(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          image == null
                              ? Icons.camera_alt_outlined
                              : Icons.refresh,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          image == null ? "Ambil foto" : "Ambil ulang",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InputField(
                  controller: descriptionController,
                  label: "Deskripsi",
                  textInputType: TextInputType.multiline,
                  hintText: "Masukkan deskripsi laporan (opsional)",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: isSending
                          ? [
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ]
                          : [
                              const Icon(Icons.send),
                              const SizedBox(width: 8),
                              Text(
                                "Kirim laporan",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black54,
              child: Center(
                child: Container(
                  height: 120,
                  width: 180,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: primaryColor),
                      Text(
                        "Membaca lokasi...",
                        style: GoogleFonts.poppins(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
