// ignore_for_file: file_names

import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:xml/xml.dart' as xml;

class DBconnexionSql {
  // DB param
  // static String host = "10.0.2.2";  //when you use emulator like android
  // static String host = "10.0.2.15";  //when you use navigator like chrome
  // static String host = "127.0.0.1"; //when you use simulator like windows
  // static int port = 3309;
  // static String userName = "Franck-Lionel";
  // static String password = "Franck-Lionel007";
  // static String databaseName = "micee";
  // static String colation = "utf8_general_ci";

  static String host = '', userName = '', password = '', databaseName = '', colation = ''; static int port = 0;

  MySQLConnection? conn; PreparedStmt? stmt; IResultSet? results;

  /// initializes a connection to database
  Future<void> _getConnexion() async {
    final xmldoc = xml.XmlDocument.parse(File('assets/files/database.xml').readAsStringSync());
    final bdcon = xmldoc.findElements("configuration");
    for(final bd in bdcon){
      host = bd.findElements("Host").first.innerText;
      port = int.parse(bd.findElements("Port").first.innerText);
      userName = bd.findElements("User").first.innerText;
      password = bd.findElements("Pass").first.innerText;
      databaseName = bd.findElements("Database").first.innerText;
      colation = bd.findElements("Characterencoding").first.innerText;
    }
    conn = await MySQLConnection.createConnection(
      host: host, port: port, userName: userName, password: password, databaseName: databaseName, secure: false, collation: colation
    );
    // connected
    await conn?.connect();
  }

  /// check db connetion 
  Future<bool> chechconn() async {
    bool c = false;
    try{
      await _getConnexion();
      c = conn!.connected;
    }catch(e){
      // throw Exception(e); //we can add it in log file
    }
    return c;
  }

  /// save params
  Future<File> saveparam(String ht, int pt, String un, String pw, String db, String cn) async {
    return await File('assets/files/database.xml').writeAsString(
      "<?xml version='1.0' encoding='UTF-8'?>\n"
        "<configuration>\n"
          "\t<Host>$ht</Host>\n"
          "\t<Port>$pt</Port>\n"
          "\t<User>$un</User>\n"
          "\t<Pass>$pw</Pass>\n"
          "\t<Database>$db</Database>\n"
          "\t<Characterencoding>$cn</Characterencoding>\n"
        "</configuration>"
    );
  }

  /// get params
  Future<List<String>> getparam() async {
    final xmldoc = xml.XmlDocument.parse(File('assets/files/database.xml').readAsStringSync());
    final bdcon = xmldoc.findElements("configuration");
    List<String> datas = [];
    for(final bd in bdcon){
      datas.add(bd.findElements("Host").first.innerText);
      datas.add(bd.findElements("Port").first.innerText);
      datas.add(bd.findElements("User").first.innerText);
      datas.add(bd.findElements("Pass").first.innerText);
      datas.add(bd.findElements("Database").first.innerText);
      datas.add(bd.findElements("Characterencoding").first.innerText);
    }
    return datas;
  }

  /// execute a given query and checks for db connection
  Future<IResultSet?> getResults(String query, List<dynamic>? params,) async {
    await _getConnexion();
    if(conn!.connected){
      // prepare
      stmt = await conn?.prepare(query);
      // execute
      results = await stmt?.execute(params!);
      // deal
      await stmt?.deallocate();
      // closed
      await conn?.close();
    }
    return results;
  }
}

// https://github.com/zim32/mysql.dart
// https://github.com/dongri727/sample_app_flutter_mysql8
      