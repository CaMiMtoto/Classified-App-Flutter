import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifieds_app/config.dart';
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

  @override
  void initState() {
    super.initState();
    _getProducts();
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isLoading && _products.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  const [
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
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  key: _refreshIndicatorKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "All Products",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
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
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "$imageUrl/${_products[index].imageUrl}",
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: double.infinity,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  _products[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                onLongPress: () {
                                  confirmDeletion(context, _products[index].id);
                                },
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      formatDate(
                                          _products[index].manufacturingDate),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "RWF ${numberFormat(_products[index].price)}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewProduct()));
            if (result != null) {
              _getProducts();
            }
          },
          child: const FaIcon(
            FontAwesomeIcons.plus,
            size: 16,
          )),
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
