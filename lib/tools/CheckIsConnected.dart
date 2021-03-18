import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> get isConnected async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var connectivity = await (Connectivity().checkConnectivity());
  if (connectivity == ConnectivityResult.none)
    return false;
  else {
    if (prefs.getBool("AllowMobile") ?? true)
      return true;
    else
      return connectivity == ConnectivityResult.wifi;
  }
}