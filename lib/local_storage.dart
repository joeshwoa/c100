import 'package:hive/hive.dart';

class LocalStorage {
  static final Map<String, Box> _boxes = {};

  static Future<void> init([String boxName = "c100"]) async {
    if(_boxes.containsKey(boxName)) return;

    final Box _box = await Hive.openBox(boxName);
    _boxes.addAll({
      boxName: _box,
    });
  }

  static Future<void> saveData(String key, dynamic value, [String boxName = "c100"]) async {
    if(_boxes.containsKey(boxName)) {
      _boxes[boxName]!.put(key, value);
    } else {
      await init(boxName);
      _boxes[boxName]!.put(key, value);
    }
  }

  static Object? getData(String key, [String boxName = "c100"]) {
    if(_boxes.containsKey(boxName)) {
      return _boxes[boxName]!.get(key);
    } else {
      return null;
    }
  }

  static Future<void> remove(String key, [String boxName = "c100"]) async {
    if(_boxes.containsKey(boxName)) {
      _boxes[boxName]!.delete(key);
    }
  }

}