import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tertib/screens/welcome.screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleFonts.pendingFonts([GoogleFonts.poppins()]);
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp();

  runApp(const TertibApp());
}

class TertibApp extends StatelessWidget {
  const TertibApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
