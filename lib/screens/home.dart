import 'package:classifieds_app/screens/dashboard.dart';
import 'package:classifieds_app/screens/login.dart';
import 'package:classifieds_app/screens/products.dart';
import 'package:classifieds_app/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth.dart';
import '../utils/common.dart';

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
    const Dashboard(),
    const Products(),
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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF08509E),
              const Color(0xFF08509E).withOpacity(1),
            ],
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconBottomBar(
                    icon: FontAwesomeIcons.house,
                    label: 'Home',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    selected: _selectedIndex == 0,
                  ),
                  IconBottomBar(
                    icon: FontAwesomeIcons.basketShopping,
                    label: 'Products',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    selected: _selectedIndex == 1,
                  ),
                  IconBottomBar(
                    icon: FontAwesomeIcons.gear,
                    label: 'Settings',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    selected: _selectedIndex == 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final Null Function() onTap;
  final bool selected;

  const IconBottomBar(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onTap,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var iconColor =
        selected ? Theme.of(context).colorScheme.secondary : Colors.white;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onTap,
          icon: FaIcon(icon),
          iconSize: 25,
          color: iconColor,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            height: .5,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
