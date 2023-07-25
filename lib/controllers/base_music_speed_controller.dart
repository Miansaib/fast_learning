import 'package:get/get.dart';

abstract class BaseMusicSpeedController extends GetxController {
  Rx<double> speed = 1.0.obs;
  void changeSpeed(double value);
}
