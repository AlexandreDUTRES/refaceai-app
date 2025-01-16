import 'package:http/http.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class HttpManager {
  Client createClient() => Client();

  Future<bool> hasConnection() => InternetConnection().hasInternetAccess;
}