import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votingapp/auth.dart';
// Ubah sesuai dengan lokasi file AdminPage
import 'package:votingapp/pages/admin/admin_page.dart'; // Ubah sesuai dengan lokasi file AdminPage

class LoginRegisterAdminPage extends StatefulWidget {
  const LoginRegisterAdminPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterAdminPageState createState() => _LoginRegisterAdminPageState();
}

class _LoginRegisterAdminPageState extends State<LoginRegisterAdminPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      // Navigasi ke halaman AdminPage setelah berhasil login
      Navigator.pushReplacement<User?, void>(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Text(
      isLogin ? 'Admin Login' : 'Admin Register',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _logoWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png',
              height: 200), // Sesuaikan dengan path logo Anda
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error: $errorMessage',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : null,
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
      ),
      child: Text(
        'Admin Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return isLogin
        ? Container() // Tidak menampilkan tombol Register jika sedang login
        : Container(); // Juga tidak menampilkan tombol Register jika sedang register
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        // Menambahkan tombol back di navbar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman LoginRegisterUserPage
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logoWidget(),
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword, isPassword: true),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
