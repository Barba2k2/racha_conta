import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../models/expense_model.dart';
import '../widgets/expense_card.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.expenseWidget,
  });

  final List<ExpenseModel> expenses;
  final void Function(ExpenseModel expense) onRemoveExpense;
  final Widget expenseWidget;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(expenses[index]),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: isDark ? tDarkCard : tLightCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text(
                        'Confirmação',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        'Tem certeza que deseja apagar esta despesa?',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 40,
                                ),
                              ),
                              child: const Text(
                                'Não',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 40,
                                ),
                              ),
                              child: const Text(
                                'Sim',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                onRemoveExpense(expenses[index]);
              },
              child: ExpenseCard(expenses[index]),
            ),
          ),
        ),
        expenseWidget,
      ],
    );
  }
}
