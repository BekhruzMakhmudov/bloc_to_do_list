import 'package:flutter/material.dart';

enum Category {
  all,
  study,
  sport,
  work,
  shopping,
  payment,
  family,
  friend,
  entertainment,
  other,
}

extension CategoryExtension on Category {
  IconData get icon {
    switch (this) {
      case Category.all:
        return Icons.category;
      case Category.study:
        return Icons.book;
      case Category.sport:
        return Icons.fitness_center;
      case Category.work:
        return Icons.work;
      case Category.shopping:
        return Icons.shopping_cart;
      case Category.payment:
        return Icons.payment;
      case Category.family:
        return Icons.family_restroom;
      case Category.friend:
        return Icons.people;
      case Category.entertainment:
        return Icons.movie;
      case Category.other:
        return Icons.help;
    }
  }
}
