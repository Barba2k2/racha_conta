import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../../models/expense_model.dart';
import '../../controllers/expense_controller.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_detail.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  late List<ExpenseModel> _registeredExpenses = [];

  @override
  void initState() {
    _registeredExpenses = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
            stream: ExpenseController().stream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log('Erro da snapshot da pagina expenses: ${snapshot.error}');
              }

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

              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text(
                    'Nenhum dado disponível',
                    style: TextStyle(
                      color: isDark ? whiteColor : blackColor,
                    ),
                  ),
                );
              }

              final expenseList = snapshot.data!.docs
                  .map(
                    (doc) => ExpenseModel.fromSnapshot(
                      doc as QueryDocumentSnapshot<Map<String, dynamic>>,
                    ),
                  )
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: _registeredExpenses.length + expenseList.length,
                itemBuilder: (context, index) {
                  if (index < _registeredExpenses.length) {
                    final expense = _registeredExpenses[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ExpenseDetails(expenseModel: expense));
                        log('Botão detalhes');
                      },
                      child: ExpenseCard(expense),
                    );
                  } else {
                    final firestoreIndex = index - _registeredExpenses.length;
                    final firestoreExpense = expenseList[firestoreIndex];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ExpenseDetails(expenseModel: firestoreExpense),
                        );
                        log('Botão detalhes');
                      },
                      child: ExpenseCard(firestoreExpense),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
