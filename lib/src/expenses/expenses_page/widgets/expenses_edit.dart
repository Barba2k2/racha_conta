import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../controllers/theme_controller/theme_controller.dart';
import '../../models/expense_model.dart';
import '../../controllers/expense_controller.dart';
import '../../provider/fireauth_provider.dart';

// ... (código do ExpenseModel e outras classes e métodos auxiliares)

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({Key? key, required this.expenseId})
      : super(key: key);

  final String expenseId;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _expenseDescription = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.lazer;
  final userId = FireauthProvider.getCurrentUserId();

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  void _loadExpenseData() async {
    try {
      ExpenseModel? expense =
          await ExpenseController().getExpenseById(widget.expenseId);

      if (expense != null) {
        setState(() {
          _titleController.text = expense.title ?? '';
          _amountController.text = expense.amount?.toString() ?? '';
          _selectedDate = expense.date;
          _selectedCategory = expense.category ?? Category.lazer;
          _expenseDescription.text = expense.description ?? '';
        });
      }
      log('Categoria carregada: ${expense?.category}');
    } catch (error) {
      log("Erro ao carregar os dados: $error");
      Get.snackbar('Erro', 'Não foi possível atualizar os dados');
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() async {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _expenseDescription.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text(
              'Verifique se os dados foram preenchidos corretamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final expenseId = widget.expenseId;

    final newExpense = ExpenseModel(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      description: _expenseDescription.text.trim(),
      expenseId: expenseId,
      userId: userId,
    );

    await ExpenseController().updateExpense(expenseId, newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Despesa',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: isDark ? tDarkColor : Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: 'R\$ ',
                        labelText: 'Valor',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Nenhuma data selecionada'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownButton<Category>(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                                category.categoryDescription.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _expenseDescription,
                maxLength: 500,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 155,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.purple,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: 155,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text(
                          'Salvar Despesa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                      ),
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
