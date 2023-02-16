import 'package:classifieds_app/models/product.dart';
import 'package:classifieds_app/screens/home.dart';
import 'package:classifieds_app/screens/register.dart';
import 'package:classifieds_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_actions/quick_actions.dart';

import 'screens/categories.dart';
import 'screens/product_detail.dart';
import 'screens/products.dart';

void main() {
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
                product: settings.arguments as Product,
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
  String shortcut = 'no action set';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
