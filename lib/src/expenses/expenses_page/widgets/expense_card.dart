import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
// import '../../controllers/theme_controller/theme_controller.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../features/authentication/models/user_model.dart';
import '../../../models/expense_model.dart';
import '../../controllers/user_controller.dart';
import '../../expense_details/expense_details.dart';

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
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        // final user = snapshot.data;

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
                              Text(
                                '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: isDark ? white90 : blackColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Text(
                                  widget.expenseModel.formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        color: isDark ? white90 : blackColor,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                        Expanded(
                          child: Text(
                            'R\$ ${widget.expenseModel.ammount.toString()}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: isDark ? white90 : blackColor,
                                    ),
                          ),
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
                      //@ Detalhes
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const ExpenseDatails());
                          },
                          child: Text(
                            'Detalhes',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                      //# Editar
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Editar',
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
