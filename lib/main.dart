import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> products = [];

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
          onModify: (
            newName,
            newDetails,
            newPrice,
            newBranding,
          ) =>
              //อย่าลืมใส่ใน 2 วงเล็บnewimageUrl
              _modifyProduct(index, newName, newDetails, newPrice, newBranding),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.7,
        children: List.generate(
          products.length,
          (index) => _buildProductCard(index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              TextEditingController imageUrlController =
                  TextEditingController();
              TextEditingController brandingController =
                  TextEditingController();
              TextEditingController detailsController = TextEditingController();
              TextEditingController priceController = TextEditingController();

              return AlertDialog(
                title: Text("Add Product"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      TextField(
                        controller: imageUrlController,
                        decoration: InputDecoration(labelText: "Image URL"),
                      ),
                      TextField(
                        controller: brandingController,
                        decoration: InputDecoration(labelText: "branding"),
                      ),
                      TextField(
                        controller: detailsController,
                        decoration: InputDecoration(labelText: "Details"),
                      ),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: "Price"),
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
        child: Icon(Icons.add),
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
      String newPrice, String newBranding) {
    //อย่าลืมใส่ในวงเล็บ,String newimageUrl
    setState(() {
      products[index]['name'] = newName;
      products[index]['details'] = newDetails;
      products[index]['price'] = newPrice;
      products[index]['branding'] = newBranding;
      // products[index]['imageUrl'] = newimageUrl;
    });
  }
}

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function onDelete;
  final Function(
    String,
    String,
    String,
    String,
  ) onModify;
//อย่าลืมเติมก่อนรับขอสิทธิ์รับรูป String
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
    // TextEditingController imageUrlController = TextEditingController(text: product['imageUrl']);
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
        actions: [
          IconButton(
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
                        },
                        child: Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Modify Product"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "Name"),
                        ),
                        TextField(
                          controller: brandingController,
                          decoration: InputDecoration(labelText: "Brand"),
                        ),
                        TextField(
                          controller: detailsController,
                          decoration: InputDecoration(labelText: "Details"),
                        ),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(labelText: "Price"),
                        ),
                        // TextField(
                        //   controller: imageUrlController,
                        //  decoration: InputDecoration(labelText: "ImageUrl"),
                        // ),
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
                            // imageUrlController.text,
                            detailsController.text,
                            priceController.text,
                            brandingController.text,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
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
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFff5722),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 900,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
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
                                  'Branding: ${product['branding']}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
