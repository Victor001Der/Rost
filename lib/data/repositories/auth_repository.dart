import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  //метод входа
  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  //метод регистрации
  Future<User?> signUp(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  //метод выхода
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}


//
//   /// Текущий пользователь (null — если не вошёл)
//   User? get currentUser => _firebaseAuth.currentUser;
//
//   /// Поток: слушает вход/выход
//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
// }
