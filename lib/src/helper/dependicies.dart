import 'package:get/get.dart';
import 'package:shopsy/src/controllers/auth_controller.dart';
import 'package:shopsy/src/controllers/popular_product_controller.dart';

import '../controllers/splash_screen_controller.dart';
import '../services/storage_services.dart';

@override
void initState() {
  Get.put(SplashController());
  Get.put(AuthController());
  Get.put(PopularProductController());
  Get.put(StorageServices());
  StorageServices.to.init();
}
