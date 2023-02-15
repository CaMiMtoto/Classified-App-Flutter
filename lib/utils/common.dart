import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Please wait...'),
            ],
          ),
        ),
      );
    },
  );
}

String formatMoney(String money) {
  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(double.parse(money));
}

String numberFormat(double money) {
  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(money);
}

String formatDate(String date) {
  final formatter = DateFormat("MMM dd, yyyy");
  return formatter.format(DateTime.parse(date));
}
