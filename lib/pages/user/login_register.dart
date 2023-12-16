import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votingapp/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:votingapp/pages/admin/login_register_admin.dart';
import 'package:votingapp/pages/voting_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/logo.png',
            height: 100), // Sesuaikan dengan path logo Anda
        SizedBox(height: 20), // Spacer untuk memberikan jarak
      ],
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        // User canceled login
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Berhasil login dengan Google, arahkan ke VotingPage
        Navigator.pushReplacement<User?, void>(
          context,
          MaterialPageRoute(builder: (context) => VotingPage()),
        );
      }

      return user; // Return user jika diperlukan di luar untuk pemrosesan lebih lanjut
    } catch (e) {
      print('Error during Google sign in: $e');
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      // Navigasi ke halaman VotingPage setelah berhasil login
      Navigator.pushReplacement<User?, void>(
        context,
        MaterialPageRoute(builder: (context) => VotingPage()),
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
      // Tampilkan pesan sukses jika user berhasil mendaftar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Register Successful'),
            content: Text('Your account has been successfully registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the text fields after successful registration
      _controllerEmail.clear();
      _controllerPassword.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Text(
      isLogin ? 'Login' : 'Register',
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
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
      ),
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register' : 'Login'),
    );
  }

  Widget _googleSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        User? user = await signInWithGoogle();
        if (user != null) {
          print('Successfully signed in with Google: ${user.displayName}');
        } else {
          print('Sign in with Google failed.');
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _adminButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginRegisterAdminPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
      ),
      child: Text('Admin', style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget _buildBody() {
    return Container(
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
          _googleSignInButton(),
          SizedBox(height: 20), // Sesuaikan dengan jarak yang diinginkan
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: _buildBody(),
      floatingActionButton: _adminButton(),
    );
  }
}
