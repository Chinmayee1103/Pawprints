import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/auth.dart';
import 'package:pet_adoption/LoginPage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false; // Used for toggling edit mode

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _name = "";
  String _email = "";
  String _profileImageUrl = "";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic>? userDetails = await Auth().getUserDetails(user.uid);
      if (userDetails != null) {
        setState(() {
          _name = userDetails['name'] ?? "";
          _email =
              userDetails['email'] ?? user.email ?? ""; // Ensure email is set
          _phoneController.text = userDetails['phone'] ?? "";
          _cityController.text = userDetails['city'] ?? "";
          _stateController.text = userDetails['state'] ?? "";
          _profileImageUrl = userDetails['profileImageUrl'] ?? "";
        });
      } else {
        setState(() {
          _email = user.email ?? ""; // Fallback to user's email
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = _profileImageUrl;

      if (_imageFile != null) {
        imageUrl = await _uploadImage(user.uid, _imageFile!);
      }

      await Auth().updateUserDetails(
        uid: user.uid,
        name: _name,
        phone: _phoneController.text,
        email: _emailController.text,
        city: _cityController.text,
        state: _stateController.text,
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
        .child('profile_images')
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
            _name.isEmpty ? 'John Doe' : _name,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: customBlueColor,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            _email.isEmpty ? 'johndoe@example.com' : _email,
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
                      _buildInfoField('Phone', _phoneController,
                          showEditIcon: _isEditing),
                      _buildInfoField('City', _cityController),
                      _buildInfoField('State', _stateController),
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
                    _loadUserDetails(); // Reload user details to discard changes
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
                  backgroundColor:
                      Color(0xFF004D40), // Teal color for Save button
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _saveUserDetails();
                  setState(() {
                    _isEditing = false; // Disable editing
                    FocusScope.of(context).requestFocus(FocusNode());
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
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(Icons.edit, color: Color(0xFF004D40)), // Teal color
          onPressed: () {
            setState(() {
              _isEditing = true; // Allow editing
            });
          },
        ),
      ),
    );
  }

  Widget _getLogoutButton() {
    final Color primaryColor = Color(0xFF004D40); // Teal color

    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
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
