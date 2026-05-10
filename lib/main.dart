import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

Future <void> main() async {

  //1.без этой строчки Hive крашется
  WidgetsFlutterBinding.ensureInitialized();

  //2. Инициализируем hive
  await Hive.initFlutter();

  // 3.firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //4. регистрируем адаптер тот самый weather.g.dart
  // 4. Регистрируем адаптеры (добавим позже, когда будут модели)
  // Hive.registerAdapter(ChildAdapter());
  // Hive.registerAdapter(LessonAdapter());

  // 5. Открываем коробку. ВАЖНО: '' — это название твоей БД нужно будет дописать методы в <>
  await Hive.openBox('children_cache');
  await Hive.openBox('lessons_cache');
  await Hive.openBox('settings');

    runApp(RostApp());
}


