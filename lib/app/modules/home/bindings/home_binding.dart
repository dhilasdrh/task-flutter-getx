import 'package:get/get.dart';

import '../../../data/providers/mahasiswa_provider.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<MahasiswaProvider>(
            () => MahasiswaProvider()
    );
  }
}
