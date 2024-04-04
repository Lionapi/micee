// ignore_for_file: prefer_typing_uninitialized_variables, file_names, avoid_print

import 'package:mysql_client/mysql_client.dart';

class DBconnexionSql {
  // DB param
  // static String host = "10.0.2.2";  //when you use emulator like android
  // static String host = "10.0.2.15";  //when you use navigator like chrome
  static String host = "127.0.0.1"; //when you use simulator like windows
  static int port = 3309;
  static String userName = "Franck-Lionel";
  static String password = "Franck-Lionel007";
  static String databaseName = "micee";

  var conn;

  Future<dynamic> getConnexion() async {
    conn = null;
    try {
      // connexion string DB optional
      conn = await MySQLConnection.createConnection(
        host: host, port: port, userName: userName, password: password, databaseName: databaseName, secure: false, collation: 'utf8_general_ci'
      );
    } catch (e) {
      print("Erreur connexion : $e");
    }
    return await conn;
  }
}

// https://github.com/zim32/mysql.dart
// https://github.com/dongri727/sample_app_flutter_mysql8
      