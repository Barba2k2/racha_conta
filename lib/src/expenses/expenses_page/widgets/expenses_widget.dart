import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../features/authentication/models/user_model.dart';
import '../../../models/expense_model.dart';
import '../../controllers/user_controller.dart';

class ExpenseWidget extends StatefulWidget {
  const ExpenseWidget(
    this._expenseModel, {
    this.userModel,
    super.key,
  });
  final ExpenseModel _expenseModel;
  final UserModel? userModel;

  @override
  State<ExpenseWidget> createState() => _ExepnseWidgetState();
}

class _ExepnseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    final UserController userController = Get.find();

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark ? tDarkCard : white70,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget._expenseModel.title!,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Gap(6),
                        Text(
                          widget._expenseModel.description!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          // Evita que o texto transborde
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 28,
                              decoration: BoxDecoration(
                                color: tPrimaryColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget._expenseModel.formattedDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
