import 'package:get_it/get_it.dart';
// import 'package:rally/notification/pushNotificationService.dart';
import 'package:rally/services/navigationServices.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  // locator.registerLazySingleton(() => PushNotificationService());
}
