// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:racha_conta/src/widgets/chart/chart.dart';

import 'expanses_list/expenses_list.dart';
import '../models/expense.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Jetete',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.trabalho,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.lazer,
    ),
  ];

  void _openAddExpanseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Conta apagada.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                expenseIndex,
                expense,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
            'Nenhuma conta encontrada. Começe a monitorar seus gastos com a sua galera!'),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Racha Conta'),
        actions: [
          IconButton(
            onPressed: _openAddExpanseOverlay,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
