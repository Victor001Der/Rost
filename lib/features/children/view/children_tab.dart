import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/utils/string_utils.dart';
import 'package:rost/data/models/child.dart';
import 'package:rost/data/repositories/child_repository.dart';
import 'package:rost/features/children/bloc/children_bloc.dart';
import 'package:rost/features/children/bloc/children_event.dart';
import 'package:rost/features/children/bloc/children_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rost/features/children/view/add_child_dialog.dart';

class ChildrenTab extends StatelessWidget {
  const ChildrenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChildrenBloc(context.read<ChildRepository>())..add(LoadChildren()),
      child: const _ChildrenView(), // ← приватный виджет
    );
  }
}

class _ChildrenView extends StatelessWidget {
  const _ChildrenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои воспитаники', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: BlocBuilder<ChildrenBloc, ChildrenState>(
        builder: (context, state) {
          if (state is ChildrenLoading) {
            return Center(
              child: SpinKitSpinningLines(
                color:
                    Theme.of(context).colorScheme.primary, // основной цвет темы
                size: 50.0,
              ),
            );
          }

          if (state is ChildrenEmpty) {
            return const Center(
                child: Text(
              'Добавьте первого ребёнка',
              style: TextStyle(fontSize: 24),
            ));
          }

          if (state is ChildrenLoaded) {
            // Пока заглушка, потом будет GridView с карточками
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 карточки в ряд (два столбца)
                  childAspectRatio:
                      1.2, // соотношение ширины к высоте (ширина чуть больше высоты)
                  crossAxisSpacing:
                      12, // отступ между столбцами (по горизонтали)
                  mainAxisSpacing: 12, // отступ между строками (по вертикали)
                ),

                // Сколько всего карточек (равно количеству детей в списке)
                itemCount: state.children.length,

                // Что рисовать для каждой карточки по индексу
                itemBuilder: (context, index) {
                  // Достаём одного ребёнка из списка по текущему индексу
                  final child = state.children[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // Имя ребёнка
                          Text(
                            child.childName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          // Возраст
                          Text(
                              '${child.childYear} ${getAgeWord(child.childYear)}'),

                          SizedBox(height: 8),

                          // Если есть диагноз
                          if (child.diagnosis != null)
                            Text(
                              child.diagnosis!,
                              maxLines: 1, // только одна строка
                              overflow: TextOverflow
                                  .ellipsis, // обрезает и ставит ...
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is ChildrenError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newChild = await showDialog<Child>(
            context: context,
            builder: (context) => const AddChildDialog(),
          );
          if (newChild != null && context.mounted) {
            context.read<ChildrenBloc>().add(AddChild(newChild));
          }
        },
        tooltip: 'Добавить ребенка',
        child: const Icon(Icons.add),
      ),
    );
  }
}
