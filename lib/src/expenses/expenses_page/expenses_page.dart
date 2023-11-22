// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/text_strings.dart';
import '../../controllers/theme_controller/theme_controller.dart';
import '../../features/authentication/models/user_model.dart';
import '../controllers/user_controller.dart';
import '../models/expense_model.dart';
import '../provider/fireauth_provider.dart';
import 'chart/chart.dart';
import 'expanses_list/expenses_list.dart';
import '../new_expense/new_expense.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key, this.expenseModel, this.userModel})
      : super(key: key);
  final ExpenseModel? expenseModel;
  final UserModel? userModel;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late List<ExpenseModel> _registeredExpenses;

  @override
  void initState() {
    super.initState();
    _registeredExpenses = [];
    _loadExpenses();
  }

  // Método para carregar as despesas do banco de dados
  void _loadExpenses() async {
    if (widget.expenseModel != null) {
      setState(() {
        _registeredExpenses.add(
          ExpenseModel(
            title: widget.expenseModel!.title,
            amount: widget.expenseModel!.amount,
            date: widget.expenseModel!.date,
            category: widget.expenseModel!.category,
            description: widget.expenseModel!.description,
            expenseId: widget.expenseModel!.expenseId,
            userId: widget.expenseModel!.userId,
          ),
        );
      });
    }
  }

  void _openAddExpanseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(ExpenseModel expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    Widget mainContent = Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          emptyExpenses,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: isDark ? whiteColor : blackColor,
              ),
        ),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList();
    }

    // Obtém instâncias dos controladores de usuário e tema usando `Get.find()`.
    final UserController userController = Get.find();
    User? usuarioLogado = FireauthProvider.getCurrentUser();

    if (usuarioLogado != null) {
      // Faça algo com o usuário logado
      log('Usuário logado: ${usuarioLogado.email}');
    } else {
      // Não há usuário logado
      log('Nenhum usuário logado.');
    }

    return SafeArea(
      child: Scaffold(
        key: ValueKey(Get.isDarkMode),
        backgroundColor: isDark ? tDarkColor : Colors.grey.shade200,

        // Barra de aplicativo
        appBar: AppBar(
          // Configurações de cores e aparência baseadas no modo escuro ou claro
          backgroundColor: isDark ? darkBg : whiteBg,
          foregroundColor: isDark ? darkBg : whiteBg,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,

          // Título exibindo informações do usuário
          title: StreamBuilder<UserModel?>(
            stream: userController.userStream,
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) {
                return const Text('Nome de usuário não disponivel');
              } else {
                // Mostra a imagem e o nome do usuário
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade400,
                    radius: 25,
                    child: Image.asset('assets/images/avatar.png'),
                  ),
                  title: Text(
                    'Olá, Bem-Vindo!',
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    user.fullName, //# Nome do usuário logado
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
            },
          ),

          // Ações na barra de aplicativos (calendário e notificações)
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.calendar,
                      color: isDark ? tWhiteColor : tDarkColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.bell,
                      color: isDark ? tWhiteColor : tDarkColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Chart(expenses: _registeredExpenses),
              StreamBuilder<UserModel?>(
                stream: userController.userStream,
                builder: (context, snapshot) {
                  return mainContent;
                },
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _openAddExpanseOverlay(),
              child: Text(
                'Novo Rolê'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
