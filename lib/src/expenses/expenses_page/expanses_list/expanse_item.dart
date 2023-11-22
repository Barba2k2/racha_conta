import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/expense_model.dart';


class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final ExpenseModel expense;

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
              Row(
                children: [
                  Text(
                    expense.title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 8),
                  Icon(categoryIcons[expense.category]),
                ],
              ),
              const Gap(4),
              Row(
                children: [
                  // Valor
                  Text('R\$ ${expense.amount!.toStringAsFixed(2)}'),
                  const Spacer(),
                  // Item da categoria + Data
                  Text(expense.formattedDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
