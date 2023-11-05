import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titulo
              Text(
                expense.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(4),
              Row(
                children: [
                  // Valor
                  Text('R\$ ${expense.amount.toStringAsFixed(2)}'),
                  const Spacer(),
                  // Item da categoria + Data
                  Row(
                    children: [
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(width: 8),
                      Text(expense.formattedDate),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
