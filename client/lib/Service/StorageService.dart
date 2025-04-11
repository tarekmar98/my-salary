import 'package:client/Model/JobInfo.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@Injectable()
class StorageService {
  void save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString(key);
    if (val != null && val?.length != 0) {
      return val.toString();
    }
    return "";
  }

  Future<JobInfo?> getJobById(int id) async {
    String allJobs = await get('myJobs');
  List<dynamic> decodedJobs = json.decode(allJobs);
  List<JobInfo> jobs = decodedJobs.map((jobJson) => JobInfo.fromJson(jobJson)).toList();
  for (JobInfo job in jobs) {
      if (job.id == id) {
        return job;
      }
    }

    return null;
  }
}