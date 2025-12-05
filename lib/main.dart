import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:locationapp/Routes/appRoutes.dart';
import 'package:locationapp/appBindings/appBindings.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    cardColor: Color(0xFF1E1E1E),
    dialogBackgroundColor: Color(0xFF1F1F1F),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LocationTrackApp",
      initialRoute: AppRoutes.homeScreen,
      getPages: AppRoutes.routes,
      initialBinding: AppBindings(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}