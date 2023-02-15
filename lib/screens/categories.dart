import 'dart:async';

import 'package:classifieds_app/models/category.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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
    // TODO: implement initState
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
            ? Center(
                child: CircularProgressIndicator(),
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
                                leading: CircleAvatar(
                                  backgroundColor:
                                      localTheme.colorScheme.primary,
                                  radius: 20,
                                  child: Text(category.name[0]),
                                ),
                                title: Text(category.name),
                                subtitle: Text(category.description.toString()),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            children: const [
              Icon(Icons.add),
              Text("Add Category"),
            ],
          ),
        ));
  }
}
