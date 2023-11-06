import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/colors.dart';
import 'package:racha_conta/src/features/authentication/models/user_model.dart';

import '../../controllers/theme_controller/theme_controller.dart';
import '../../models/expense_model.dart';
import '../controllers/user_controller.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({super.key, this.expenseModel});
  final ExpenseModel? expenseModel;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                widget.expenseModel!.title,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                categoryIcons[widget.expenseModel!.category],
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'R\$ ${widget.expenseModel!.amount.toString()}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.expenseModel!.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      //@ Detalhes

                      //# Editar
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
