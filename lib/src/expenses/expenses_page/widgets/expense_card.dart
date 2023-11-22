import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/expenses/expenses_page/widgets/expenses_edit.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../features/authentication/models/user_model.dart';
import '../../models/expense_model.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/user_controller.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard(
    this.expenseModel, {
    super.key,
  });
  final ExpenseModel expenseModel;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  final ExpenseController expenseController = Get.find();

  Future<void> _confirmDeleteExpense(String expenseId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Deseja deletar esse dado?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Text(
            'Você tem mesmo certeza que deseja apagar?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancelar',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                expenseController.deleteExpense(expenseId);
                log('Deleting expense');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Apagar',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: whiteColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark ? expenseColorDarkBg : expenseColorLightBg,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                categoryIcons[widget.expenseModel.category],
                                size: 24,
                                color: isDark ? white90 : blackColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.expenseModel.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: isDark ? white90 : blackColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'R\$ ${widget.expenseModel.amount.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: isDark ? white90 : blackColor,
                                  ),
                            ),
                            Text(
                              ' - ${widget.expenseModel.formattedDate}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: isDark ? white90 : blackColor,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            widget.expenseModel.description!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: isDark ? white90 : blackColor,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //# Editar
                      SizedBox(
                        width: 135,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            final expenseId = widget.expenseModel.expenseId;
                            if (expenseId != null) {
                              Get.to(
                                () => EditExpenseScreen(expenseId: expenseId),
                              );
                            } else {
                              log('Erro ao recuperar o Id da despesa');
                            }
                          },
                          child: Text(
                            'Editar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                      //@ Apagar
                      SizedBox(
                        width: 135,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            final expenseId = widget.expenseModel.expenseId;
                            if (expenseId != null) {
                              _confirmDeleteExpense(expenseId);
                            } else {
                              // Lidar com o cenário em que o ID é nulo, se necessário
                            }
                            log('Apagando despesa');
                          },
                          child: Text(
                            'Apagar',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
