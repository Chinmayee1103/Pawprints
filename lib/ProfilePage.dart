import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  String _name = "John Doe";
  String _email = "john.doe@example.com";
  String _phone = "123-456-7890";
  String _city = "New York";
  String _state = "NY";

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xffF6C953); // Yellow color
    final Color yellowColor = Color(0xffF6C953); // Yellow color
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
                    FontAwesomeIcons.arrowLeft,
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
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
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
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Personal Information',
                                        style: TextStyle(
                                          color: Color(0xff01637E),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            _buildInfoField('Name', _name, (value) {
                              setState(() {
                                _name = value;
                              });
                            }),
                            _buildInfoField('Email ID', _email, (value) {
                              setState(() {
                                _email = value;
                              });
                            }, enabled: false),
                            _buildInfoField('Mobile', _phone, (value) {
                              setState(() {
                                _phone = value;
                              });
                            }),
                            _buildInfoField('City', _city, (value) {
                              setState(() {
                                _city = value;
                              });
                            }),
                            _buildInfoField('State', _state, (value) {
                              setState(() {
                                _state = value;
                              });
                            }),
                            !_status ? _getActionButtons() : Container(),
                            SizedBox(height: 20.0),
                            _getLogoutButton(),
                          ],
                        ),
                      ),
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

  Widget _buildInfoField(
      String label, String initialValue, Function(String) onChanged,
      {bool enabled = true}) {
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
                color: enabled ? Colors.black : Colors.grey,
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
              enabled: enabled && !_status,
              onChanged: onChanged,
              controller: TextEditingController(text: initialValue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    final Color primaryColor = Color(0xFF004D40); // Teal color
    final Color yellowColor = Color(0xffF6C953); // Yellow color

    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff01637E),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
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
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
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

    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: primaryColor,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getLogoutButton() {
    final Color primaryColor = Color(0xFF004D40); // Teal color
    final Color yellowColor = Color(0xff01637E); // Yellow color

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: yellowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 27.0),
      ),
      icon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      onPressed: _logout,
    );
  }

  void _logout() {
    // Implement your logout functionality here
    // For example, if you are using Firebase Authentication, you can call:
    // FirebaseAuth.instance.signOut();
    // Then navigate to the login screen:
    // Navigator.pushReplacementNamed(context, LoginPage.id);
  }
}
