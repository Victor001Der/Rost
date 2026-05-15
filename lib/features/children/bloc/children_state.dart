import 'package:equatable/equatable.dart';
import 'package:rost/data/models/child.dart';

abstract class ChildrenState extends Equatable {
  const ChildrenState();
}

//загрузка
class ChildrenLoading extends ChildrenState {
  @override
  List<Object?> get props => [];
}

//загруженно
class ChildrenLoaded extends ChildrenState {
  final List<Child> children;
  const ChildrenLoaded(this.children);
  @override
  List<Object?> get props => [children];
}

//детей нет
class ChildrenEmpty extends ChildrenState {
  @override
  List<Object?> get props => [];
}

//ошибка
class ChildrenError extends ChildrenState {
  final String message;
  const ChildrenError(this.message);
  @override
  List<Object?> get props => [message];
}
