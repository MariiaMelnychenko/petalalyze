import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _keyDeviceId = 'device_id';

class DeviceIdService {
  DeviceIdService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  String? _cachedId;

  static Future<DeviceIdService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return DeviceIdService(prefs: prefs);
  }

  Future<String> getOrCreate() async {
    if (_cachedId != null) return _cachedId!;
    _prefs ??= await SharedPreferences.getInstance();
    var id = _prefs!.getString(_keyDeviceId);
    if (id == null || id.length < 10) {
      id = const Uuid().v4();
      await _prefs!.setString(_keyDeviceId, id);
    }
    _cachedId = id;
    return id;
  }
}
