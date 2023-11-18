import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racha_conta/src/constants/colors.dart';

import '../../constants/text_strings.dart';
import '../../models/expense_model.dart';
import '../controllers/expense_controller.dart';
import '../provider/fireauth_provider.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(ExpenseModel expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _expenseDescritption = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.lazer;
  final userId = FireauthProvider.getCurrentUserId();

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.day, now.month, now.year - 1);
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

  void _submitExpanseData() async {
    //* Arrendonda o valor para 2 casas
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _expenseDescritption.text.trim().isEmpty) {
      //! Mensagem de erro
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(errorMessage),
          content: const Text(verifyData),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    final expenseId = await ExpenseController().getExpenseId(userId.toString());
    log('Id da depsesa criada: $expenseId');

    // Cria uma nova despesa
    final newExpense = ExpenseModel(
      title: _titleController.text,
      ammount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      description: _expenseDescritption.text.trim(),
      expenseId: expenseId,
      userId: userId,
    );

    log('Dados da despesa: $newExpense');

    // Salva a despesa no banco de dados
    await ExpenseController().addNewExpense(
      _titleController.text,
      enteredAmount,
      _selectedDate!,
      _selectedCategory,
      _expenseDescritption.text.trim(),
    );

    // Chama a função passada como argumento (onAddExpense) com a despesa criada
    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: Text(
                'Título',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'R\$ ',
                    label: Text(
                      'Valor',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, //? Horizontal
                  crossAxisAlignment: CrossAxisAlignment.center, //! Vertical
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Nenhuma data \nselecionada'
                          : formatter.format(_selectedDate!),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(CupertinoIcons.calendar),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ],
          ),
          const Gap(16),
          TextField(
            controller: _expenseDescritption,
            maxLength: 500,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text(
                'Descrição',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              alignLabelWithHint: true,
            ),
          ),
          const Gap(16),
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: purple, fontSize: 19),
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
                    onPressed: _submitExpanseData,
                    child: Text(
                      'Salvar Despesa',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: whiteColor, fontSize: 19),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
