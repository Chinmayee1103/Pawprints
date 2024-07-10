import 'package:flutter/material.dart';

class ProdProducts {
  String productImage;
  String name;
  String brand;
  double price;
  String desc;

  ProdProducts({
    required this.productImage,
    required this.name,
    required this.brand,
    required this.price,
    required this.desc,
  });
}

class CarePage extends StatefulWidget {
  @override
  _CarePageState createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {
  List<ProdProducts> allProducts = [
    ProdProducts(
      productImage: 'assets/dog1.jpg',
      name: 'Dog Product 1',
      brand: 'Brand A',
      price: 10.0,
      desc: 'Description of Dog Product 1',
    ),
    ProdProducts(
      productImage: 'assets/dog2.jpg',
      name: 'Dog Product 2',
      brand: 'Brand B',
      price: 20.0,
      desc: 'Description of Dog Product 2',
    ),
    ProdProducts(
      productImage: 'assets/cat1.jpg',
      name: 'Cat Product 1',
      brand: 'Brand C',
      price: 15.0,
      desc: 'Description of Cat Product 1',
    ),
    ProdProducts(
      productImage: 'assets/cat2.jpg',
      name: 'Cat Product 2',
      brand: 'Brand D',
      price: 25.0,
      desc: 'Description of Cat Product 2',
    ),
  ];

  List<ProdProducts> displayedProducts = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    displayedProducts = allProducts;
  }

  List<ProdProducts> getCategoryProducts(String category) {
    return allProducts
        .where((product) =>
            product.name.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pet Care Products'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Dog'),
              Tab(text: 'Cat'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    displayedProducts = allProducts.where((product) {
                      return product.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildGridView(getCategoryProducts('Dog')),
                  buildGridView(getCategoryProducts('Cat')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView(List<ProdProducts> products) {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildCareProductItem(context, products[index]);
      },
    );
  }

  Widget _buildCareProductItem(BuildContext context, ProdProducts product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(product.productImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${product.price}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final ProdProducts product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(product.productImage),
            SizedBox(height: 16.0),
            Text(
              product.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20.0, color: Colors.green),
            ),
            SizedBox(height: 16.0),
            Text(
              product.desc,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CarePage(),
  ));
}
