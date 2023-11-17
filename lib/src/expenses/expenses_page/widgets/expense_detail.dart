import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../models/expense_model.dart';
import '../../controllers/expense_controller.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key, required this.expenseModel});
  final ExpenseModel expenseModel;

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  // Inicializar o controlador
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data do Rolê
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Data do Rolê:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.expenseModel.formattedDate,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Título
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Título:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.expenseModel.title!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Valor
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Valor gasto:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.expenseModel.ammount!.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Categoria
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Categoria:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.expenseModel.category!.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Descrição
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Descrição da despesa/rolê:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.expenseModel.description!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
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
