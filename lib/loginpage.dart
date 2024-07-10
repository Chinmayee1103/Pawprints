import 'package:flutter/material.dart';
import 'package:pet_adoption/First.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/signinpage.jpeg',
                  fit: BoxFit.cover,
                  height: 900,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150, left: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Furry Friend"',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 50),
                            Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the desired screen/page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => First(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 25),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the desired screen/page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => First(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 650, left: 35),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the desired screen/page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => First(),
                            ),
                          );
                        },
                        child: Container(
                          height: 55,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Color(0xff25BCA9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Sign in with Phone number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 55,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the desired screen/page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => First(),
                                ),
                              );
                            },
                            child: Center(
                              child: Row(
                                children: [
                                  Image.asset('assets/apple-logo (1).png'),
                                  SizedBox(width: 25),
                                  Text(
                                    'Continue with Apple',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the desired screen/page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => First(),
                            ),
                          );
                        },
                        child: Text(
                          'Dont have an account? Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
