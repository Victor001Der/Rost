import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int currentIndex;

  const NavigationState ({this.currentIndex = 0});

  @override
  List<Object?> get props => [currentIndex];
}