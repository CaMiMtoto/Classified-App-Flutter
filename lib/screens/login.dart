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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
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
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
