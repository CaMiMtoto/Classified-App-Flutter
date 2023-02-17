import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifieds_app/config.dart';
import 'package:classifieds_app/models/user.dart';
import 'package:classifieds_app/screens/product_detail.dart';
import 'package:classifieds_app/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product.dart';
import '../utils/common.dart';

import 'package:http/http.dart' as http;

import '../widgets/not_found.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>(
    debugLabel: "RefreshIndicator",
  );

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          _isLoading ? Colors.white : localTheme.colorScheme.primary,
      appBar: AppBar(
        title: const Text("Classifieds App"),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        key: _refreshIndicatorKey,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : !_isLoading && _products.isEmpty
                ? const NotFoundWidget(
                    text: "Oops! No products found yet.",
                    textColor: Colors.white)
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        buildWelcomeView(localTheme),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                            minWidth: MediaQuery.of(context).size.width,
                            maxHeight: double.infinity,
                            maxWidth: double.infinity,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: buildProductsGridView(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Container buildWelcomeView(ThemeData localTheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32, top: 32),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello !',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _currentUser != null ? _currentUser!.name : '',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
            child: CircleAvatar(
              child: Icon(Icons.person_2_outlined,
                  color: localTheme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  GridView buildProductsGridView(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 768 ? 3 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      shrinkWrap: true,
      itemCount: _products.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var cardRadius = 10.0;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius)),
          elevation: 0.4,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(
                    productId: _products[index].id,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cardRadius),
                      topRight: Radius.circular(cardRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "$imageUrl/${_products[index].imageUrl}",
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        formatDate(_products[index].manufacturingDate),
                        style: const TextStyle(color: Colors.grey),
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
              confirmDeletion(context, _products[index].id);
            },
          ),
        );
      },
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
              onPressed: () {
                _deleteProduct(id, context);
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

  void _deleteProduct(String id, BuildContext context) async {
    var url = "$baseUrl/products/$id";
    var token = await getToken();
    var response = await http.delete(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    Navigator.of(context).pop();
    showLoadingDialog(context);

    if (response.statusCode == 200) {
      setState(() {
        _products = _products.where((element) => element.id != id).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unable to delete product"),
      ));
    }

    Navigator.of(context).pop();
  }
}
