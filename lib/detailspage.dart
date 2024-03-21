import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

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