import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userNIKController = TextEditingController();
  final TextEditingController _userProvinceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _userNIKController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _userProvinceController,
              decoration: InputDecoration(labelText: 'Asal Provinsi'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Panggil fungsi untuk update profil
                updateProfile();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void updateProfile() async {
    // Access Firestore and update user profile
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update({
        'userName': _userNameController.text,
        'userNIK': _userNIKController.text,
        'userProvince': _userProvinceController.text,
      });

      // Navigate back to the profile page
      Navigator.pop(context);
    } catch (error) {
      print('Error updating profile: $error');
      // Handle error
    }
  }
}
