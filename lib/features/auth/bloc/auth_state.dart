abstract class AuthState {}

// Начальное состояние — экран только открылся, ничего не происходит
class AuthInitial extends AuthState {}

// Загрузка — пользователь нажал "Войти", ждём ответ от Firebase
class AuthLoading extends AuthState {}

// Успех — вход выполнен, переходим на главный экран
class AuthSuccess extends AuthState {}

// Ошибка — что-то пошло не так (неверный пароль, нет интернета)
class AuthError extends AuthState {
  final String message; // текст ошибки для пользователя
  AuthError(this.message);
}