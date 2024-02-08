import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/model/Users.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum UserRole { Admin, Kasir, Owner }

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  RxString userName = RxString('');
  

  Rx<UserRole> userRole = UserRole.Admin.obs;

  UserRole getCurrentUserRole() {
    return userRole.value;
  }

  Future<void> register(String password, String role, String name,
      String username, String created_at, String updated_at) async {
    try {
      UserM newUser = UserM(
        password: password,
        role: role,
        name: name,
        username: username,
        created_at: created_at,
        updated_at: updated_at,
      );

      await _firestore.collection('users').add(newUser.toJson());
    } catch (e) {
      Get.snackbar('Registration Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateUser(String userId, String role, String name,
      String password, String username, String updated_at) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': role,
        'name': name,
        'password': password,
        'username': username,
        'updated_at': updated_at,
      });
      Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      Get.snackbar('Update Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        String role = userData['role'];

        UserM user = UserM.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        userName.value = user.name;

        switch (role.toLowerCase()) {
          case 'admin':
            userRole.value = UserRole.Admin;
            break;
          case 'kasir':
            userRole.value = UserRole.Kasir;
            break;
          case 'owner':
            userRole.value = UserRole.Owner;
            break;
          default:
            userRole.value = UserRole.Admin;
            break;
        }
        Get.offNamed('/dashboard');

        Get.snackbar(
          '',
          'Welcome ${querySnapshot.docs.first['name']} Anda Sebagai ${querySnapshot.docs.first['role']}',
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.only(bottom: 75.0),
          backgroundColor: warna.nav,
          colorText: warna.putih,
          titleText: SizedBox.shrink(), // Menyembunyikan teks judul
          snackStyle: SnackStyle.FLOATING,
        );
      } else {
        Get.snackbar(
          'Login Error',
          'User not found or invalid credentials',
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.only(bottom: 75.0),
          backgroundColor: warna.ungu,
          colorText: warna.putih,
          titleText: SizedBox.shrink(), // Menyembunyikan teks judul
          snackStyle: SnackStyle.FLOATING,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Error',
        e.toString(),
      );
    }
  }

  Future<void> updatePassword(
      String userId, String newPassword, String confirmPassword) async {
    try {
      if (newPassword == confirmPassword) {
        await _firestore.collection('users').doc(userId).update({
          'password': newPassword,
        });
        print('behasil');
        Get.snackbar('Success', 'Password updated successfully');
      } else {
        print('eror');
        Get.snackbar('Error', 'Password and Confirm Password do not match');
      }
    } catch (e) {
      Get.snackbar('Update Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    // Tampilkan dialog konfirmasi
    bool? confirmLogout = await Get.defaultDialog<bool>(
      title: 'Confirmation',
      middleText: 'Are you sure you want to sign out?',
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false); // Tutup dialog dan kembalikan false
          },
          child: Text(
            'No',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true); // Tutup dialog dan kembalikan true
          },
          child: Text('Yes'),
        ),
      ],
    );

    // Jika pengguna menekan "Yes", maka logout
    if (confirmLogout ?? false) {
      try {
        await FirebaseAuth.instance.signOut();
        Get.offNamed('/login');
        Get.snackbar(
          'Sign Out',
          'You have been signed out',
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.only(bottom: 75.0),
          backgroundColor: warna.ungu,
          colorText: warna.putih,
          titleText: SizedBox.shrink(), // Menyembunyikan teks judul
          snackStyle: SnackStyle.FLOATING,
        );
      } catch (e) {
        // Tangani error jika logout gagal
        print('Error signing out: $e');
        Get.snackbar(
          'Error',
          'Failed to sign out. Please try again.',
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.only(bottom: 75.0),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          titleText: SizedBox.shrink(),
          snackStyle: SnackStyle.FLOATING,
        );
      }
    }
  }

  Future<int> countUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }

  Future<int> countUser() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
