import 'package:classifieds_app/models/user.dart';
import 'package:classifieds_app/utils/auth.dart';
import 'package:classifieds_app/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'about.dart';
import 'categories.dart';
import 'home.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    getCurrentUser()?.then((value) {
      setState(() {
        _currentUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var localTheme = Theme.of(context).colorScheme;
    var primaryColor = localTheme.primary;
    return Scaffold(
     backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(color: primaryColor),
              child: Center(
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // create a ListTile with an avatar of logged in user , username and email ,and logout button
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: localTheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getUserInitials(),
                            ),
                          ),
                        ),
                        title: Text(_currentUser != null ? _currentUser!.name : ''),
                        subtitle: Text(_currentUser != null ? _currentUser!.email : ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            showLoadingDialog(context);
                            logout().then(
                              (value) {
                                return Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 32,
                        child: Text(
                          "General",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.moon,
                          color: primaryColor,
                        ),
                        title: const Text('Dark Mode'),
                        subtitle: const Text(
                          'Coming soon, stay tuned!',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Switch(
                          value: false,
                          onChanged: (bool value) {
                            // TODO implement dark mode toggle
                          },
                        ),
                      ),

                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Categories()));
                        },
                        leading: FaIcon(
                          FontAwesomeIcons.chartPie,
                          color: primaryColor,
                        ),
                        title: const Text('Categories'),
                        subtitle: const Text(
                          'Manage product categories',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      const Divider(),
                      SizedBox(
                        height: 32,
                        child: Text(
                          "Other settings",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
/*
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.lock,
                          color: primaryColor,
                        ),
                        title: const Text('Security'),
                        subtitle: const Text(
                          'Protect your account with fingerprint',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),*/

                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.shieldHalved,
                          color: primaryColor,
                        ),
                        title: const Text('Password'),
                        subtitle: const Text(
                          'Change your password,This feature is coming soon',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: primaryColor,
                        ),
                        title: const Text('About'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const About()));
                        },
                        subtitle: const Text(
                          'Learn more about us',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserInitials() {
    return (_currentUser != null ? _currentUser!.name : 'Seller')
        .substring(0, 2)
        .toUpperCase();
  }
}
