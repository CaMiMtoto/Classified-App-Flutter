import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../utils/auth.dart';
import '../utils/common.dart';
import '../widgets/form_group.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _login(context) async {
    setState(() {
      _isLoading = true;
    });

    // Show the loading dialog
    showLoadingDialog(context);

    var response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // get token and save to shared preferences and navigate to home screen
      var body = response.body;
      // decode json
      var data = json.decode(body);
      // get token
      var token = data['token'];
      // login user
      login(token).then((value) {
        showLoadingDialog(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
    } else {
      var message = "Invalid email or password";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(color: primaryColor),
              child: SafeArea(
                child: Center(
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Welcome back !",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(
                        height: 8,
                      ),
                      Text("please login to your account",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(
                        height: 32,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormGroup(
                              controller: _emailController,
                              label: "Email",
                              hintText: "example@domain.com",
                              textInputType: TextInputType.emailAddress,
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormGroup(
                              obscureText: true,
                              controller: _passwordController,
                              label: "Password",
                              hintText: "Password",
                              textInputType: TextInputType.emailAddress,
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _login(context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account ?",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, '/register');
                                        },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
