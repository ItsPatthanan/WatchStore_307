import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'detailspage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Detail-JP',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> products = [
    {
      "id": "product_1",
      "name": "Datejust 41",
      "branding": "Rolex",
      "details": "Bright blue, 41 mm.,Oystersteel",
      "price": "390600",
      "imageUrl":
          "https://www.srichaiwatch.com/wp-content/uploads/2023/04/m126334-0027_collection_upright_landscape.webp"
    },
    {
      "id": "product_2",
      "name": "ROYAL OAK",
      "branding": "AUDEMARS PIGUET",
      "details":
          "The Audemars Piguet Royal Oak Perpetual Calendar measures 41 mm in diameter and 9.5 mm thick. While it is slightly larger than its Ultra-Thin sister model, this timepiece is still very pleasant on the wrist. The manufacturer offers versions in platinum, gold, stainless steel, titanium, or ceramic.",
      "price": "1577000",
      "imageUrl":
          "https://www.colognewatch.de/cdn/shop/files/AudemarsPiguet-RoyalOak-15450ST.OO.1256ST.03-Colognewatch-01-8074.png?v=1709825147&width=3351"
    },
    {
      "id": "product_3",
      "name": "5712/1A - NAUTILUS",
      "branding": "Patek Philippe",
      "details":
          "Self-winding mechanical movement. Caliber 240 PS IRM C LU. Date by hand. Moon phases. Power reserve indication. Small seconds.",
      "price": "3549999",
      "imageUrl":
          "https://www.overwrist.com/wp-content/uploads/2024/01/Patek-Philippe-Nautilus-5712-1A-001.jpg"
    },
    {
      "id": "product_4",
      "name": "Overseas Chronograph 5500V/110A-B148",
      "branding": "Vacheron Constantin",
      "details":
          " this beautiful Vacheron Constantin Overseas Chronograph in Stainless Steel with a Blue Dial, reference 5500V/110A-B148.",
      "price": "1599999",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJPX5uav6VjJDw436QUJyx7fXG5qgq7nLfb_7cKNUHRg&s"
    },
  ];

  int? _hoverIndex;

  void _setHoverIndex(int index) {
    setState(() {
      _hoverIndex = index;
    });
  }

  void _clearHoverIndex() {
    setState(() {
      _hoverIndex = null;
    });
  }

  void _navigateToDetails(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
          product: products[index],
          onDelete: () => _deleteProduct(index),
          onModify: (newName, newDetails, newPrice, newBranding, newImageUrl) =>
              _modifyProduct(index, newName, newDetails, newPrice, newBranding,
                  newImageUrl),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products.where((product) {
      final String searchText = _searchController.text.toLowerCase();
      return product['name'].toLowerCase().contains(searchText) ||
          product['branding'].toLowerCase().contains(searchText);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watch detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.45,
              children: List.generate(
                filteredProducts.length,
                (index) => _buildProductCard(index, filteredProducts),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FadeInUp(
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController nameController = TextEditingController();
                TextEditingController imageUrlController =
                    TextEditingController();
                TextEditingController brandingController =
                    TextEditingController();
                TextEditingController detailsController =
                    TextEditingController();
                TextEditingController priceController = TextEditingController();

                return AlertDialog(
                  title: Text("Add Product"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        FadeInLeft(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: "Name"),
                          ),
                        ),
                        FadeInLeft(
                          child: TextField(
                            controller: imageUrlController,
                            decoration: InputDecoration(labelText: "Image URL"),
                          ),
                        ),
                        FadeInLeft(
                          child: TextField(
                            controller: brandingController,
                            decoration: InputDecoration(labelText: "Brand"),
                          ),
                        ),
                        FadeInLeft(
                          child: TextField(
                            controller: detailsController,
                            decoration: InputDecoration(labelText: "Details"),
                          ),
                        ),
                        FadeInLeft(
                          child: TextField(
                            controller: priceController,
                            decoration: InputDecoration(labelText: "Price"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        addNewProduct(
                          nameController.text,
                          imageUrlController.text,
                          detailsController.text,
                          priceController.text,
                          brandingController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add,
              color: Color.fromARGB(
                  255, 19, 18, 18)), // Set the icon color to white
        ),
      ),
    );
  }

  Widget _buildProductCard(
      int index, List<Map<String, dynamic>> filteredProducts) {
    final String imageUrl = products[index]['imageUrl']!;
    final String branding = products[index]['branding']!;

    return GestureDetector(
      onTap: () => _navigateToDetails(index),
      child: MouseRegion(
        onEnter: (_) => _setHoverIndex(index),
        onExit: (_) => _clearHoverIndex(),
        child: Card(
          color: _hoverIndex == index ? Colors.blue[100] : null,
          child: Column(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              SizedBox(height: 8),
              Text(
                products[index]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 8),
              Text(
                branding,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewProduct(String name, String imageUrl, String details, String price,
      String branding) {
    setState(() {
      products.add({
        "id": "product_${products.length + 1}",
        "imageUrl": imageUrl,
        "branding": branding,
        "name": name,
        "details": details,
        "price": price,
      });
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void _modifyProduct(int index, String newName, String newDetails,
      String newPrice, String newBranding, String newImageUrl) {
    setState(() {
      products[index]['name'] = newName;
      products[index]['details'] = newDetails;
      products[index]['price'] = newPrice;
      products[index]['branding'] = newBranding;
      products[index]['imageUrl'] = newImageUrl;
    });
  }
}
