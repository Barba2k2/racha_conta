import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../models/expense_model.dart';
import '../../controllers/expense_controller.dart';
import '../expanses_list/expenses_list.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_detail.dart';

class ExpensesWidget extends StatelessWidget {
  const ExpensesWidget(this.widget, {super.key});

  final ExpensesList widget;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return StreamBuilder(
      stream: ExpenseController().stream(),
      builder: (context, snapshot) {
        //! Verifica se há erro no snapshot
        if (snapshot.hasError) {
          log('Erro da snapshot da pagina expenses: ${snapshot.error}');
        }

        //! Verifica se o snapshot está carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
              strokeWidth: 5,
              strokeAlign: BorderSide.strokeAlignCenter,
              semanticsLabel: 'Carregando rolês...',
            ),
          );
        }

        //! Verifica se o snapshot tem dados e não é nulo
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              'Nenhum dado disponível',
              style: TextStyle(color: isDark ? whiteColor : blackColor),
            ),
          );
        }

        // Se tudo estiver ok, construir a lista
        final expenseList = snapshot.data!.docs.map(
          (doc) {
            return ExpenseModel.fromSnapshot(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            );
          },
        ).toList();

        //@ Contrução da lista de despesas
        return ListView.builder(
          itemBuilder: (context, index) {
            final expense = expenseList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => ExpenseDetails(expenseModel: expense));
              },
              child: ExpenseCard(expense),
            );
          },
          itemCount: expenseList.length,
        );
      },
    );
  }
}
