import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/core/utils/string_utils.dart';
import 'package:rost/data/models/child.dart';
import 'package:rost/features/children/bloc/children_bloc.dart';
import 'package:rost/features/children/bloc/children_event.dart';
import 'package:rost/features/children/bloc/children_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rost/features/children/view/add_child_dialog.dart';

class ChildrenTab extends StatelessWidget {
  const ChildrenTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Отправляем событие загрузки при первом билде
    context.read<ChildrenBloc>().add(LoadChildren());
    return const _ChildrenView();
  }
}

class _ChildrenView extends StatelessWidget {
  const _ChildrenView();

//метод удаления с помощтю окошка подтверждения
  void _showDeleteDialog(BuildContext context, Child child) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text('Удалить ребёнка'),
                content:
                    Text('Вы уверены, что хотите удалить ${child.childName}?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Отмена')),
                  TextButton(
                    onPressed: () {
                      context.read<ChildrenBloc>().add(DeleteChild(child.id));
                      Navigator.pop(ctx);
                    },
                    child: const Text('Удалить',
                        style: TextStyle(color: Colors.red)),
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenBloc, ChildrenState>(
      listener: (context, state) {
        if (state is ChildrenError) {
          context.showMessage(state.message);
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои воспитанники', style: TextStyle(fontSize: 24)),
          centerTitle: true,
        ),

        //реализация обновления свайпом вниз
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ChildrenBloc>().add(RefreshChildren());
          },
          child: BlocBuilder<ChildrenBloc, ChildrenState>(
            builder: (context, state) {
              if (state is ChildrenLoading) {
                return Center(
                  child: SpinKitSpinningLines(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50.0,
                  ),
                );
              }

              if (state is ChildrenEmpty) {
                return const Center(
                  child: Text(
                    'Добавьте первого ребёнка',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }

              if (state is ChildrenLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.children.length,
                    itemBuilder: (context, index) {
                      final child = state.children[index];

                      return GestureDetector(
                        onLongPress: () {
                          _showDeleteDialog(context, child);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  child.childName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    '${child.childYear} ${getAgeWord(child.childYear)}'),
                                const SizedBox(height: 8),
                                if (child.diagnosis != null)
                                  Text(
                                    child.diagnosis!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
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
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_child',
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
      ),
    );
  }
}
