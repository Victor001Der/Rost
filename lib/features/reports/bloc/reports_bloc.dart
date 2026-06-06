import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rost/data/models/lesson.dart';
import 'package:rost/data/repositories/lessons_repository.dart';
import 'package:rost/features/reports/bloc/reports_event.dart';
import 'package:rost/features/reports/bloc/reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final LessonsRepository _lessonsRepository;

  ReportsBloc(this._lessonsRepository) : super(ReportsInitial()) {
    //загрузка отчета
    on<LoadReport>(_onLoadReport);
  }

  Future<void> _onLoadReport(
    LoadReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());

    try {
      final lessons = await _lessonsRepository.getLessonsByDateRange(
          event.startDate, event.endDate);

      //общая статистика
      final totalCount = lessons.length;
      final totalPrice =
          lessons.fold<int>(0, (sum, lesson) => sum + lesson.price!);

      //Процент специалиста достаем из настроек или 48 по умолчанию
      final settingsBox = Hive.box('settings');
      final specialistPercent =
          settingsBox.get('specialistPercent', defaultValue: 48) ?? 48;

      final totalForSpecialist = (totalPrice * specialistPercent / 100).round();
      final totalForOffice = totalPrice - totalForSpecialist;

      //Групировка по детям
      final Map<String, List<Lesson>> groupedByChild = {};
      for (final lesson in lessons) {
        //если по ребенку нету занятий, добавляем пустое
        groupedByChild.putIfAbsent(lesson.childName, () => []);
        groupedByChild[lesson.childName]!.add(lesson);
      }

      //статистика по каждому ребенку
      final Map<String, ChildReport> byChild = {};
      for (final entry in groupedByChild.entries) {
        final childName = entry.key;
        final childLessons = entry.value;
        final childCount = childLessons.length;
        final childTotal =
            childLessons.fold<int>(0, (sum, lesson) => sum + lesson.price!);
        final childForSpecialist =
            (childTotal * specialistPercent / 100).round();
        final childForOffice = childTotal - childForSpecialist;

        byChild[childName] = ChildReport(
          count: childCount,
          total: childTotal,
          forSpecialist: childForSpecialist,
          forOffice: childForOffice,
        );
      }

      emit(
        ReportsLoaded(
            lessons: lessons,
            totalCount: totalCount,
            totalPrice: totalPrice,
            specialistPercent: specialistPercent,
            totalForSpecialist: totalForSpecialist,
            totalForOffice: totalForOffice,
            byChild: byChild),
      );
    } catch (e) {
      emit(
        ReportsError(message: 'Не удалось загрузить отчёт'),
      );
    }
  }
}
