import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/authentication/models/user_model.dart';
import '../authentication_repository/exceptions/exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createUser(UserModel user) async {
    try {
      if (await recordExist(user.email)) {
        throw 'O e-mail ${user.email} já possui cadastro';
      } else {
        DocumentReference docRef =
            await _db.collection('Users').add(user.toJson());
        //# Retorna o id do documento criado
        log('Docuemnto do usuário: ${docRef.id}');
        return docRef.id;
      }
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente!'
          : e.toString();
    }
  }

  Future<String> createUserWithGoogle(UserModel user) async {
    try {
      //@ Verifica se o usuário ja existe baseado no e-mail
      if (await recordExist(user.email)) {
        throw 'Este email já está cadastrado!';
      } else {
        // Obtem uma referencia ao docuemnto que você quer adciionar/definir
        DocumentReference docRef = _db.collection('Users').doc(user.id);

        // Adcionar o UserModel ao FireStore
        await docRef.set({user.toJson()});
        log('Docuemnto do usuário pelo google: ${docRef.id}');
        return docRef.id;
      }
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    try {
      final snapshot = await _db.collection('Users').where('E-mail', isEqualTo: email).get();
      if(snapshot.docs.isEmpty) throw 'Nunhum usuário encontrado';

      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Algo deu errado. Por favor, tente novamente.' : e.toString();
    }
  }

  Future<UserModel> getUserNameDetails(String name) async {
    try {
      final snapshot = await _db.collection('Users').where('Nome Completo', isEqualTo: name).get();
      if(snapshot.docs.isEmpty) throw 'Usuário não encontrado';

      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Algo deu errado. Por favor, tente novamente.' : e.toString();
    }
  }

  Future<void> updateUserRecord(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Algo deu errado. Por favor, tente novamente.' : e.toString();
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _db.collection("Users").doc(id).delete();
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      log('Erro ao apagar o usuário: $e');
      throw 'Algo deu errado. Por favor, tente novamente';
    }
  }

  Future<UserModel> getUserDetailsById(String uid) async {
    try {
      final snapshot = await _db.collection("Users").doc(uid).get();
      if (!snapshot.exists || snapshot.data() == null) {
        throw 'Nenhum usuário encontrado';
      }
      return UserModel.fromSnapshot(snapshot);
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Algo deu errado. Por favor, tente novamente'
          : e.toString();
    }
  }

  //% Verifica se o usuário existe com e email ou telefone informado
  Future<bool> recordExist(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("E-mail", isEqualTo: email).get();
      return snapshot.docs.isEmpty ? false : true;
    } catch (e) {
      throw "Erro ao buscar registro: $e";
    }
  }
}
