import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pet_adoption/AdoptionPage.dart';
import 'package:pet_adoption/CarePage.dart';
import 'package:pet_adoption/HelpingHands.dart';
import 'package:pet_adoption/ProfilePage.dart';
import 'package:pet_adoption/ECommercePage.dart';

class First extends StatelessWidget {
  // Define the static ID
  static const String id = 'first_page';

  First({Key? key}) : super(key: key);

  final List<String> tips = [
    'Regular vet visits are important for your pet\'s health.',
    'Provide your pet with a balanced diet.',
    'Keep your pet active to maintain a healthy weight.',
    'Groom your pet regularly to prevent matting and skin issues.',
    'Ensure your pet has access to clean, fresh water at all times.',
    'Socialize your pet to help them feel comfortable in various environments.',
    'Provide mental stimulation through toys and activities.',
    'Keep your pet\'s living area clean and free from hazards.',
    'Train your pet using positive reinforcement techniques.',
    'Be aware of any signs of illness and seek veterinary care promptly.',
  ];

  final List<String> successStories = [
    'assets/quotes1.jpg',
    'assets/quotes2.jpeg',
    'assets/quotes3.jpeg',
    'assets/quotes4.jpg',
    'assets/quotes5.webp',
    'assets/quotes6.jpeg',
  ];

  final List<String> facts = [
    'Cats can rotate their ears 180 degrees.',
    'Dogs have three eyelids.',
    'A cat’s whiskers are generally about the same width as its body.',
    'Dogs\' sense of smell is at least 40x better than humans.',
    'Cats sleep for 70% of their lives.',
    'Dogs can understand up to 250 words and gestures.',
    'Cats have five toes on their front paws, but only four on the back ones.',
    'A group of kittens is called a kindle.',
    'Dogs\' noses are unique, much like human fingerprints.',
    'The average cat can jump up to five times its own height in a single leap.',
  ];

  final CarouselController _carouselController = CarouselController();

  void _syncCarousels(int index, CarouselPageChangedReason reason) {
    _carouselController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF6C953),
        title: Text(
          'Pawprints',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () {
              // Navigate to the profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xffF6C953), // Set the background color here
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdoptionPage()),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/adoption.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Adoption',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EcommercePage()),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/care.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Care',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpingHands()),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/helpinghands.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Helping Hands',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 100,
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 100,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: Duration(seconds: 5),
                  onPageChanged: _syncCarousels,
                ),
                items: tips.map((tip) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Color(0xffFFE1A8), // Complementary color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              tip,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 200,
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: Duration(seconds: 5),
                  onPageChanged: _syncCarousels,
                ),
                items: successStories.map((story) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Color(0xffFFE1A8), // Complementary color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          story,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Interesting Facts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 100,
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 100,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: Duration(seconds: 5),
                  onPageChanged: _syncCarousels,
                ),
                items: facts.map((fact) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Color(0xffAFE1AF), // Light green color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              fact,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: First(),
  ));
}
