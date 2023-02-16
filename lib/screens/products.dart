import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifieds_app/config.dart';
import 'package:classifieds_app/models/user.dart';
import 'package:classifieds_app/screens/new_product.dart';
import 'package:classifieds_app/screens/product_detail.dart';
import 'package:classifieds_app/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/product.dart';
import '../utils/common.dart';

import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Product> _products = [];
  var _isLoading = false;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getProducts();
    _getUser();
  }

  _getUser() {
    getCurrentUser()!.then((value) {
      setState(() {
        _currentUser = value;
      });
    });
  }

  _getProducts() {
    _handleRefresh();
  }

  Future<void> _handleRefresh() {
    setState(() {
      _isLoading = true;
    });

    _refreshIndicatorKey.currentState?.show();
    final Completer<void> completer = Completer<void>();

    fetchProducts(null).then((value) {
      setState(() {
        _products = value;
        completer.complete();
        _isLoading = false;
      });
    });

    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    var localTheme = Theme.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        key: _refreshIndicatorKey,
        child: Scaffold(
          key: _scaffoldKey,
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : !_isLoading && _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.boxOpen,
                            size: 100,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Oops! No products found yet.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade200,
                                  Colors.grey.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello !',
                                      style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _currentUser != null
                                          ? _currentUser!.name
                                          : '',
                                      style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const CircleAvatar(
                                  child: Icon(Icons.person_2_outlined),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              left: 16,
                              right: 16,
                            ),
                            child: Expanded(
                                child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 480
                                        ? 4
                                        : 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.6,
                              ),
                              shrinkWrap: true,
                              itemCount: _products.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0.1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                            product: _products[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "$imageUrl/${_products[index].imageUrl}",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Wrap(
                                            runSpacing: 4,
                                            children: [
                                              Text(
                                                _products[index].name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                "RF ${numberFormat(_products[index].price)}",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                formatDate(_products[index]
                                                    .manufacturingDate),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                    onLongPress: () {
                                      confirmDeletion(
                                          context, _products[index].id);
                                    },
                                  ),
                                );
                              },
                            )),
                          ),
                        ],
                      ),
                  ),
        ),
      ),
    );
  }

  void confirmDeletion(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var url = "$baseUrl/products/$id";
                var token = await getToken();
                var response = await http.delete(Uri.parse(url), headers: {
                  HttpHeaders.authorizationHeader: "bearer $token"
                });

                if (response.statusCode == 200) {
                  setState(() {
                    _products =
                        _products.where((element) => element.id != id).toList();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Unable to delete product"),
                  ));
                }

                Navigator.of(context).pop();
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
}
