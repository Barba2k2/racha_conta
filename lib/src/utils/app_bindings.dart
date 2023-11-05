import 'package:get/get.dart';

import '../features/authentication/controllers/login_controller.dart';
import '../features/authentication/controllers/signup_controller.dart';
import '../repository/authentication_repository/authentication_repository.dart';
import '../repository/user_repository/user_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationRepository());
    Get.lazyPut(() => UserRepository(), fenix: true);
    // Get.lazyPut(() => UserController(), fenix: true);
    // Get.lazyPut(() => ReportController(), fenix: true);
    // Get.lazyPut(() => const MyNavigationBar(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    // Get.lazyPut(() => OTPController(), fenix: true);
  }
}