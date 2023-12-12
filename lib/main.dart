import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:votingapp/pages/user/login_register.dart';
import 'firebase_options.dart';
import 'package:votingapp/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // Atur rute inisial ke halaman home
      routes: {
        '/home': (context) =>
            WidgetTree(), // Menggunakan WidgetTree sebagai home page
      },
    );
  }
}
