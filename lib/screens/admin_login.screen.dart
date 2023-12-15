import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tertib/components/input_field.dart';
import 'package:tertib/helpers/constants.dart';
import 'package:tertib/models/admin.dart';
import 'package:tertib/screens/admin_register.screen.dart';
import 'package:tertib/screens/daftar_laporan.screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> onLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "ID Admin & Password tidak boleh kosong!",
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

    setState(() {
      isLoading = true;
    });
    try {
      await Admin.login(
        username: usernameController.text,
        password: passwordController.text,
      ).then((admin) {
        if (admin == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "ID Admin atau Password salah!",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DaftarLaporanScreen(),
            ),
            (route) => false,
          );
        }
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
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/logo.png", height: 180),
            InputField(
              controller: usernameController,
              label: "ID Admin",
              hintText: "Masukkan ID Admin",
            ),
            InputField(
              controller: passwordController,
              label: "Password",
              hintText: "******",
              isPassword: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: onLogin,
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
                          const Icon(Icons.login_outlined),
                          const SizedBox(width: 8),
                          Text(
                            "Masuk",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Kembali",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminRegisterScreen(),
                  ),
                ),
                child: Text(
                  "Daftar",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
