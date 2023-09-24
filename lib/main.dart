import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'EditImageScreen/stateManagement/colorChange.dart';
import 'HomeScreen/HomePage.dart';
import 'constant/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => SwitchChanged(val: false),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poster Maker',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: kAppBgColor,
      ),
      home: HomePage(),
    );
  }
}
