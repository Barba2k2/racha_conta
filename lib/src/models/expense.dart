import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { comida, viagem, lazer, trabalho }

const categoryIcons = {
  Category.comida: Icons.lunch_dining,
  Category.viagem: Icons.flight_takeoff,
  Category.lazer: Icons.movie,
  Category.trabalho: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

//* Agrupara os dados de forma resumida
//* Agrupa os dados de mesma categoria
class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpanses, this.category)
      : expenses = allExpanses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      //* sum = sum + expense.amount
      //* mesma função, escrita de formas diferentes
      sum += expense.amount;
    }

    return sum;
  }
}
