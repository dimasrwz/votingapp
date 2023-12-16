import 'package:flutter/material.dart';
import 'package:votingapp/pages/user/login_register.dart';
import 'package:votingapp/pages/voting_page.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(), // Add this line
        '/votingpage': (context) => VotingPage(),
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            HalamanLogin(),
          ],
        ),
      ),
    );
  }
}

class HalamanLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 411,
          height: 731,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color.fromARGB(255, 18, 32, 47)),
          child: Stack(
            children: [
              Positioned(
                left: -24,
                top: -63,
                child: Container(
                  width: 459,
                  height: 478,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/459x478"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 103,
                top: 186,
                child: Container(
                  width: 205,
                  height: 229.28,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 200,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 82,
                top: 109,
                child: SizedBox(
                  width: 249,
                  height: 67,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'VOTE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'APP',
                          style: TextStyle(
                            color: Color(0xFFEEF318),
                            fontSize: 48,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                left: 96,
                top: 504,
                child: Container(
                  width: 231,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x99000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 137,
                top: 425,
                child: SizedBox(
                  width: 150,
                  height: 31,
                  child: Text(
                    'L U B E R J U R D I L',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -8,
                top: -33,
                child: Container(
                  width: 430,
                  height: 764.50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/430x764"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 116,
                top: 516,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Vote Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ], // <-- Added closing bracket for the Stack widget
          ),
        ),
      ],
    );
  }
}
