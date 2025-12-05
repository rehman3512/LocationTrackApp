import 'package:get/get.dart';
import 'package:locationapp/controllers/locationController.dart';
import 'package:locationapp/controllers/themeController.dart';


class AppBindings extends Bindings{
  @override
  void dependencies(){
    Get.put(LocationController());
    Get.put(ThemeController());
  }
}