import 'package:equatable/equatable.dart';
import 'package:rost/data/models/child.dart';

abstract class ChildrenEvent extends Equatable {
  const ChildrenEvent();
}

//метод обновлденгия страницы при запукске, обращение в firestore
class LoadChildren extends ChildrenEvent {
  @override
  List<Object?> get props => [];
}

//обновление страницы через свайп
class RefreshChildren extends ChildrenEvent {
  @override
  List<Object?> get props => [];
}

//удаление карточки
class DeleteChild extends ChildrenEvent {
  final String childId;
  const DeleteChild(this.childId);
  @override
  List<Object?> get props => [childId];
}
//добавление ребенка
class AddChild extends ChildrenEvent {
  final Child child;
  const AddChild(this.child);
  @override
  List<Object?> get props => [child];
}
