import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';

class HttpManager {
  Client createClient() => Client();

  Future<bool> hasConnection() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}