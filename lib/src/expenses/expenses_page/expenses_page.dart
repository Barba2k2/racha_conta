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
import '../../models/expense_model.dart';
import '../controllers/user_controller.dart';
import '../provider/fireauth_provider.dart';
import 'chart/chart.dart';
import 'expanses_list/expenses_list.dart';
import '../new_expense/new_expense.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key, this.expenseModel}) : super(key: key);
  final ExpenseModel? expenseModel;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<ExpenseModel> _registeredExpenses = [
    ExpenseModel(
      title: 'Jetete',
      ammount: 19.99,
      date: DateTime.now(),
      category: Category.trabalho,
      description: 'Teste',
      expenseId: 'Despesa001',
      userId: '',
    ),
    ExpenseModel(
      title: 'Cinema',
      ammount: 15.69,
      date: DateTime.now(),
      category: Category.lazer,
      description: 'Pipoca e ingresso',
      expenseId: 'Despesa002',
      userId: '',
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

  void _addExpense(ExpenseModel expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(ExpenseModel expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Despesa apagada.'),
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
    Widget mainContent = const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(emptyExpenses),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    // Obtém instâncias dos controladores de usuário e tema usando `Get.find()`.
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();
    User? usuarioLogado = FireauthProvider.getCurrentUser();

    if (usuarioLogado != null) {
      // Faça algo com o usuário logado
      log('Usuário logado: ${usuarioLogado.email}');
    } else {
      // Não há usuário logado
      log('Nenhum usuário logado.');
    }

    // Widget observável que reage às mudanças de estado (mudanças no modo escuro/claro)
    return Obx(
      () {
        // Define se o modo escuro está ativado ou não
        final isDark = themeController.isDarkMode.value;

        // Estrutura principal da página de chamados
        return SafeArea(
          child: Scaffold(
            // Chave baseada no modo escuro ou claro
            key: ValueKey(Get.isDarkMode),

            // Cor de fundo baseada no modo escuro ou claro
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
                  // bool isAdmin = user?.isAdmin ?? false;
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chart(expenses: _registeredExpenses),
                    Expanded(
                      child: StreamBuilder<UserModel?>(
                        stream: userController.userStream,
                        builder: ((context, snapshot) {
                          final user = snapshot.data;
                          return SizedBox();
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // body: Container(
            //   color: isDark ? darkBg : whiteBg,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Chart(expenses: _registeredExpenses),
            //       Expanded(
            //         child: mainContent,
            //       ),
            //     ],
            //   ),
            // ),
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
      },
    );
  }
}
