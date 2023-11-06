import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/expense_model.dart';
import '../controllers/expense_controller.dart';

class ExpenseDatails extends StatefulWidget {
  const ExpenseDatails({super.key, required this.expenseModel});
  final ExpenseModel expenseModel;

  @override
  State<ExpenseDatails> createState() => _ExpenseDatailsState();
}

class _ExpenseDatailsState extends State<ExpenseDatails> {
  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find();
    
    return const Placeholder();
  }
}