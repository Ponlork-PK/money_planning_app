import 'package:flutter/material.dart';

enum TxType { income, expense }

class CategoryModel {
  final String id;
  final String name;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });
}

class TxModel {
  final String id;
  final String title;
  final double amount;
  final TxType type;
  final String categoryId;
  final DateTime date;

  const TxModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
  });
}
