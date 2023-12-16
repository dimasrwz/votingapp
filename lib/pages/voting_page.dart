import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:votingapp/pages/user/edit_user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votingapp/pages/user/login_register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VotingPage(),
    );
  }
}

class VotingPage extends StatefulWidget {
  @override
  _VotingPageState createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting App'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CandidatesPage(),
          ProfilePage(
            userId: 'so6Q797nMrASSemGxlIP',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Kandidat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class Candidate {
  final String id;
  final String name;
  final String photo;

  Candidate({required this.id, required this.name, required this.photo});

  factory Candidate.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Candidate(
      id: doc.id,
      name: data['name'] ?? '',
      photo: data['photo'] ?? '',
    );
  }
}

class CandidatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Tambahkan Center widget di sini
      child: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('candidate').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Text('Paslon Tidak Ada');
            }

            var candidates = snapshot.data!.docs;

            List<Widget> kandidatWidget = [];

            for (var candidate in candidates) {
              var kandidatData = candidate.data() as Map<String, dynamic>?;

              if (kandidatData != null) {
                kandidatWidget.add(
                  CandidateCard(
                    candidateName: kandidatData['nama'] ?? '',
                  ),
                );
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Halaman Kandidat',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                Column(
                  children: kandidatWidget,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future<void> createUserProfile({
    required String userId,
    required String userName,
    required String userNIK,
    required String userProvince,
  }) async {
    try {
      await userCollection.doc(userId).set({
        'userName': userName,
        'userNIK': userNIK,
        'userProvince': userProvince,
      });
    } catch (e) {
      print('Error creating user profile: $e');
      throw Exception('Error creating user profile');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
      return userSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting user profile: $e');
      throw Exception('Error getting user profile');
    }
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName;
  late String userNIK;
  late String userProvince;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Load user data when the widget is initialized
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      // Retrieve user data from Firestore
      Map<String, dynamic>? userData =
          await _firestoreService.getUserProfile(widget.userId);

      // Update the state with the retrieved user data
      setState(() {
        userName = userData?['userName'] ?? '';
        userNIK = userData?['userNIK'] ?? '';
        userProvince = userData?['userProvince'] ?? '';
      });
    } catch (error) {
      print('Error loading user data: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Pengguna',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                UserInfoItem(label: 'Nama', value: userName),
                UserInfoItem(label: 'NIK', value: userNIK),
                UserInfoItem(label: 'Asal Provinsi', value: userProvince),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Pindahkan ke halaman Edit Profil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(userId: widget.userId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Edit Profil'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Fungsi untuk sign out
                    await FirebaseAuth.instance.signOut();
                    // Arahkan pengguna ke halaman Login/Register setelah sign out
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(), // Sesuaikan dengan halaman login/register Anda
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        Divider(),
      ],
    );
  }
}

class CandidateCard extends StatelessWidget {
  final String candidateName;

  const CandidateCard({
    Key? key,
    required this.candidateName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/placeholder_image.jpg'), // Gunakan NetworkImage untuk gambar dari URL
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(
              candidateName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Mengubah warna font menjadi hitam
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Anda Telah Memilih',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$candidateName',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Terimakasih sudah memilih'),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
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
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Pilih'),
            ),
          ],
        ),
      ),
    );
  }
}
