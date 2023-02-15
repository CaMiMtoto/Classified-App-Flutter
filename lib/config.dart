import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// const String APP_URL = 'http://localhost:3000';
// const String APP_URL = 'http://192.168.162.112:3000';
// http://10.0.2.2:3000


String appUrl = "https://classified-app-api.herokuapp.com";
String baseUrl = '$appUrl/api';
String imageUrl = '$appUrl/images';

abstract class Functions {
  static String formatMoney(String money) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
    return oCcy.format(double.parse(money));
  }

  static String formatMN(double money) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
    return oCcy.format(money);
  }

  static void makeDialog(BuildContext context, String text) {
    showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(text),
                    )
                  ],
                )
              ],
            ),
          );
        },
        context: context);
  }
}
