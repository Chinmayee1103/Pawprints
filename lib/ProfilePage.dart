import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption/auth.dart';
import 'package:pet_adoption/LoginPage.dart'; // Ensure correct import path
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool _status = true; // Indicates whether the profile is in edit mode
  final FocusNode myFocusNode = FocusNode();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String _name = "";
  String _email = "";
  

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
      print("User details loaded: $userDetails"); // Debug log
      setState(() {
        _name = userDetails['name'] ?? "";
        _email = userDetails['email'] ?? "";
        _phoneController.text = userDetails['phone'] ?? "";
        _cityController.text = userDetails['city'] ?? "";
        _stateController.text = userDetails['state'] ?? "";
      });
    } else {
      print("No user details found"); // Debug log
    }
  } else {
    print("No current user"); // Debug log
  }
}

Future<void> _saveUserDetails() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("Saving user details: ${_name}, ${_phoneController.text}, ${_cityController.text}, ${_stateController.text},${_emailController.text}"); // Debug log
    await Auth().updateUserDetails(
      uid: user.uid,
      name: _name,
      phone: _phoneController.text,
      email: _emailController.text,
      city: _cityController.text,
      state: _stateController.text,
    );
  } else {
    print("No current user"); // Debug log
  }
}


  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xffF6C953); // Yellow color
    final Color customBlueColor = Colors.white; // Custom Blue color
    // final Color tealColor = Color(0xFF004D40); // Teal color

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
          CircleAvatar(
            radius: 80.0,
            backgroundImage: ExactAssetImage('assets/intro1.jpeg'),
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
                      _buildInfoField('Phone', _phoneController),
                      _buildInfoField('City', _cityController),
                      _buildInfoField('State', _stateController),
                      SizedBox(height: 20.0),
                      _status ? _getEditButton() : _getActionButtons(),
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

  Widget _buildInfoField(String label, TextEditingController controller) {
    final Color primaryColor = Color(0xFF004D40); // Teal color

    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 21.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: TextField(
              style: TextStyle(
                color: _status ? Colors.black : Colors.grey,
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
              enabled: !_status,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditButton() {
    final Color primaryColor = Color(0xFF004D40); // Teal color

    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
        ),
        child: Text(
          "Edit Info",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            _status = false; // Set status to false to enable editing
          });
        },
      ),
    );
  }

  Widget _getActionButtons() {
    final Color primaryColor = Color(0xFF004D40); // Teal color
    final Color yellowColor = Color(0xffF6C953); // Yellow color

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
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _saveUserDetails(); // Save user details
                  setState(() {
                    _status = true; // Set status to true to disable editing
                    FocusScope.of(context).requestFocus(FocusNode());
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
                  backgroundColor: yellowColor,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _status = true; // Set status to true to disable editing
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
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, LoginPage.id);
        },
      ),
    );
  }
}
