import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_adoption/ProfilePage.dart';
import 'package:pet_adoption/Shop/DogFood.dart';
import 'package:pet_adoption/Shop/DogToys.dart';
import 'package:pet_adoption/Shop/DogHealth.dart';
import 'package:pet_adoption/Shop/DogAccess.dart';

class DogShoppingPage extends StatefulWidget {
  static const String id = 'dog_shopping_page';

  @override
  _DogShoppingPageState createState() => _DogShoppingPageState();
}

class _DogShoppingPageState extends State<DogShoppingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _positionAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _positionAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToShopNow() {
    Navigator.pushNamed(context, 'shop_now_page'); // Navigate to ShopNowPage
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/');
          break;
        case 1:
          // Handle Favorites navigation
          break;
        case 2:
          Navigator.pushNamed(context, ProfilePage.id);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation.value),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Text(
                  'Pawsome Picks!',
                  style: GoogleFonts.pacifico(
                    fontSize: 24.0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/dog_background.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'SAVE',
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '50%',
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'OFFER',
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: (MediaQuery.of(context).size.width - 100) / 2,
                    child: GestureDetector(
                      onTap: _navigateToShopNow,
                      child: Container(
                        width: 100,
                        height: 43,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: Text(
                            'Shop Now',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: MediaQuery.of(context).size.height - 480,
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  _buildCategoryContainer('Food', 'assets/dogfood2.jpeg'),
                  _buildCategoryContainer('Toys', 'assets/dogtoy.jpg'),
                  _buildCategoryContainer('Health', 'assets/doghealth.jpg'),
                  _buildCategoryContainer(
                      'Accessories', 'assets/dogaccess.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, -3),
              blurRadius: 5,
            ),
          ],
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 2,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0)), // Rounded top corners
          child: BottomAppBar(
            height: 63,
            color: Colors.white,
            child: Container(
              height: 60, // Adjust height of BottomNavigationBar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 24.0, // Adjust icon size
                    ),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      size: 24.0, // Adjust icon size
                    ),
                    onPressed: () {
                      _onItemTapped(1);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      size: 24.0, // Adjust icon size
                    ),
                    onPressed: () {
                      _onItemTapped(2);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      size: 24.0, // Adjust icon size
                    ),
                    onPressed: () {
                      _onItemTapped(3);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContainer(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Food':
            Navigator.pushNamed(context, 'dog_food_page');
            break;
          case 'Toys':
            Navigator.pushNamed(context, 'dog_toys_page');
            break;
          case 'Health':
            Navigator.pushNamed(context, 'dog_health_page');
            break;
          case 'Accessories':
            Navigator.pushNamed(context, 'dog_access_page');
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Adjust padding as needed
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  color: Colors.white70,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
