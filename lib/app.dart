import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/theme/app_theme.dart';
import 'package:rost/data/repositories/auth_repository.dart';
import 'package:rost/features/auth/bloc/auth_bloc.dart';
import 'package:rost/features/auth/view/login_screen.dart';


class RostApp extends StatelessWidget {
  const RostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rost',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      //потом подключу темную тему
      home: BlocProvider(
        create: (_) => AuthBloc(AuthRepository()),
        child: const LoginScreen(),
      ),
    );
  }
}
