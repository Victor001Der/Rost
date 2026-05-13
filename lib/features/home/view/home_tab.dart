import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    //инициировал блок
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rost',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              //сдесь будут занятия на сегодня, будут показываться карточки детей с которыми сегодлня занятие, две вкладки
              //1 сегодня 2 ближайжие занятия и будет ставится дата, сортировка по дате
              // КНОПКА быстрого добавления ЗАнятия через диалог

              ),
        ),
      ),
    );
  }
}
