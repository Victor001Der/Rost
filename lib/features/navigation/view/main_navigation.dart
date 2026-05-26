import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/features/children/view/children_tab.dart';
import 'package:rost/features/home/view/home_tab.dart';
import 'package:rost/features/lessons/view/lesson_tab.dart';
import 'package:rost/features/navigation/bloc/navigation_bloc.dart';
import 'package:rost/features/navigation/bloc/navigation_event.dart';
import 'package:rost/features/navigation/bloc/navigation_state.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    //инициировал блок
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) => IndexedStack(
          index: state.currentIndex,
          children: const [
            //пока что заглужки
            HomeTab(),
            ChildrenTab(),
            LessonsTab(),
            Center(child: Text('Отчёты')),
            Center(child: Text('Настройки')),
          ],
        ),
      ),
      //панель с кнопками
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<NavigationBloc>().state.currentIndex,
          onTap: (index) =>
              context.read<NavigationBloc>().add(TabChanged(index)),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Дети',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Занятия',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Отчёты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Настройки',
            ),
          ]),
    );
  }
}
