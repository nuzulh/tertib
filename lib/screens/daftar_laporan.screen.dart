import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tertib/helpers/constants.dart';
import 'package:tertib/helpers/parser.dart';
import 'package:tertib/models/laporan.dart';
import 'package:tertib/screens/laporan_detail.screen.dart';
import 'package:tertib/screens/welcome.screen.dart';

class DaftarLaporanScreen extends StatefulWidget {
  const DaftarLaporanScreen({super.key});

  @override
  State<DaftarLaporanScreen> createState() => _DaftarLaporanScreenState();
}

class _DaftarLaporanScreenState extends State<DaftarLaporanScreen> {
  String filterBerdasarkan = tipeMasalahList.first;

  @override
  Widget build(BuildContext context) {
    final laporanStream =
        FirebaseFirestore.instance.collection("laporan").snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Daftar Laporan",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: laporanStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs
                .map((e) => Laporan.fromJson(e.data()))
                .where(
                  (item) => item.tipeMasalah == filterBerdasarkan,
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: tipeMasalahList
                        .map(
                          (tipe) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 18,
                              right: 8,
                            ),
                            child: InkWell(
                              onTap: () => setState(() {
                                filterBerdasarkan = tipe;
                              }),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: filterBerdasarkan == tipe
                                      ? Colors.black26
                                      : Colors.white,
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  tipe,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Expanded(
                    // height: MediaQuery.of(context).size.height,
                    // width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LaporanDetailScreen(
                              laporan: data[index],
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parseTimeStamp(data[index].dilaporPada),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                data[index].tipeMasalah,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    data[index].selesai
                                        ? Icons.check_circle_outline
                                        : Icons.access_time_outlined,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    data[index].selesai
                                        ? "Selesai"
                                        : "Menunggu konfirmasi",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Tidak ada laporan",
                style: GoogleFonts.poppins(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        },
      ),
    );
  }
}
