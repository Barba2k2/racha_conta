import '../../../models/expense_model.dart';

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(
    List<ExpenseModel> allExpanses,
    this.category,
  ) : expenses = allExpanses.where(
          (expense) {
            return expense.category == category;
          },
        ).toList();

  final Category category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      //* sum = sum + expense.amount
      //* mesma função, escrita de formas diferentes
      sum += expense.amount!;
    }

    return sum;
  }

  void removeExpense(String expenseId) {
    expenses.removeWhere((expense) => expense.expenseId == expenseId);
  }
}