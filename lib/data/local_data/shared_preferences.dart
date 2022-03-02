import 'package:shared_preferences/shared_preferences.dart';

class GetFirstStatus {
  late Future<bool> status;

  Future<bool> getStatusFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final bool status;

    if (prefs.containsKey('status')) {
      status = prefs.getBool('status')!;
      return true;
    } else {
      prefs.setBool('status', true);
      return false;
    }
  }
}
