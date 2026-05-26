import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/data/models/child.dart';
import 'package:rost/data/models/lesson.dart';
import 'package:rost/features/children/bloc/children_bloc.dart';
import 'package:rost/features/children/bloc/children_state.dart';
import 'package:rost/features/children/view/add_child_dialog.dart';
import 'package:rost/features/lessons/bloc/lessons_bloc.dart';
import 'package:rost/features/lessons/bloc/lessons_event.dart';

class AddLessonDialog extends StatefulWidget {
  const AddLessonDialog({super.key});

  @override
  State<AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  Child? _selectedChild;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedPrice;

  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  //метод для выбора ребенка при  создании  занятия
  void _showChildrenPicker(BuildContext context) {
    final childrenState = context.read<ChildrenBloc>().state;

    if (childrenState is ChildrenLoaded && childrenState.children.isEmpty) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Нет детей для выбора',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Сначала добавьте ребёнка',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Добавить ребёнка'),
                onPressed: () {
                  Navigator.pop(ctx); // закрываем BottomSheet
                  // Открываем AddChildDialog
                  showDialog(
                    context: context,
                    builder: (_) => const AddChildDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      final children = (childrenState as ChildrenLoaded).children;

      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          children: children
              .map((child) => ListTile(
                    leading: const Icon(Icons.child_care),
                    title: Text(child.childName),
                    subtitle:
                        child.diagnosis != null ? Text(child.diagnosis!) : null,
                    onTap: () {
                      setState(() => _selectedChild = child);
                      Navigator.pop(ctx);
                    },
                  ))
              .toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Добавить занятие',
          style: TextStyle(fontSize: 24),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(_selectedChild?.childName ?? 'Выберите ребёнка'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () => _showChildrenPicker(context),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year}'
                    : 'Выберите дату',
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  locale: const Locale('ru'),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                _selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Выберите время',
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      _selectedTime ?? const TimeOfDay(hour: 14, minute: 0),
                );

                if (time != null) {
                  setState(() => _selectedTime = time);
                }
              },
            ),

            const SizedBox(
              height: 16,
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Стоимость занятия:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Пресеты
            Wrap(
              spacing: 8,
              children: [500, 800, 1000, 1500, 2000].map((price) {
                return ChoiceChip(
                  label: Text('$price₽'),
                  selected: _selectedPrice == price,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPrice = selected ? price : null;
                      if (selected) {
                        _priceController.text = price.toString();
                      } else {
                        _priceController.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Свой вариант
            TextField(
              keyboardType: TextInputType.number,
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Свой вариант',
                suffixText: '₽',
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                setState(() => _selectedPrice = parsed);
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки',
                helperText: 'не обязательно',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    //Закрывается клавитура при нажитие кнопки
                    FocusScope.of(context).unfocus();

                    //проверки
                    if (_selectedChild == null) {
                      context.showMessage('⚠️ Выберите ребёнка');
                      return;
                    }
                    if (_selectedDate == null) {
                      context.showMessage('⚠️ Выберите дату');
                      return;
                    }

                    final name = _selectedChild!.childName;
                    final childId = _selectedChild!.id;
                    final date = _selectedDate!;
                    final price =
                        int.tryParse(_priceController.text.trim()) ?? 1000;
                    final notes = _notesController.text.trim().isNotEmpty
                        ? _notesController.text.trim()
                        : null;

                    final lesson = Lesson(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      childId: childId,
                      childName: name,
                      date: date,
                      price: price,
                      notes: notes,
                      createdAt: DateTime.now(),
                    );

                    context.read<LessonsBloc>().add(AddLesson(lesson));
                    Navigator.pop(context);
                  },
                  child: Text('Добавить'),
                ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
