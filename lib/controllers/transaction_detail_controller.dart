import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController {
  // row icons
  final icons = <IconData>[
    Icons.attach_money,   // Type
    Icons.access_time,    // Date
    Icons.credit_card,    // Payment Method
    Icons.currency_exchange, // Currency
    Icons.edit,           // Noted
  ];

  // row titles
  final names = <String>[
    "Type",
    "Date",
    "Payment Method",
    "Currency",
    "Noted",
  ];

  // row values (from your image)
  final values = <dynamic>[
    "Expense",
    "April 06, 2025 · 10:30 AM",
    "Cash",
    "\$",
    "Shoes",
  ];
}
