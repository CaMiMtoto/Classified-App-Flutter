import 'dart:io';

import 'package:classifieds_app/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../models/category.dart';
import '../utils/common.dart';
import '../widgets/form_dropdown_group.dart';
import '../widgets/form_group.dart';
import 'package:http/http.dart' as http;

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _nameController = TextEditingController(text: "");
  final _descriptionController = TextEditingController(text: "");
  final _priceController = TextEditingController(text: "");
  final _manufacturingDateController = TextEditingController(text: "");

  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  List<CategoryModel> _categories = [];
  var _isLoading = false;

  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _isLoading = true;
    });
    fetchCategories().then((value) {
      setState(() {
        _categories = value;
        _isLoading = false;
      });
    });
  }

  void _saveProduct(context) async {
    var token = await getToken();
    Uri uri = Uri.parse('$baseUrl/products');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    // Add the image file to the request.
    request.files.add(await http.MultipartFile.fromPath('image', image!.path));
    request.fields["name"] = _nameController.text;
    request.fields["category"] = _selectedCategory!;
    request.fields["short_description"] = _descriptionController.text;
    request.fields["price"] = _priceController.text;
    request.fields["manufacturing_date"] = selectedDate.toString();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    request.headers.addAll(headers);

    setState(() {
      _isLoading = true;
    });
    // Show the loading dialog
    showLoadingDialog(context);
    setState(() {
      _isLoading = false;
    });
    final response = await request.send();
    Navigator.pop(context);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, response);
    } else {
      var message = "Unable save product, please try again";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('New Product'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Loading categories...'),
                ],
              ),
            )
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 32,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormGroup(
                            controller: _nameController,
                            label: "Name",
                            hintText: "Product name",
                            textInputType: TextInputType.text,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Product name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // dropdown categories
                          DropdownFormGroup(
                            label: "Category",
                            hintText: "Select Category",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category.id,
                                child: Text(
                                  category.name,
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              );
                            }).toList(),
                            defaultValue: _selectedCategory,
                            onChange: (newValue) {
                              print(newValue);
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          TextFormGroup(
                            controller: _priceController,
                            label: "Price",
                            hintText: "Product price",
                            textInputType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormGroup(
                            controller: _descriptionController,
                            label: "Description",
                            hintText: "Product description",
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.image),
                                      Text('From Gallery'),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                },
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        //to show image, you type like this.
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                        height: 100,
                                      ),
                                    )
                                  : const Text(
                                      "No Image",
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ],
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                padding:
                                    MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                              ),
                              onPressed: () => _selectDate(context),
                              child: Text(
                                selectedDate == null
                                    ? "Select Date"
                                    : formatDate(selectedDate!.toString()),
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _saveProduct(context);
                                      }
                                    },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor),
                                padding:
                                    MaterialStateProperty.all<EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              child: const Text("Save Changes"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ),
    );
  }
}