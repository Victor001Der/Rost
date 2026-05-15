import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/data/repositories/child_repository.dart';
import 'package:rost/features/children/bloc/children_event.dart';
import 'package:rost/features/children/bloc/children_state.dart';

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final ChildRepository _childrenRepository;

//общий метод для всех действий (обновление с проверкой)
  Future<void> _loadChildren(Emitter<ChildrenState> emit) async {
    emit(ChildrenLoading());

    try {
      final children = await _childrenRepository.getChildren();

      if (children.isEmpty) {
        emit(ChildrenEmpty());
      } else {
        emit(ChildrenLoaded(children));
      }
    } catch (e) {
      emit(ChildrenError('Не удалось загрузить данные'));
    }
  }

  ChildrenBloc(this._childrenRepository) : super(ChildrenLoading()) {
    //загрузка детей при входе
    on<LoadChildren>((event, emit) => _loadChildren(emit));

    // обновление посредством скрола вниз
    on<RefreshChildren>((event, emit) => _loadChildren(emit));

    //добьавление ребенка
    on<AddChild>((event, emit) async {
      await _childrenRepository.addChild(event.child);
      await _loadChildren(emit);
    });

    //удаление ребенка
    on<DeleteChild>((event, emit) async {
      await _childrenRepository.deleteChild(event.childId);
      await _loadChildren(emit);
    });
  }
}
