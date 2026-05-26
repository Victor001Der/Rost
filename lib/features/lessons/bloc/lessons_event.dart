import 'package:equatable/equatable.dart';
import 'package:rost/data/models/lesson.dart';

abstract class LessonsEvent extends Equatable {
  const LessonsEvent();
}

//метод обновления страницы при запуске, обращение в firestore
class LoadLessons extends LessonsEvent {
  @override
  List<Object?> get props => [];
}

//обновление страницы через свайп
class RefreshLessons extends LessonsEvent {
  @override
  List<Object?> get props => [];
}

//удаление занятия
class DeleteLesson extends LessonsEvent {
  final String lessonId;
  const DeleteLesson(this.lessonId);
  @override
  List<Object?> get props => [lessonId];
}

//добавление занятия
class AddLesson extends LessonsEvent {
  final Lesson lesson;
  const AddLesson(this.lesson);
  @override
  List<Object?> get props => [lesson];
}

//Загрузка занятия по дате
class LoadLessonsByDate extends LessonsEvent {
  final DateTime date;
  const LoadLessonsByDate(this.date);
  @override
  List<Object?> get props => [date];
}
