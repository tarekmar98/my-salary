import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class StorageService {
  void save(String key, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, token);
  }

  Future<String> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString(key);
    if (val?.length != 0) {
      return val.toString();
    }
    return "";
  }
}