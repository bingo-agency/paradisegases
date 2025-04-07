import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final String id;
  Profile({super.key, required this.id});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ntnController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 22.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextField("Title", titleController, false),
                    buildTextField("Full Name", nameController, true),
                    buildTextField("Email", emailController, false),
                    buildTextField("Phone Number", phoneController, true),
                    buildTextField("City", cityController, false),
                    buildTextField("NTN", ntnController, false),
                    buildTextField("CNIC", cnicController, false),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Settings Updated!")),
                                );
                              }
                            },
                            child: Text("Save", style: GoogleFonts.poppins()),
                          ),
                        ),
                        const SizedBox(height: 10), // Space between buttons
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              nameController.clear();
                              emailController.clear();
                              phoneController.clear();
                              cityController.clear();
                              ntnController.clear();
                              cnicController.clear();
                              titleController.clear();
                            },
                            child: Text("Cancel", style: GoogleFonts.poppins()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool validate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: validate ? (value) => validateField(label, value) : null,
      ),
    );
  }

  String? validateField(String label, String? value) {
    if (label == "Full Name") {
      if (value == null || value.isEmpty) return "Name is required";
      if (value.length < 3) return "Name must be at least 3 characters";
    } else if (label == "Phone Number") {
      if (value == null || value.isEmpty) return "Phone number is required";
      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value))
        return "Enter a valid phone number";
    } else if (label == "NTN" || label == "CNIC") {
      if (ntnController.text.isEmpty && cnicController.text.isEmpty) {
        return "Either NTN or CNIC must be provided";
      }
    }
    return null;
  }
}
