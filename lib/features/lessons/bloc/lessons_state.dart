import 'package:equatable/equatable.dart';
import 'package:rost/data/models/lesson.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();
}

//загрузка
class LessonsLoading extends LessonsState {
  @override
  List<Object?> get props => [];
}

//загруженно
class LessonsLoaded extends LessonsState {
  final List<Lesson> lessons;
  const LessonsLoaded(this.lessons);
  @override
  List<Object?> get props => [lessons];
}

//Занятий нет
class LessonsEmpty extends LessonsState {
  @override
  List<Object?> get props => [];
}

//ошибка
class LessonsError extends LessonsState {
  final String message;
  const LessonsError(this.message);
  @override
  List<Object?> get props => [message];
}
