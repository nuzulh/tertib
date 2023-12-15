import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tertib/helpers/constants.dart';
import 'package:tertib/helpers/parser.dart';
import 'package:tertib/models/laporan.dart';
import 'package:tertib/models/storage.dart';

class LaporanDetailScreen extends StatefulWidget {
  final Laporan laporan;

  const LaporanDetailScreen({super.key, required this.laporan});

  @override
  State<LaporanDetailScreen> createState() => _LaporanDetailScreenState();
}

class _LaporanDetailScreenState extends State<LaporanDetailScreen> {
  bool isLoading = false;
  bool isSelesai = false;

  @override
  void initState() {
    super.initState();
    isSelesai = widget.laporan.selesai;
  }

  Future<void> onSelesai() async {
    if (isLoading) return;

    try {
      setState(() {
        isLoading = true;
      });
      final resultSelesai = await Laporan.selesaiLaporan(widget.laporan);
      setState(() {
        isSelesai = resultSelesai;
      });
    } catch (_) {
    } finally {
      setState(() {
        isLoading = false;
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
          "Rincian Laporan",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dilapor pada:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 6),
                child: Text(
                  parseTimeStamp(widget.laporan.dilaporPada),
                  style: GoogleFonts.poppins(),
                ),
              ),
              Text(
                "Foto lokasi:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18, top: 6),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 280,
                      child: FutureBuilder(
                        future: Storage.getDownloadURL(
                          widget.laporan.gambarUrl,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Image.network(
                                snapshot.data!,
                                width: double.infinity,
                              ),
                            );
                          }

                          return Center(
                            child: Text(
                              "Menampilkan gambar...",
                              style: GoogleFonts.poppins(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.laporan.alamat,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Status laporan:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 6),
                child: Row(
                  children: [
                    Icon(
                      isSelesai
                          ? Icons.check_circle_outline
                          : Icons.access_time_outlined,
                      color: isSelesai ? Colors.green : Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isSelesai ? "Selesai" : "Menunggu konfirmasi",
                      style: GoogleFonts.poppins(
                        color: isSelesai ? Colors.green : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                "Deskripsi:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 6),
                child: Text(
                  widget.laporan.deskripsi,
                  style: GoogleFonts.poppins(),
                ),
              ),
              if (!isSelesai)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: onSelesai,
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
                      children: isLoading
                          ? [
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ]
                          : [
                              const Icon(Icons.check),
                              const SizedBox(width: 8),
                              Text(
                                "Selesai",
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
      ),
    );
  }
}
