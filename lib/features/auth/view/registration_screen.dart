import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/features/auth/view/login_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}



class _RegistrationScreenState extends State<RegistrationScreen> {

final TextEditingController _emailController = TextEditingController();
final TextEditingController _password1Controller = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();

  void _onRegisterPressed() {
    final email = _emailController.text.trim();
    final password1 = _password1Controller.text.trim();
    final password2 = _password2Controller.text.trim();

    if (email.isEmpty || password1.isEmpty || password2.isEmpty) {
      context.showMessage('⚠️ Заполните все поля');
      return;
    }

    if (password1 != password2) {
      _password1Controller.clear();
      _password2Controller.clear();
      context.showMessage('⚠️ Пароли не совпадают');
      return;
    }

    context.read<AuthBloc>().add(
          RegisterRequested(email: email, password: password1),
        );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Регистрация пользователя',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Логин
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Логин',
                hintText: 'extend@mail.ru',
                helperText: 'Введите email',
              ),
            ),

            const SizedBox(height: 16),

            // Ввод пароля
            TextField(
              obscureText: true,
              controller: _password1Controller,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                hintText: '********',
                helperText: 'Введите пароль',
              ),
            ),

            const SizedBox(height: 16),

            // Повторить пароль
            TextField(
              obscureText: true,
              controller: _password2Controller,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                hintText: '********',
                helperText: 'Повторите пароль',
              ),
            ),

            const SizedBox(height: 16),

            // Кнопки
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text('Назад'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _onRegisterPressed();
                  },
                  child: const Text('Зарегистрировать'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
