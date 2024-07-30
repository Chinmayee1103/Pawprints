import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:pet_adoption/auth.dart';
import 'package:pet_adoption/LoginPage.dart';
import 'dart:io';

import 'package:pet_adoption/auth1.dart';

class SettingsPage extends StatefulWidget {
  static const String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEditing = false; // Used for toggling edit mode

  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _name = "";
  String _email = "";
  String _profileImageUrl = "";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadOrganizationDetails();
  }

  Future<void> _loadOrganizationDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic>? orgDetails = await Auth1().getOrganizationDetails(user.uid);
      if (orgDetails != null) {
        setState(() {
          _name = orgDetails['name'] ?? "";
          _email = orgDetails['email'] ?? user.email ?? ""; // Ensure email is set
          _contactNumberController.text = orgDetails['contactNumber'] ?? "";
          _addressController.text = orgDetails['address'] ?? "";
          _profileImageUrl = orgDetails['profileImageUrl'] ?? "";
        });
      } else {
        setState(() {
          _email = user.email ?? ""; // Fallback to user's email
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveOrganizationDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = _profileImageUrl;

      if (_imageFile != null) {
        imageUrl = await _uploadImage(user.uid, _imageFile!);
      }

      await Auth1().updateOrganizationDetails(
        uid: user.uid,
        name: _nameController.text,
        contactNumber: _contactNumberController.text,
        email: _emailController.text,
        address: _addressController.text,
        profileImage: imageUrl,
      );

      if (_imageFile != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    }
  }

  Future<String> _uploadImage(String uid, File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('organization_images')
        .child('$uid.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, LoginPage.id);
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xffF6C953); // Yellow color
    final Color customBlueColor = Colors.white; // Custom Blue color

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (_imageFile != null
                      ? FileImage(_imageFile!)
                      : _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : null) as ImageProvider<Object>?,
                  child: _profileImageUrl.isEmpty && _imageFile == null
                      ? Icon(Icons.person, size: 80.0, color: Colors.white)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff004D40), // Teal color
                    radius: 20.0,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Text(
            _name.isEmpty ? 'Organization Name' : _name,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: customBlueColor,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            _email.isEmpty ? 'organization@example.com' : _email,
            style: TextStyle(
              fontSize: 18.0,
              color: customBlueColor,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: customBlueColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70.0),
                  topRight: Radius.circular(70.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildInfoField('Contact Number', _contactNumberController,
                          showEditIcon: _isEditing),
                      _buildInfoField('Address', _addressController),
                      SizedBox(height: 20.0),
                      _isEditing ? _getActionButtons() : _getEditIcon(),
                      SizedBox(height: 20.0),
                      _getLogoutButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller,
      {bool showEditIcon = false}) {
    final Color primaryColor = Color(0xFF004D40); // Teal color

    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 21.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showEditIcon) // Show edit icon if needed
                      IconButton(
                        icon: Icon(Icons.edit, color: primaryColor),
                        onPressed: () {
                          // Handle edit icon press if needed
                        },
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: TextField(
                    style: TextStyle(
                      color: _isEditing ? Colors.black : Colors.grey,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      hintText: "Enter $label",
                    ),
                    enabled: _isEditing,
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for Cancel button
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _isEditing = false; // Disable editing
                    _loadOrganizationDetails(); // Reload details to discard changes
                  });
                },
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff004D40), // Teal color for Save button
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _saveOrganizationDetails(); // Save details
                  setState(() {
                    _isEditing = false; // Disable editing after saving
                  });
                },
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    final Color primaryColor = Color(0xFF004D40); // Teal color

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isEditing = true; // Enable editing
          });
        },
        child: Icon(
          Icons.edit,
          color: primaryColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget _getLogoutButton() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Red color for Logout button
        ),
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _logout,
      ),
    );
  }
}