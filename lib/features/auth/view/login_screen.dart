import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/features/auth/bloc/auth_state.dart';
import 'package:rost/features/auth/view/registration_screen.dart';
import 'package:rost/features/navigation/view/main_navigation.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener <AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          context.showMessage(state.message);
        } else if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainNavigation()),
            (route) => false, // убирает все предыдущие экраны
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Вход',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                    labelText: 'Логин',
                    hintText: 'example@mail.ru',
                    helperText: 'Введите email'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  hintText: '********',
                  helperText: 'Введите пароль',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    final email = _loginController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      context.showMessage('⚠️Заполните все поля');
                      return;
                    } else {
                      context.read<AuthBloc>().add(
                            LoginRequested(email: email, password: password),
                          );
                    }
                  },
                  child: Text('Войти')),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegistrationScreen(), // ← без .value
                    ),
                  );
                },
                child: Text('Регистрация нового пользователя'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
