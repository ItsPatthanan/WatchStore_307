import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

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
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          product: products[index],
          onDelete: () => _deleteProduct(index),
          onModify: (newName, newDetails, newPrice, newBranding, newImageUrl) =>
              _modifyProduct(index, newName, newDetails, newPrice, newBranding,
                  newImageUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watch Store',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.45,
        children: List.generate(
          products.length,
          (index) => _buildProductCard(index),
        ),
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

  Widget _buildProductCard(int index) {
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

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function onDelete;
  final Function(String, String, String, String, String) onModify;

  const DetailsScreen({
    Key? key,
    required this.product,
    required this.onDelete,
    required this.onModify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController imageUrlController =
        TextEditingController(text: product['imageUrl']);
    TextEditingController detailsController =
        TextEditingController(text: product['details']);
    TextEditingController priceController =
        TextEditingController(text: product['price']);
    TextEditingController brandingController =
        TextEditingController(text: product['branding']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DETAILS',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 111, 157, 243),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(153, 38, 229, 243),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), 
                  ],
                ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: product['imageUrl'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  product['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product['name'] != null)
                                Text(
                                  'Name: ${product['name']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              SizedBox(height: 10),
                              if (product['branding'] != null)
                                Text(
                                  'Brand: ${product['branding']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              SizedBox(height: 10),
                              if (product['details'] != null)
                                Text(
                                  'Details: ${product['details']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              SizedBox(height: 10),
                              if (product['price'] != null)
                                Text(
                                  'Price: ${product['price']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.indigo, // Button color
                        child: FadeInUp(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Modify Product"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FadeInLeft(
                                          child: TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                                labelText: "Name"),
                                          ),
                                        ),
                                        FadeInLeft(
                                          child: TextField(
                                            controller: brandingController,
                                            decoration: InputDecoration(
                                                labelText: "Brand"),
                                          ),
                                        ),
                                        FadeInLeft(
                                          child: TextField(
                                            controller: detailsController,
                                            decoration: InputDecoration(
                                                labelText: "Details"),
                                          ),
                                        ),
                                        FadeInLeft(
                                          child: TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                                labelText: "Price"),
                                          ),
                                        ),
                                        FadeInLeft(
                                          child: TextField(
                                            controller: imageUrlController,
                                            decoration: InputDecoration(
                                                labelText: "Image URL"),
                                          ),
                                        ),
                                      ],
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
                                          onModify(
                                            nameController.text,
                                            detailsController.text,
                                            priceController.text,
                                            brandingController.text,
                                            imageUrlController.text,
                                          );
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('Product updated successfully')),
                                          );
                                        },
                                        child: Text("Save"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20), // Add some spacing between buttons
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: FadeInUp(
                          // Button color
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Product"),
                                    content: Text(
                                        "Are you sure you want to delete ${product['name']}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          onDelete();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Product deleted successfully')),
                                          );
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
