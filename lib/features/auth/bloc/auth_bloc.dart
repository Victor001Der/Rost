import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading()); //запускаем крутилку

      try {
        await _authRepository.signIn(event.email, event.password);
        emit(AuthSuccess());
       } on FirebaseAuthException catch (e) {
    // Конкретная ошибка от Firebase
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Пользователь не найден';
        break;
      case 'wrong-password':
        message = 'Неверный пароль';
        break;
      case 'invalid-email':
        message = 'Неверный формат email';
        break;
      case 'user-disabled':
        message = 'Аккаунт заблокирован';
        break;
      case 'invalid-credential':
        message = 'Неверный email или пароль';
        break;
      default:
        message = 'Ошибка входа. Попробуйте позже';
    }
    emit(AuthError(message));
    
  } catch (e) {
    // Ошибка не от Firebase (нет интернета, таймаут)
    emit(AuthError('Ошибка соединения. Проверьте интернет.'));
  }
});

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        await _authRepository.signUp(event.email, event.password);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        // ← ВОТ ЗДЕСЬ
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Этот email уже используется';
            break;
          case 'invalid-email':
            message = 'Неверный формат email';
            break;
          case 'weak-password':
            message = 'Пароль должен быть не короче 6 символов';
            break;
          default:
            message = 'Ошибка регистрации';
        }
        emit(AuthError(message));
      } catch (e) {
        // ← Все остальные ошибки (интернет и т.д.)
        emit(AuthError('Ошибка соединения. Проверьте интернет.'));
      }
    });
  }
}
