import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/data/repositories/lessons_repository.dart';
import 'package:rost/features/lessons/bloc/lessons_event.dart';
import 'package:rost/features/lessons/bloc/lessons_state.dart';

class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  final LessonsRepository _lessonsRepository;

// общий метод для всех действий (обновление с проверкой)
  Future<void> _loadLessons(Emitter<LessonsState> emit) async {
    emit(LessonsLoading());

    try {
      final lessons = await _lessonsRepository.getLessons();

      if (lessons.isEmpty) {
        emit(LessonsEmpty());
      } else {
        emit(LessonsLoaded(lessons));
      }
    } catch (e) {
      emit(LessonsError('Не удалось загрузить данные'));
    }
  }

  LessonsBloc(this._lessonsRepository) : super(LessonsLoading()) {
    // загрузка детей при входе
    on<LoadLessons>((event, emit) => _loadLessons(emit));

    // обновление посредством скрола вниз
    on<RefreshLessons>((event, emit) => _loadLessons(emit));

    // добавление занятия
    on<AddLesson>((event, emit) async {
      await _lessonsRepository.addLesson(event.lesson);
      await _loadLessons(emit);
    });

    // удаление ребенка
    on<DeleteLesson>((event, emit) async {
      await _lessonsRepository.deleteLesson(event.lessonId);
      await _loadLessons(emit);
    });

    // загрузка занятий на конкретную дату (не использую loadLessons потму что тут сортировк по дате)
    on<LoadLessonsByDate>((event, emit) async {
      emit(LessonsLoading());
      try {
        final lessons = await _lessonsRepository.getLessonsByDate(event.date);
        if (lessons.isEmpty) {
          emit(LessonsEmpty());
        } else {
          emit(LessonsLoaded(lessons));
        }
      } catch (e) {
        emit(LessonsError('Не удалось загрузить занятия'));
      }
    });
  }
}
