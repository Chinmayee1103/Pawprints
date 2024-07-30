import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class OrganizationRequests extends StatefulWidget {
  final String organizationId;

  OrganizationRequests({required this.organizationId});

  @override
  _OrganizationRequestsState createState() => _OrganizationRequestsState();
}

class _OrganizationRequestsState extends State<OrganizationRequests> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  String _description = '';
  File? _imageFile;
  String _uploadedFileURL = '';
  bool _isImageUploaded = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
        backgroundColor: Color(0xffE0BA59),
        elevation: 0,
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE0BA59), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Description is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              if (_isImageUploaded)
                                _imageFile == null
                                    ? Image.asset('images/placeholder.png')
                                    : Image.file(
                                        _imageFile!,
                                        height: 50.0,
                                        width: 50.0,
                                      ),
                              SizedBox(width: 20.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: _isImageUploaded ? _uploadFile : _chooseFile,
                                child: Text(
                                  _isImageUploaded ? 'UPLOAD IMAGE' : 'CHOOSE IMAGE',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            child: Text(
                              'SUBMIT REQUEST',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_isImageUploaded && _uploadedFileURL.isEmpty) {
                                  await _uploadFile();
                                }
                                _submitData();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('organization_requests')
                          .doc(widget.organizationId)
                          .collection('requests')
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final requests = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: requests.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var request = requests[index];
                            return Card(
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (request['imageUrl'] != null && request['imageUrl'].isNotEmpty)
                                      Image.network(request['imageUrl']),
                                    SizedBox(height: 10),
                                    Text(
                                      request['description'] ?? 'No description available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      request['timestamp']?.toDate()?.toString() ?? 'No date available',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseFile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isImageUploaded = true;
      });
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
    });
    if (_imageFile != null) {
      try {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('Requests/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageReference.putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        final fileURL = await snapshot.ref.getDownloadURL();

        setState(() {
          _uploadedFileURL = fileURL;
          isLoading = false;
        });

        print('File URL: $_uploadedFileURL'); // Debug print
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error uploading file: $e'); // Log error
      }
    }
  }

  Future<void> _submitData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('organization_requests')
          .doc(widget.organizationId)
          .collection('requests')
          .add({
        'description': _description,
        'imageUrl': _uploadedFileURL.isNotEmpty ? _uploadedFileURL : '', // Ensure URL is not null
        'timestamp': Timestamp.now(),
      });

      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true); // Indicate success
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error submitting request: $e'); // Log error
    }
  }
}
