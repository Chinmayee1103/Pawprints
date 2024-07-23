import 'package:flutter/material.dart';
import 'First.dart';
import 'ProfilePage.dart';

class EcommercePage extends StatefulWidget {
  static const String id = 'ecommerce_page';

  @override
  _EcommercePageState createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  int _selectedIndex = 1;

  final List<Map<String, String>> _brands = [
    {'image': 'assets/brand1.jpeg', 'name': 'Brand 1'},
    {'image': 'assets/brand1.jpeg', 'name': 'Brand 2'},
    {'image': 'assets/brand1.jpeg', 'name': 'Brand 3'},
    {'image': 'assets/brand1.jpeg', 'name': 'Brand 4'},
    {'image': 'assets/brand1.jpeg', 'name': 'Brand 5'},
  ];

  final List<Map<String, String>> _products = [
    {
      'image': 'assets/product1.jpeg',
      'name': 'Product 1',
      'price': '\$25',
      'rating': '4.5'
    },
    {
      'image': 'assets/product2.jpg',
      'name': 'Product 2',
      'price': '\$30',
      'rating': '4.8'
    },
    {
      'image': 'assets/product3.jpeg',
      'name': 'Product 3',
      'price': '\$20',
      'rating': '4.3'
    },
    {
      'image': 'assets/product4.jpeg',
      'name': 'Product 4',
      'price': '\$15',
      'rating': '4.0'
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, First.id);
        break;
      case 3:
        Navigator.pushNamed(context, ProfilePage.id);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu action here
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pawsxs.png',
              width: 40,
              height: 39,
            ),
            SizedBox(width: 8),
            Text(
              'PAWPRINTS',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
        backgroundColor: Colors.white,
        toolbarHeight: 80,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF7CB59),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 250.0),
                    child: Text(
                      'Choose Brand',
                      style: TextStyle(
                        color: Color(0xff29261E),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _brands.length,
                    itemBuilder: (context, index) {
                      final brand = _brands[index];
                      return Container(
                        width: 150,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                brand['image']!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, size: 70);
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              brand['name']!,
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff29261E),
                  ),
                ),
                SizedBox(height: 15),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 5,
                            top: 1,
                            child: IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: Colors.red),
                              onPressed: () {
                                // Add functionality to handle heart icon click
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Image.asset(
                                    product['image']!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.yellow, size: 14),
                                    SizedBox(width: 5),
                                    Text(
                                      product['rating']!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['price']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed action here
        },
        backgroundColor: Color(0xffF7CB59),
        child: Icon(Icons.shopping_bag_rounded), // Updated icon
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
            ),
            SizedBox(width: 40), // Space for the FloatingActionButton
            Expanded(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
