import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'detailspage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> products = [
    {
      "id": "product_1",
      "name": "Datejust 41",
      "branding": "Rolex",
      "details": "Bright blue, 41 mm.,Oystersteel",
      "price": "390600",
      "imageUrl":
          "https://cdn.shopify.com/s/files/1/2044/1529/products/Rolex_Datejust41_Diamond_Blue_Dial_UK6_1800x1800.jpg?v=1609614954"
    },
    {
      "id": "product_2",
      "name": "CONSTELLATION",
      "branding": "Omega",
      "details": "Omega Globemaster,39 mm Blue Dial 2017",
      "price": "262000",
      "imageUrl":
          "https://tse2.mm.bing.net/th?id=OIP.qxHHUGphZB0gRVWXflWu7QHaHa&pid=Api&P=0&h=180"},
  ];
final TextEditingController _searchController = TextEditingController();
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
            _modifyProduct(index, newName, newDetails, newPrice, newBranding, newImageUrl),
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
          'Watch Store',
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
              color: Color.fromARGB(255, 19, 18, 18)), // Set the icon color to white
        ),
      ),
    );
  }

  Widget _buildProductCard(int index, List<Map<String, dynamic>> filteredProducts) {
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
