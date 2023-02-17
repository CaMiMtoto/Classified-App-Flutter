import 'package:cached_network_image/cached_network_image.dart';
import 'package:classifieds_app/config.dart';
import 'package:classifieds_app/screens/new_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product.dart';
import '../utils/common.dart';
import '../utils/deeplinks.dart';
import '../widgets/not_found.dart';

class ProductDetail extends StatefulWidget {
  final String productId;

  const ProductDetail({Key? key, required this.productId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ProductDetailState createState() => _ProductDetailState(productId);
}

class _ProductDetailState extends State<ProductDetail> {
  final String productId;
  Product? product;
  bool isLoading = true;

  _ProductDetailState(this.productId);

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  _getProduct() {
    setState(() {
      isLoading = true;
    });
    fetchSingleProduct(productId)
        .then((value) => setState(() {
              product = value;
              isLoading = false;
            }))
        .catchError((error) {
      setState(() {
        isLoading = false;

        // show error message in snack bar with retry button to fetch product again without context

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Error fetching product details"),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                _getProduct();
              },
            ),
          ),
        );
      });
    });
  }

  void shareProductDetails(String productName, String productUrl) {
    String message = 'Check out this product: $productName\n\n$productUrl';
    Share.share(message, subject: 'Product Details');
  }

  @override
  Widget build(BuildContext context) {
    var properName = product?.name;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : !isLoading && product == null
                ? NotFoundWidget(
                    text: "Product not found",
                    textColor: Colors.grey.shade900,
                  )
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250.0,
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewProduct(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _getProduct,
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () async {
                                final productId = product!.id;
                                final link =
                                    'https://classified.cami.ink/products/$productId';
                                Share.share('Check out this product: $link',
                                    subject: 'Product Details');
                              },
                            ),
                            // add refresh button to refresh product details
                          ],
                          floating: true,
                          pinned: true,
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
                              imageUrl: "$imageUrl/${product!.imageUrl}",
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
                                      product!.category.name,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      properName!,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "RWF ${numberFormat(product!.price)}",
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      formatDate(product!.manufacturingDate),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      product!.shorDescription,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black54),
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
      ),
    );
  }
}
