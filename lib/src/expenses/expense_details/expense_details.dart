import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/theme_controller/theme_controller.dart';
import '../../models/expense_model.dart';
import '../controllers/expense_controller.dart';

class ExpenseDatails extends StatefulWidget {
  const ExpenseDatails({super.key, this.expenseModel});
  final ExpenseModel? expenseModel;

  @override
  State<ExpenseDatails> createState() => _ExpenseDatailsState();
}

class _ExpenseDatailsState extends State<ExpenseDatails> {
  final ExpenseController expenseController = Get.find();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalhes do Rolê",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: isDark ? tDarkColor : whiteColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Titulo/Nome do rolê:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      // widget.expenseModel!.title, // Reomver o ? do expense model
                      'Prainha',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Valor do rolê:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      // widget.expenseModel!.ammount.toString(), // Reomver o ? do expense model
                      'R\$ 250,00',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Data do rolê:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      // widget.expenseModel!.title, // Reomver o ? do expense model
                      '08/11/2023',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Categoria:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      // widget.expenseModel!.title, // Reomver o ? do expense model
                      'Lazer',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição do rolê:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      // widget.expenseModel!.title, // Reomver o ? do expense model
                      'João Augusto, Maria Joaquina, Pedro Aquino, Leo Silva',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
