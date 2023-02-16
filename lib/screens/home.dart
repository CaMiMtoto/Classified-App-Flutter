import 'package:classifieds_app/screens/dashboard.dart';
import 'package:classifieds_app/screens/login.dart';
import 'package:classifieds_app/screens/new_product.dart';
import 'package:classifieds_app/screens/products.dart';
import 'package:classifieds_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _selectedIndex = 0;

  var _isLoading = true;
  var _token;

  final _screens = [
    const Products(),
    const NewProduct(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    _initLoading();
  }

  Future<void> _initLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = false;
      _token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _token == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_isLoading == false && _token == null) {
      return const Login();
    }

    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.plus),
              label: 'Add Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,

          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
