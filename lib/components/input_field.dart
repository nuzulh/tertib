import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tertib/helpers/constants.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType textInputType;
  final String? hintText;
  final bool isPassword;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputType = TextInputType.text,
    this.hintText,
    this.isPassword = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            widget.label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ),
        TextField(
          controller: widget.controller,
          keyboardType: widget.textInputType,
          maxLines: widget.textInputType == TextInputType.multiline ? 3 : 1,
          style: GoogleFonts.poppins(fontSize: 14),
          obscureText: widget.isPassword && !showPassword,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.all(10),
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.black54),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: primaryColor),
            ),
            suffix: widget.isPassword
                ? IconButton(
                    onPressed: toggleShowPassword,
                    icon: Icon(
                      showPassword
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
