import 'dart:async';

import 'package:classifieds_app/models/product.dart';
import 'package:classifieds_app/screens/home.dart';
import 'package:classifieds_app/screens/register.dart';
import 'package:classifieds_app/screens/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_links/uni_links.dart';

import 'screens/categories.dart';
import 'screens/product_detail.dart';
import 'screens/products.dart';
import 'utils/deeplinks.dart';

bool _initialURILinkHandled = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appTitle = 'Classifieds App';
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const Home());
          case '/register':
            return MaterialPageRoute(builder: (context) => const Register());
          case '/categories':
            return MaterialPageRoute(builder: (context) => const Categories());
          case '/products':
            return MaterialPageRoute(builder: (context) => const Products());
          case '/settings':
            return MaterialPageRoute(builder: (context) => const Settings());
          case '/product-detail':
            return MaterialPageRoute(
              builder: (context) => ProductDetail(
                productId: settings.arguments as String,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const Home(),
            );
        }
      },
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF08509E),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFFF19F1D),
            primary: const Color(0xFF08509E)),
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        textTheme: GoogleFonts.ubuntuTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uri? _initialURI;
/*
  Uri? _currentURI;
  Object? _err;
*/

  StreamSubscription? _streamSubscription;

  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
   /*     setState(() {
          _currentURI = uri;
          _err = null;
        });*/
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
     /*   setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });*/
      });
    }
  }

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
     /*   setState(() => _err = err);*/
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialURI != null) {
      handleDeepLink(_initialURI.toString(), context);
    }
    return const Home();
  }
}
