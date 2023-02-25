import 'dart:async';
import 'dart:io';

import 'package:classifieds_app/models/category.dart';
import 'package:classifieds_app/utils/common.dart';
import 'package:classifieds_app/widgets/form_group.dart';
import 'package:classifieds_app/widgets/not_found.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../utils/auth.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<CategoryModel> _categories = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  getCategories() {
    setState(() {
      _isLoading = true;
    });

    fetchCategories().then((response) {
      setState(() {
        _categories = response;
        _isLoading = false;
      });
    }).catchError((error) {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleRefresh() {
    _refreshIndicatorKey.currentState?.show();
    final Completer<void> completer = Completer<void>();

    fetchCategories().then((value) {
      setState(() {
        _categories = value;
        completer.complete();
      });
    });

    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    var localTheme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Categories"),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : !_isLoading && _categories.isEmpty
                ? NotFoundWidget(
                    text: 'Oops! No categories found',
                    textColor: Colors.grey.shade900,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      key: _refreshIndicatorKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                var category = _categories[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    onLongPress: () {
                                      showDeletionConfirmationDialog(
                                          context, category);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          localTheme.colorScheme.primary,
                                      radius: 20,
                                      child: Text(category.name[0]),
                                    ),
                                    title: Text(category.name),
                                    subtitle:
                                        Text(category.description.toString()),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                useSafeArea: true,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Category",
                                  style: localTheme.textTheme.titleLarge),
                              const SizedBox(height: 16),
                              TextFormGroup(
                                controller: _nameController,
                                label: "Name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a name";
                                  }
                                  return null;
                                },
                                hintText: 'Enter a name',
                              ),
                              const SizedBox(height: 16),
                              TextFormGroup(
                                controller: _descriptionController,
                                label: "Description",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a description";
                                  }
                                  return null;
                                },
                                hintText: 'Enter a description',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pop(context);
                                      showLoadingDialog(context);
                                      _saveCategory(context).then((value) {
                                        Navigator.pop(context);
                                        getCategories();
                                      });
                                    }
                                  },
                                  child: const Text("Save Changes"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          child: const Icon(Icons.add),
        ));
  }

  void showDeletionConfirmationDialog(
      BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text("Are you sure you want to delete this category?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // showLoadingDialog(context);
                deleteCategory(category.id).then((value) {
                  if (value.statusCode == 204 || value.statusCode == 200) {
                    getCategories();
                  }
                  Navigator.pop(context);
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCategory(BuildContext context) async {
    var token = await getToken();

    var name = _nameController.text;
    var description = _descriptionController.text;
    var uri = Uri.parse("$baseUrl/categories");

    http.post(uri, body: {
      "name": name,
      "description": description
    }, headers: {
      HttpHeaders.authorizationHeader: "bearer $token",
    }).then((response) {
      if (response.statusCode == 201) {
        resetForm();
        getCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error adding category"),
          ),
        );
      }
    });
  }

  void resetForm() {
    _nameController.clear();
    _descriptionController.clear();
  }

  Future<http.Response> deleteCategory(String id) async {
    var uri = Uri.parse("$baseUrl/categories/$id");
    var token = await getToken();

    var response = await http.delete(uri,
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});
    return response;
  }
}
