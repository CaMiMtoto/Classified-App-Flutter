import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifieds_app/config.dart';
import 'package:classifieds_app/screens/new_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/product.dart';
import '../utils/common.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ProductDetailState createState() => _ProductDetailState(product);
}

class _ProductDetailState extends State<ProductDetail> {
  final Product product;

  _ProductDetailState(this.product);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // int len = bloc.cart.length;
    var properName =
        product.name.substring(0, 1).toUpperCase() + product.name.substring(1);

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                actions: <Widget>[],
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: "$imageUrl/${product.imageUrl}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.category.name,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            properName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "RWF ${product.price}",
                            style: const TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            formatDate(product.manufacturingDate),
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            product.shorDescription,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return NewProduct(product: product,);
                      },
                    ),
                  );
                },
                textColor: Theme.of(context).colorScheme.primary,
                color: Colors.blue.shade100,
                elevation: 0,
                child: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Edit"),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(Icons.share),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Share"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
