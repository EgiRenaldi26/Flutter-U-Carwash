import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChange extends StatefulWidget {
  final String userId;

  UserChange({required this.userId});
  @override
  State<UserChange> createState() => _UserChangeState();
}

class _UserChangeState extends State<UserChange> {
  final AuthController _AuthController = AuthController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: warna.background,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: warna.background,
        title: Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Exm. Egi Renaldi ',
                labelText: 'New Password',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'Exm. Egi Renaldi ',
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String newPassword = passwordController.text.trim();
                  String confirmNewPassword = confirmController.text.trim();

                  if (newPassword.isNotEmpty && confirmNewPassword.isNotEmpty) {
                    if (newPassword == confirmNewPassword) {
                      _AuthController.updatePassword(
                          widget.userId, newPassword, confirmNewPassword);
                    } else {
                      print('Passwords do not match');
                    }
                  } else {
                    print('Please fill in all fields correctly');
                  }

                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warna.ungu, // Set background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    // Set border radius to 25%
                  ),
                  minimumSize:
                      Size(double.infinity, 50.0), // Set the height to 50.0
                ),
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
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
