import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/theme/app_theme.dart';
import 'package:rost/data/repositories/auth_repository.dart';
import 'package:rost/data/repositories/child_repository.dart';
import 'package:rost/data/repositories/lessons_repository.dart';
import 'package:rost/features/auth/bloc/auth_bloc.dart';
import 'package:rost/features/auth/view/login_screen.dart';
import 'package:rost/features/children/bloc/children_bloc.dart';
import 'package:rost/features/lessons/bloc/lessons_bloc.dart';
import 'package:rost/features/navigation/bloc/navigation_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RostApp extends StatelessWidget {
  const RostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
        BlocProvider<ChildrenBloc>(
            create: (_) => ChildrenBloc(ChildRepository())),
        BlocProvider<LessonsBloc>(
          create: (_) => LessonsBloc(LessonsRepository()),
        )
      ],
      child: MaterialApp(
        title: 'Rost',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        //потом подключу темную тему

        //Русская локализация для календаря и времени
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
        ],
        locale: const Locale('ru', 'RU'),

        home: const LoginScreen(),
      ),
    );
  }
}
