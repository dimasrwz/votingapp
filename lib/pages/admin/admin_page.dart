import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminPage> {
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('candidate');

  int? _selectedItemIndex; // Variable to track the selected item

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _imageController.text = documentSnapshot['image'];
      _namaController.text = documentSnapshot['nama'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            // prevent the soft keyboard from covering text fields
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'image'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'nama',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(action == 'create' ? 'Create' : 'Update'),
                onPressed: () async {
                  final String? image = _imageController.text;
                  final String? nama = _namaController.text;
                  if (image != null && nama != null) {
                    if (action == 'create') {
                      // Persist a new product to Firestore
                      await _productss.add({
                        "image": image,
                        "nama": nama,
                        "vote": false,
                      });
                    }

                    if (action == 'update') {
                      // Update the product
                      await _productss.doc(documentSnapshot!.id).update({
                        "image": image,
                        "nama": nama,
                      });
                    }

                    // Clear the text fields
                    _imageController.text = '';
                    _namaController.text = '';

                    // Hide the bottom sheet
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have successfully deleted a product')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD'),
      ),
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: _selectedItemIndex == index
                      ? Colors.blueAccent
                      : Colors.black,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(documentSnapshot['image']),
                        subtitle: Text((documentSnapshot['nama'])),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _createOrUpdate(documentSnapshot);
                                  setState(() {
                                    _selectedItemIndex = index;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(documentSnapshot.id);
                                  setState(() {
                                    _selectedItemIndex = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedItemIndex = index;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
