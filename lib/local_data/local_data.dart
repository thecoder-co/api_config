import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static final LocalData instance = LocalData._internal();

  factory LocalData() {
    return instance;
  }

  LocalData._internal();

  late SharedPreferences prefs;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      // Handle property access (getter)
      final propertyName = invocation.memberName
          .toString()
          .substring(8); // Remove 'get: ' prefix
      return prefs.get(propertyName);
    } else if (invocation.isSetter) {
      // Handle property assignment (setter)
      final propertyName = invocation.memberName
          .toString()
          .substring(8); // Remove 'set: ' prefix
      prefs.setString(propertyName, invocation.positionalArguments[0]);
    }
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  set token(String? token) {
    if (token == null) prefs.remove('token');
    prefs.setString('token', token!);
  }

  String? get token {
    return prefs.getString('token');
  }
}
