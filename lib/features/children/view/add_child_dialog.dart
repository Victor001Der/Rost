import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rost/core/extension/context_extension.dart';
import 'package:rost/data/models/child.dart';
import 'package:rost/features/children/bloc/children_bloc.dart';
import 'package:rost/features/children/bloc/children_event.dart';

class AddChildDialog extends StatefulWidget {
  const AddChildDialog({super.key});

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _notesController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Добавить воспитанника',
          style: TextStyle(fontSize: 24),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя воспитанника',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Возраст',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                  labelText: 'Диагноз', helperText: 'не обязательно'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Заметки',
                helperText: 'не обязательно',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _parentNameController,
              decoration: const InputDecoration(
                labelText: 'Имя родителя',
                helperText: 'не обязательно',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _parentPhoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон родителя',
                helperText: 'не обязательно',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Стоимость занятия',
                helperText: 'по умолчанию 1000',
              ),
              keyboardType: TextInputType.number,
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

                    final name = _nameController.text.trim();
                    final age = int.tryParse(_ageController.text) ?? 0;
                    final diagnosis =
                        _diagnosisController.text.trim().isNotEmpty
                            ? _diagnosisController.text.trim()
                            : null;
                    final notes = _notesController.text.trim().isNotEmpty
                        ? _notesController.text.trim()
                        : null;
                    final parentName =
                        _parentNameController.text.trim().isNotEmpty
                            ? _parentNameController.text.trim()
                            : null;
                    final parentPhone =
                        _parentPhoneController.text.trim().isNotEmpty
                            ? _parentPhoneController.text.trim()
                            : null;

                    final price =
                        double.tryParse(_priceController.text) ?? 1000;

                        //Проверки
                    if (name.isEmpty || age <= 0) {
                      context.showMessage('Введите имя и корректный возраст');
                      return;
                    }
                    if (parentPhone != null && parentPhone.length < 10) {
                      context.showMessage('Введите корректный номер телефона');
                      return;
                    }
                    if (price < 0) {
                      context
                          .showMessage('Стоимость не может быть отрицательной');
                      return;
                    }


                    final child = Child(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      childName: name,
                      childYear: age,
                      diagnosis: diagnosis,
                      notes: notes,
                      parentName: parentName,
                      parentPhone: parentPhone,
                      defaultPrice: price,
                      createdAt: DateTime.now(),
                      isActive: true,
                    );

                    context.read<ChildrenBloc>().add(AddChild(child));
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
