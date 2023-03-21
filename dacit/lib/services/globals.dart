import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseDomain =
    String.fromEnvironment('DACIT_API', defaultValue: 'http://localhost:8000/');
const storage = FlutterSecureStorage();
final AppUser user = AppUser();

class AppUser {
  String name;
  String token;
  String language;

  AppUser({this.name = "User", this.token = "", this.language = "en"});
}
