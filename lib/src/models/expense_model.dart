import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat('dd/MM/yyyy');

final FirebaseAuth _auth = FirebaseAuth.instance;

const uuid = Uuid();

enum Category {
  combustivel,
  comida,
  lazer,
  moradia,
  reparos,
  trabalho,
  viagem,
  outros,
}

DateTime currentDate = DateTime.now();

String formattedDate =
    '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month}/${currentDate.year}';

const categoryIcons = {
  Category.combustivel: Icons.local_gas_station_rounded,
  Category.comida: Icons.lunch_dining_rounded,
  Category.lazer: CupertinoIcons.gamecontroller_alt_fill,
  Category.moradia: CupertinoIcons.house_fill,
  Category.reparos: CupertinoIcons.wrench_fill,
  Category.trabalho: CupertinoIcons.briefcase_fill,
  Category.viagem: CupertinoIcons.airplane,
};

extension CategoryExtension on Category {
  String get categoryDescription {
    switch (this) {
      case Category.comida:
        return "Alimentação";
      case Category.combustivel:
        return "Combustível";
      case Category.lazer:
        return "Lazer";
      case Category.moradia:
        return "Moradia";
      case Category.reparos:
        return "Reparos";
      case Category.trabalho:
        return "Trabalho";
      case Category.viagem:
        return "Viagem";
      case Category.outros:
        return 'Outros';
      default:
        return "Aliemntação";
    }
  }
}

Category getCategoryFromString(String category) {
  switch (category) {
    case 'Combustível':
      return Category.combustivel;
    case 'Alimentação':
      return Category.comida;
    case 'Viagem':
      return Category.viagem;
    case 'Lazer':
      return Category.lazer;
    case 'Trabalho':
      return Category.trabalho;
    case 'Moradia':
      return Category.moradia;
    case 'Reparos':
      return Category.reparos;
    case 'Outros':
      return Category.outros;
    default:
      return Category.comida;
  }
}

class ExpenseModel {
  ExpenseModel({
    required this.expenseId,
    required this.userId,
    required this.title,
    required this.ammount,
    required this.date,
    required this.category,
    required this.description,
  });

  final String expenseId;
  final String userId;
  final String title;
  final double ammount;
  final DateTime date;
  final Category category;
  final String description;

  String get formattedDate => formatter.format(date);

  Map<String, dynamic> toMap() {
    return {
      'Id da Despesa': expenseId,
      'Id do Usuario': userId,
      'Titulo': title,
      'Valor': ammount,
      'Data da Depsesa': Timestamp.fromDate(date),
      'Categoria': category.categoryDescription,
      'Descricao': description,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expenseId: map['Id da Despesa'] ?? '',
      userId: map['Id do Usuario'] ?? '',
      title: map['Titulo'] ?? '',
      ammount: map['Valor'] ?? '',
      date: (map['Data da Despesa'] as Timestamp).toDate(),
      category: map['Categoria'] ?? '',
      description: map['Descricao'] ?? '',
    );
  }

  factory ExpenseModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    log('Dados do Expense Model: $data');

    const expectFields = [];

    for (var field in expectFields) {
      if (!data.containsKey(field)) {
        log('Dados do documento: $data');
        throw Exception('Campos do docuemnto que estão faltando: $field');
      }
    }

    // Função para analisar e converter uma data em formato dinâmico para DateTime
    DateTime parseDate(dynamic input) {
      if (input is Timestamp) {
        // Se o input for do tipo Timestamp (Firestore), converte para DateTime e retorna
        return input.toDate();
      } else if (input is String) {
        // Se o input for do tipo String, divide a string em partes usando '/' como separador
        final parts = input.split('/');

        if (parts.length != 3) {
          // Verifica se existem três partes (dia, mês e ano)
          throw const FormatException('Formato de data inválido');
          // Lança uma exceção se o formato for inválido
        }

        final day = int.parse(parts[0]); // Extrai o dia da primeira parte
        final month = int.parse(parts[1]); // Extrai o mês da segunda parte
        final year = int.parse(parts[2]); // Extrai o ano da terceira parte

        // Cria um objeto DateTime e o retorna
        return DateTime(year, month, day);
      } else {
        // Se o input não for nem Timestamp nem String, lança uma exceção
        throw Exception(
            'Esperava Timestamp ou String, recebeu ${input.runtimeType}');
      }
    }

    // Se todos os campos estiverem presentes, continue a criação do modelo
    return ExpenseModel(
      expenseId: data['Id da Despesa'],
      userId: data['Id do Usuario'],
      title: data['Titulo'],
      ammount: data['Valor'],
      date: parseDate(data['Data da Despesa']),
      category: getCategoryFromString(data['Categoria'] as String),
      description: data['Descricao'],
    );
  }

  ExpenseModel copyWith({
    final String? expenseId,
    final String? userId,
    final String? title,
    final double? ammount,
    final DateTime? date,
    final Category? category,
    final String? description,
  }) {
    return ExpenseModel(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      ammount: ammount ?? this.ammount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  // Função assíncrona para gerar um novo ID para um chamado de relatório
  static Future<String> generateExpenseId() async {
    // Inicialização do Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Acesso à coleção de chamados do usuário atualmente autenticado
    final userCollection = firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Despesas');

    // Inicialização da variável para armazenar o último número da despesa
    int lastUserNumber = 0;

    try {
      // Consulta o última despesa na coleção do usuário
      final userQuerySnapshot = await userCollection
          .orderBy('Id da Despesa', descending: true)
          .limit(1)
          .get();

      // Registra a consulta à coleção do usuário
      log('Consulta à coleção de usuário realizada: $userQuerySnapshot');

      if (userQuerySnapshot.docs.isNotEmpty) {
        // Obtém o ID da despesa mais recente
        final lastUserId =
            userQuerySnapshot.docs.first['Id da Despesa'] as String;

        // Extrai o número da despesa
        lastUserNumber = int.parse(lastUserId.replaceFirst('Despesa', ''));

        // Registra o último ID e número da despesa recuperados
        log('Último ID da despesa recuperado: $lastUserId');
        log('Último número da despesa recuperado: $lastUserNumber');
      } else {
        // Registra a ausência de chamados na coleção do usuário
        log('Nenhuma despesa encontrada na coleção de usuário.');
      }

      // Gerar o próximo ID com base no último número da despesa
      String nextId =
          'Despesa${(lastUserNumber + 1).toString().padLeft(3, '0')}';

      // Registra o próximo ID gerado
      log('Próximo ID da despesa gerado: $nextId');

      return nextId; // Retorna o próximo ID gerado
    } catch (e) {
      // Registra e lança uma exceção em caso de erro
      log('Erro: $e');
      throw Exception('Erro ao gerar ID da despesa: $e');
    }
  }
}

//* Agrupara os dados de forma resumida
//* Agrupa os dados de mesma categoria
class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<ExpenseModel> allExpanses, this.category)
      : expenses = allExpanses
            .where(
              (expense) => expense.category == category,
            )
            .toList();

  final Category category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      //* sum = sum + expense.amount
      //* mesma função, escrita de formas diferentes
      sum += expense.ammount;
    }

    return sum;
  }
}
