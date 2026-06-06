import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:rost/features/reports/bloc/reports_bloc.dart';
import 'package:rost/features/reports/bloc/reports_event.dart';
import 'package:rost/features/reports/bloc/reports_state.dart';

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ReportsView();
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView> {
  // По умолчанию: с начала текущего месяца по сегодня
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
  }

  // Формат даты для отображения
  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  // Выбор даты
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      locale: const Locale('ru'),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  // Загрузка отчёта
  void _loadReport(BuildContext context) {
    context.read<ReportsBloc>().add(
          LoadReport(startDate: _startDate, endDate: _endDate),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчёты', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор периода
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'С',
                    date: _startDate,
                    onTap: () => _pickDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DateField(
                    label: 'По',
                    date: _endDate,
                    onTap: () => _pickDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Кнопка "Показать отчёт"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Показать отчёт'),
                onPressed: () => _loadReport(context),
              ),
            ),
            const SizedBox(height: 24),

            // Результаты
            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsInitial) {
                    return const Center(
                      child: Text(
                        'Выберите период и нажмите "Показать отчёт"',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  if (state is ReportsLoading) {
                    return Center(
                      child: SpinKitSpinningLines(
                        color: Theme.of(context).colorScheme.primary,
                        size: 50.0,
                      ),
                    );
                  }

                  if (state is ReportsError) {
                    return Center(
                        child: Text(
                      state.message,
                    ));
                  }

                  if (state is ReportsLoaded) {
                    return _ReportResults(state: state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Поле выбора даты
class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          DateFormat('dd.MM.yyyy').format(date),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Виджет с результатами отчёта
class _ReportResults extends StatelessWidget {
  final ReportsLoaded state;

  const _ReportResults({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Общая статистика
        _StatCard(
          title: 'Всего занятий',
          value: state.totalCount.toString(),
          icon: Icons.calendar_today,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),

        // Финансы
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Общая сумма',
                value: '${state.totalPrice}₽',
                icon: Icons.monetization_on,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Вам (${state.specialistPercent}%)',
                value: '${state.totalForSpecialist}₽',
                icon: Icons.person,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _StatCard(
          title: 'Конторе (${100 - state.specialistPercent}%)',
          value: '${state.totalForOffice}₽',
          icon: Icons.business,
          color: Colors.red,
        ),
        const SizedBox(height: 24),

        // Заголовок "По детям"
        if (state.byChild.isNotEmpty) ...[
          const Text(
            'По детям:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Список детей
          ...state.byChild.entries.map((entry) {
            final childName = entry.key;
            final report = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Имя ребёнка
                    Row(
                      children: [
                        const Icon(Icons.child_care, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          childName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Количество и сумма
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${report.count} занятий',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          '${report.total}₽',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Распределение
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Вам: ${report.forSpecialist}₽',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                        Text(
                          'Конторе: ${report.forOffice}₽',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}

// Карточка статистики
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
