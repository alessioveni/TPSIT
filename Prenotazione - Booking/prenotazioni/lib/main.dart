import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get_it/get_it.dart';
import 'package:prenotazioni/services/prens_service.dart';
import 'package:prenotazioni/views/pren_list.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => PrensService());
  //GetIt.instance<PrensService>();
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prenotazione',
      theme: FlexColorScheme.light(
        colors: FlexColor.schemes[FlexScheme.mandyRed].light,
      ).toTheme,
      // The Mandy red dark theme.
      darkTheme: FlexColorScheme.dark(
        colors: FlexColor.schemes[FlexScheme.mandyRed].dark,
      ).toTheme,
      themeMode: ThemeMode.dark,
      home: PrenList(),
    );
  }
}
