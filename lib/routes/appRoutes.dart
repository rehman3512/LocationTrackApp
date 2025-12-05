import 'package:get/get.dart';
import 'package:locationapp/Views/HomeView/homeView.dart';
import 'package:locationapp/Views/HomeView/mapView.dart';

class AppRoutes{

  static String homeScreen = "/HomeView";
  static String mapScreen = "/MapView";

  static final routes = [
    GetPage(name: homeScreen, page: ()=> HomeView()),
    GetPage(name: mapScreen, page: ()=> MapView())

  ];

}