import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //@ Variaveis do modelo
  final String? id;
  final String? password;
  final String fullName;
  final String email;
  final String? phoneNo;
  // final String? cpf;

  //# Construtor para criar uma instancia do UserModel.
  const UserModel({
    this.id,
    this.password,
    this.phoneNo,
    // this.cpf,
    required this.fullName,
    required this.email,
  });

  //$ Converte o modelo para uma mapa (JSON) para armazenar no Firebase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nome Completo': fullName,
      'E-mail': email,
      'Telefone': phoneNo,
      // 'CPF: cpf,
    };
  }

  //% Retorna uma instancia vazia do USerModel
  static UserModel empty() => const UserModel(
        id: '',
        email: '',
        fullName: '',
        phoneNo: '',
        // cpf: '',
      );

  //& Cria umainstancia de UserModel mapeando os dados do snapshot do Firebase
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    // Verifica se os dados estão vazios e retorna um modelo vazio, ne necessário.
    if (data == null || data.isEmpty) {
      return UserModel.empty();
    }

    return UserModel(
      id: document.id,
      email: data['E-mail'] ?? '',
      fullName: data['Nome Completo'] ?? '',
      phoneNo: data['Telefone'] ?? '',
      // cpf: data['CPF'] ?? '',
    );
  }
}
