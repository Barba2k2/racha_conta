import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/helper/helper_controller.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  // Inicializações das instâncias do Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  //! Define nomes de coleções do Firestore como constantes
  static const usersCollection = 'Users';
  static const expensesCollection = 'Expenses';

  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

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
      final expenseId = await ExpenseModel.generateExpenseId();

      final expense = ExpenseModel(
        expenseId: expenseId,
        userId: user!.uid,
        title: title,
        amount: ammount,
        date: date,
        category: category,
        description: description,
      );

      DocumentReference documentReference = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId);

      await documentReference.set(expense.toMap());

      Helper.successSnackBar(
        title: 'Sucesso',
        message: 'Seu rolê foi salvo e guardado com segurança.',
      );
    } catch (e) {
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Houve um erro ao salvar seu rolê $e',
      );
    }
  }

  Future<String?> getExpenseId(String expenseId) async {
    try {
      DocumentSnapshot expenseDoc = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId)
          .get();

      if (expenseDoc.exists) {
        // Se o documento da despesa existir, retorna o ID da despesa
        return expenseDoc.id;
      } else {
        // Se o documento não existir, retorna null ou lida com isso conforme necessário
        return null;
      }
    } catch (e) {
      log('Erro ao obter o ID da despesa: $e');
      return null;
    }
  }

  Future<int> getExpenseNumber(String userId) async {
    try {
      QuerySnapshot expenseSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(expensesCollection)
          .get();

      return expenseSnapshot.docs.length + 1;
    } catch (e) {
      log('Erro ao obter o número de despesas para o usuário: $e');
      rethrow;
    }
  }

  List getExpenses(AsyncSnapshot snapshot) {
    try {
      final expenseList = snapshot.data.docs.map(
        (doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ExpenseModel(
            expenseId: data['Id da Despesa'],
            userId: data['Id do Usuario'],
            title: data['Titulo'],
            amount: data['Valor'],
            date: data['Data da Despesa'],
            category: data['Categoria'],
            description: data['Descricao'],
          );
        },
      ).toList();
      return expenseList;
    } catch (e, stackTrace) {
      log('Erro ao obter o ID da despesa: $e');
      log('Stack Trace: $stackTrace');
      return [];
    }
  }

  // StreamController para lidar com as despesas de um usuário específico.
  final StreamController<QuerySnapshot> _streamController =
      StreamController.broadcast();

  Stream<QuerySnapshot> stream() {
    _firestore
        .collection(usersCollection)
        .doc(_auth.currentUser!.uid)
        .collection(expensesCollection)
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

  Future<List<ExpenseModel>> fetchExpenses() async {
    try {
      final querySnapshot = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .get();

      return querySnapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ExpenseModel.fromMap(data);
        },
      ).toList();
    } catch (e, stackTrace) {
      log('Erro ao buscar as despesas do usuário: $e');
      log('Stack Trace: $stackTrace');
      return [];
    }
  }

  Future<void> fetchAndEditExpense(
    String expenseId, {
    String? newTitle,
    double? newAmmount,
    Category? newCategory,
    String? newDescription,
  }) async {
    try {
      final docRef = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId);

      DocumentSnapshot documentSnapshot = await docRef.get();

      if (!documentSnapshot.exists || documentSnapshot.data() == null) {
        log('Erro: Despesa não encotrada');
        return;
      }

      ExpenseModel expenseModel = ExpenseModel.fromMap(
        documentSnapshot.data() as Map<String, dynamic>,
      );

      final updatedExpense = expenseModel.copyWith(
        title: newTitle ?? expenseModel.title,
        amount: newAmmount ?? expenseModel.amount,
        category: newCategory ?? expenseModel.category,
        description: newDescription ?? expenseModel.description,
      );

      await docRef.update(updatedExpense.toMap());

      Helper.successSnackBar(
        title: 'Sucesso!',
        message: 'Seu rolê foi atualizado sem erros.',
      );
    } catch (e) {
      log('Falha na edição da despesa: $e');
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Houve um erro ao atualizar o rolê, tente de novo mais tarde.',
      );
    }
  }

  Future<ExpenseModel?> getExpenseById(String expenseId) async {
    try {
      DocumentSnapshot docSnap = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId)
          .get();

      if (docSnap.exists && docSnap.data() != null) {
        return ExpenseModel.fromMap(
          docSnap.data() as Map<String, dynamic>,
        );
      } else {
        log('Erro na função getExpenseById');
        return null;
      }
    } catch (e) {
      log('Erro na função getExpenseById: $e');
      return null;
    }
  }

  Future<void> updateExpense(
    String expenseId,
    ExpenseModel updatedExpense,
  ) async {
    try {
      final docRef = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId);

      final docSnap = await docRef.get();

      if (docSnap.exists && docSnap.data() != null) {
        final existingExpenses = ExpenseModel.fromMap(
          docSnap.data() as Map<String, dynamic>,
        );

        final mergedExpense = updatedExpense.copyWith(
          title: updatedExpense.title ?? existingExpenses.title,
          amount: updatedExpense.amount ?? existingExpenses.amount,
          category: updatedExpense.category ?? existingExpenses.category,
          description:
              updatedExpense.description ?? existingExpenses.description,
        );

        await docRef.update(mergedExpense.toMap());

        Helper.successSnackBar(
          title: 'Booooa Irmão',
          message: 'Seu rolê foi atualizado e pronto para ver as edições',
        );
      } else {
        log('Erro ao atualizar e/ou não encontrado');
      }
    } catch (e) {
      log('Erro ao atualizar o rolê: $e');
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Falha ao atualizar o rolê: $e',
      );
    }
  }

  // Método para carregar as despesas do Firestore
  Future<void> loadExpenses() async {
    try {
      final querySnapshot = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .get();

      expenses.assignAll(
        querySnapshot.docs.map(
          (doc) {
            final data = doc.data();
            return ExpenseModel.fromMap(data);
          },
        ),
      );

      update();
    } catch (e, stackTrace) {
      log('Erro ao buscar as despesas do usuário: $e');
      log('Stack Trace: $stackTrace');
    }
  }

  // Método para apagar uma despesa com base no ID da despesa
  Future<void> deleteExpense(String expenseId) async {
    try {
      final docRef = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(expensesCollection)
          .doc(expenseId);

      final docSnap = await docRef.get();

      if (docSnap.exists) {
        await docRef.delete();

        // Remova a despesa da lista local de despesas
        expenses.removeWhere((expense) => expense.expenseId == expenseId);

        update();

        Helper.successSnackBar(
          title: 'Despesa Apagada',
          message: 'Sua despesa foi removida com sucesso.',
        );
      } else {
        Helper.errorSnackBar(
          title: 'Erro ⚠️',
          message: 'Despesa não encontrada para exclusão.',
        );
      }
    } catch (e) {
      log('Erro ao apagar despesa: $e');
      Helper.errorSnackBar(
        title: 'Erro ⚠️',
        message: 'Falha ao apagar despesa: $e',
      );
    }
  }
}
