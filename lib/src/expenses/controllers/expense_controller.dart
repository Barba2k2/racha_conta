import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_conta/src/utils/helper/helper_controller.dart';

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

      final expense = ExpenseModel(
        expenseId: expenseId,
        userId: user!.uid,
        title: title,
        ammount: ammount,
        date: date,
        category: category,
        description: description,
      );

      DocumentReference documentReference = _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Expenses')
          .doc(expenseId);

      await documentReference.set(expense.toMap());

      Helper.successSnackBar(
        title: 'Sucesso',
        message: 'Seu rolê foi salvo e guardado com segurnaça.',
      );
    } catch (e) {
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Houve um erro ao salvar seu rolê $e',
      );
    }
  }

  Future<int> getExpenseNumber(String userId) async {
    try {
      QuerySnapshot expenseSnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Expenses')
          .get();

      return expenseSnapshot.docs.length + 1;
    } catch (e) {
      log('Erro ao obter o número de despesas para o usuário: $e');
      rethrow;
    }
  }

  List getExpenses(AsyncSnapshot snapshot) {
    try {
      final expenseList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ExpenseModel(
          expenseId: data['Id da Despesa'],
          userId: data['Id do Usuario'],
          title: data['Titulo'],
          ammount: data['Valor'],
          date: data['Data da Despesa'],
          category: data['Categoria'],
          description: data['Descricao'],
        );
      }).toList();
      return expenseList;
    } catch (e) {
      log('Erro ao obter as despesas: $e');
      return [];
    }
  }

  // StreamController para lidar com as despesas de um usuário específico.
  final StreamController<QuerySnapshot> _streamController =
      StreamController.broadcast();

  Stream<QuerySnapshot> stream() {
    _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Expenses')
        .snapshots()
        .listen(
      (data) {
        _streamController.add(data);
      },
      onError: (error) {
        _streamController.addError(error);
      },
    );

    return _streamController.stream;
  }
}
