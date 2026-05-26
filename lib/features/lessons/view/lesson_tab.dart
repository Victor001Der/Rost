import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/features/lessons/bloc/lessons_bloc.dart';
import 'package:rost/features/lessons/bloc/lessons_event.dart';
import 'package:rost/features/lessons/bloc/lessons_state.dart';
import 'package:rost/features/lessons/view/add_lesson_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class LessonsTab extends StatelessWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LessonsView();
  }
}

class _LessonsView extends StatefulWidget {
  const _LessonsView();

  @override
  State<_LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends State<_LessonsView> {
  // Выбранный день (по умолчанию сегодня)
  late DateTime _selectedDay;

  // День, на который смотрит календарь (для переключения месяцев)
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    // Загружаем занятия на сегодня
    context.read<LessonsBloc>().add(LoadLessonsByDate(_selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonsBloc, LessonsState>(
      listener: (context, state) {
        if (state is LessonsError) {
          context.showMessage(state.message);
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('Календарь занятий', style: TextStyle(fontSize: 24)),
          centerTitle: true,
        ),

        //реализация обновления свайпом вниз
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<LessonsBloc>().add(RefreshLessons());
          },
          child:
              BlocBuilder<LessonsBloc, LessonsState>(builder: (context, state) {
            if (state is LessonsLoading) {
              return Center(
                child: SpinKitSpinningLines(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50.0,
                ),
              );
            }

            if (state is LessonsEmpty) {
              return const Center(
                child: Text(
                  'Добавьте первое занятие',
                  style: TextStyle(fontSize: 24),
                ),
              );
            }

            if (state is LessonsLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TableCalendar(
                      // На какой день смотрим
                      focusedDay: _focusedDay,
                      // Какой день выбран
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      // Что делать при выборе дня
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        // Загружаем занятия на выбранный день
                        context.read<LessonsBloc>().add(
                              LoadLessonsByDate(selectedDay),
                            );
                      },
                      // Переключение месяца
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      // Точки на днях с занятиями
                      eventLoader: (day) {
                        return state.lessons.where((lesson) {
                          return isSameDay(lesson.date, day);
                        }).toList();
                      },
                      firstDay: DateTime(2024),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      locale: 'ru',
                      // Зелёное выделение выбранного дня
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.green.shade200,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Список занятий на выбранный день
                    Expanded(
                        child: ListView.builder(
                            itemCount: state.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = state.lessons[index];
                              return ListTile(
                                title: Text(lesson.childName),
                                subtitle: Text(
                                    '${lesson.date.day}.${lesson.date.month}'),
                                trailing: Text('${lesson.price}₽', 
                                style: TextStyle(fontSize: 20),),
                              );
                            }))
                  ],
                ),
              );
            }

            //Это страховка, чтобы BlocBuilder всегда что-то показывал.
            if (state is LessonsError) {
              return Center(
                  child: Text(
                state.message,
              ));
            }
            return const SizedBox.shrink();
          }),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_lesson',
          onPressed: () async {
            final newLesson = await showDialog(
              context: context,
              builder: (context) => const AddLessonDialog(),
            );
            if (newLesson != null && context.mounted) {
              context.read<LessonsBloc>().add(
                    AddLesson(newLesson),
                  );
            }
          },
          tooltip: 'Добавить занятие',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
