import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../models/expense_model.dart';

class ExpenseController extends GetxController {
  // Inicializações das instâncias do Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  //! Define nomes de coleções do Firestore como constantes
  static const usersCollection = 'Users';
  static const expensesCollection = 'Expenses';

  // Função para obter o nome completo do usuário com base no ID do usuário
  Future<String?> getUserName(String userId) async {
    // Busca o documento do usuário no Firestore pelo seu ID
    DocumentSnapshot userDoc =
        await _firestore.collection(usersCollection).doc(userId).get();

    // Converte os dados do documento em um mapa
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    // Verifica se o documento contém um campo 'Nome Completo' e retorna seu valor
    if (userData != null && userData.containsKey('Nome Completo')) {
      return userData['Nome Completo'];
    }

    // Se não encontrar o campo 'Nome Completo', retorna null
    return null;
  }

  Future<void> addNewExpense(
    String title,
    double ammount,
    DateTime date,
    Category category,
    String description,
  ) async {
    try {
      String? userName = await getUserName(user!.uid);

      DateTime dateTime = DateTime.now();

      final expenseId = await ExpenseModel.generateExpenseId();

    } catch (e) {
      
    }
  }
}
