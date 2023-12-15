import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tertib/components/input_field.dart';
import 'package:tertib/helpers/constants.dart';
import 'package:tertib/models/admin.dart';
import 'package:tertib/screens/admin_login.screen.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final usernameController = TextEditingController();
  final phoneMailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> onRegister() async {
    setState(() {
      isLoading = true;
    });

    String message = "";

    if (usernameController.text.isEmpty || phoneMailController.text.isEmpty) {
      message = "NIP dan Email/No. HP tidak boleh kosong!";
    }
    if (passwordController.text != confirmPasswordController.text) {
      message = "Password tidak cocok!";
    }

    if (message.isEmpty) {
      await Admin.register(
        username: usernameController.text,
        phoneMail: phoneMailController.text,
        password: passwordController.text,
      ).then((isSuccess) {
        if (!isSuccess) {
          message = "Daftar gagal!";
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminLoginScreen(),
            ),
          );
        }
      });
    }

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              message.isEmpty ? Icons.check : Icons.warning_amber_rounded,
              color: message.isEmpty ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message.isEmpty ? "Daftar berhasil! Silahkan login." : message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
              label: "NIP",
              hintText: "Masukkan NIP",
            ),
            InputField(
              controller: phoneMailController,
              label: "Email/No. HP",
              hintText: "Masukkan Email/No. HP",
            ),
            InputField(
              controller: passwordController,
              label: "Password",
              hintText: "******",
              isPassword: true,
            ),
            InputField(
              controller: confirmPasswordController,
              label: "Password",
              hintText: "******",
              isPassword: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: onRegister,
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
                            "Daftar",
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
          ],
        ),
      ),
    );
  }
}
