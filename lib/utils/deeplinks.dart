import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

// This function handles the deep link.
Future<void> handleDeepLink(String link, context) async {
  // Do something with the link.
  // In this example, we extract the product ID from the link and open the product details page.
  final productId = link.substring(link.lastIndexOf('/') + 1);
  Navigator.of(context).pushNamed('/product-detail', arguments: productId);
}

// This function sets up the deep link handling.
Future<void> initUniLinks(BuildContext context) async {
  try {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(initialLink, context);
    }
    uriLinkStream.listen((uri) {
      handleDeepLink(uri.toString(), context);
    });
  } on PlatformException {
    // Handle exceptions here.
  }
}
