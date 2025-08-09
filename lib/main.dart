import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fontLoader = FontLoader('PretendardVariable')
    ..addFont(rootBundle.load('assets/fonts/PretendardVariable.woff2'));
  await fontLoader.load();
  runApp(const MainApp());
}
