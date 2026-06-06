import 'package:equatable/equatable.dart';
import 'package:rost/data/models/lesson.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<Lesson> lessons;
  final int totalCount;
  final int totalPrice;
  final int specialistPercent;
  final int totalForSpecialist;
  final int totalForOffice;
  final Map<String, ChildReport> byChild;

  const ReportsLoaded({
    required this.lessons,
    required this.totalCount,
    required this.totalPrice,
    required this.specialistPercent,
    required this.totalForSpecialist,
    required this.totalForOffice,
    required this.byChild,
  });

  @override
  List<Object?> get props => [
        lessons,
        totalCount,
        totalPrice,
        specialistPercent,
        totalForSpecialist,
        totalForOffice,
        byChild,
      ];
}

class ChildReport {
  final int count;
  final int total;
  final int forSpecialist;
  final int forOffice;

  const ChildReport({
    required this.count,
    required this.total,
    required this.forSpecialist,
    required this.forOffice,
  });
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError({required this.message});
  @override
  List<Object?> get props => [message];
}
