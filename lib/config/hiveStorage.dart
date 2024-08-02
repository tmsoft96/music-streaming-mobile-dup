import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

Future<void> saveHive({@required String? key, @required var data}) async {
  final box = Hive.lazyBox('revoltBox');
  await box.put(key, data);
  print("Info save in map $key, revolt box");
}

Future<dynamic> getHive(String key) async {
  final box = Hive.lazyBox('revoltBox');
  return box.get(key);
}

Future<void> deleteHive(String key) async {
  final box = Hive.lazyBox('revoltBox');
  return box.delete(key);
}