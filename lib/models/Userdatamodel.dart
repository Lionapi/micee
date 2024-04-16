// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:micee/main.dart';
import 'package:micee/random/randomcode.dart';
import 'package:micee/bo/Userdata.dart';

class Userdatamodel {
  static String table_name = "usersdata";
  static final RandomCode Rc = RandomCode();
  static Map<String, dynamic> ud = {};
  static String datadoc =  "<Doc><IdDoc>0</IdDoc><Msg>...</Msg><StatutDoc><Encours>0</Encours><Complement>0</Complement><Instruction>0</Instruction><Decision>0</Decision></StatutDoc><AnaTech>0</AnaTech><AnaAdmin>0</AnaAdmin><ComTech>0</ComTech><ComAdmin>0</ComAdmin><Prime>0</Prime><Synthese>0</Synthese></Doc>";

  static String formaterxmldata(BigInt id, String nom, String prenom, String login, String mdp, String ad, String tel, String mail,
    BigInt admin, String ste, String fct, String sir, String psr, String pre, String cla, String dd, DateTime dn, DateTime lt, DateTime cre, DateTime mdf, BigInt is2k, BigInt idr) {
    return "<?xml version='1.0' encoding='UTF-8'?>"
      "<utilisateur>"
        "<IdUser>$id</IdUser><Nom>$nom</Nom><Prenom>$prenom</Prenom><Login>$login</Login><Motdepasse>${Rc.encryptAESQr(mdp, 'MiCee', '01122024')}</Motdepasse><Adresse>$ad</Adresse><Tel>$tel</Tel><Email>$mail</Email>"
        "<Statut>"
          "<Admin>$admin</Admin>"
          "<Entreprise><Ste>$ste</Ste><Fonction>$fct</Fonction><Siret>$sir</Siret></Entreprise>"
          "<Particulier><Psr>$psr</Psr><Precaire>$pre</Precaire><Classique>$cla</Classique></Particulier>"
        "</Statut>"
        "<Dossiers>"
          "$dd"
        "</Dossiers>"
        "<Datenaiss>$dn</Datenaiss><Livetime>$lt</Livetime><Creation>$cre</Creation><Modification>$mdf</Modification><Is2kfactor>$is2k</Is2kfactor><IdRef>$idr</IdRef>"
      "</utilisateur>";
  }

  static String docforxmldata(BigInt docid, String msg, int en, int cp, int ins, int dec, String at, String aa, String ct, String ca, double pr, String sy, DateTime cre, DateTime mdf) {
    return
      "<Doc>"
        "<IdDoc>$docid</IdDoc><Msg>$msg</Msg>"
        "<StatutDoc>"
          "<Encours>$en</Encours><Complement>$cp</Complement><Instruction>$ins</Instruction><Decision>$dec</Decision>"
        "</StatutDoc>"
        "<AnaTech>$at</AnaTech><AnaAdmin>$aa</AnaAdmin><ComTech>$ct</ComTech><ComAdmin>$ca</ComAdmin><Prime>$pr</Prime><Synthese>$sy</Synthese>"
        "<Creation>$cre</Creation><Modification>$mdf</Modification>"
      "</Doc>";
  }

  static Map<String, dynamic> mapxmldata(xmldata) {
    final xmldoc = xml.XmlDocument.parse(xmldata);
    final user = xmldoc.findElements("utilisateur");
    for (final u in user) {
      ud.addEntries({"IdUser": u.findElements("IdUser").first.innerText}.entries);
      ud.addEntries({"Nom": u.findElements("Nom").first.innerText}.entries);
      ud.addEntries({"Prenom": u.findElements("Prenom").first.innerText}.entries);
      ud.addEntries({"Login": u.findElements("Login").first.innerText}.entries);
      ud.addEntries({"Motdepasse": u.findElements("Motdepasse").first.innerText}.entries);
      ud.addEntries({"Adresse": u.findElements("Adresse").first.innerText}.entries);
      ud.addEntries({"Tel": u.findElements("Tel").first.innerText}.entries);
      ud.addEntries({"Email": u.findElements("Email").first.innerText}.entries);

      for (final s in u.findElements("Statut")) {
        ud.addEntries({"Admin": u.findElements("Statut").first.findElements("Admin").first.innerText}.entries);
        ud.addEntries({"Ste": s.findElements("Entreprise").first.findElements("Ste").first.innerText}.entries);
        ud.addEntries({"Fonction": s.findElements("Entreprise").first.findElements("Fonction").first.innerText}.entries);
        ud.addEntries({"Siret": s.findElements("Entreprise").first.findElements("Siret").first.innerText}.entries);
        ud.addEntries({"Psr": s.findElements("Particulier").first.findElements("Psr").first.innerText}.entries);
        ud.addEntries({"Precaire": s.findElements("Particulier").first.findElements("Precaire").first.innerText}.entries);
        ud.addEntries({"Classique": s.findElements("Particulier").first.findElements("Classique").first.innerText}.entries);
      }

      ud.addEntries({"Datenaiss": u.findElements("Datenaiss").first.innerText}.entries);
      ud.addEntries({"Livetime": u.findElements("Livetime").first.innerText}.entries);
      ud.addEntries({"Creation": u.findElements("Creation").first.innerText}.entries);
      ud.addEntries({"Modification": u.findElements("Modification").first.innerText}.entries);
      ud.addEntries({"Is2kfactor": u.findElements("Is2kfactor").first.innerText}.entries);
      ud.addEntries({"IdRef": u.findElements("IdRef").first.innerText}.entries);
    }
    return ud;
  }

  // use to get & update docs
  static Map<String, dynamic> mapxmldocdata(xmldata) {
    final xmldoc = xml.XmlDocument.parse(xmldata);
    final user = xmldoc.findElements("utilisateur");
    for (final u in user) {
      for (final d in u.findElements("Dossiers")) {
        ud.addEntries({"docs": d.findElements("Doc").toList()}.entries);
      }
    }
    return ud;
  }

  // use to see each docs
  static Map<String, dynamic> docdata(xmldata) {
    final xmldoc = xml.XmlDocument.parse(xmldata);
    final Xml2Json xml2Json = Xml2Json();
    final user = xmldoc.findElements("utilisateur");
    for (final u in user) {
      xml2Json.parse(u.findElements("Dossiers").toString());
      if(jsonDecode(xml2Json.toParker())['Dossiers'] != null){
        if(jsonDecode(xml2Json.toParker())['Dossiers']['Doc'].runtimeType.toString() != 'List<dynamic>') {
          ud.addEntries({"docs": [jsonDecode(xml2Json.toParker())['Dossiers']['Doc']]}.entries);
        } else {
          ud.addEntries({"docs": jsonDecode(xml2Json.toParker())['Dossiers']['Doc']}.entries);
        }
      }else{
        ud.addEntries({"docs": []}.entries);
      }
    }
    //print(ud);
    return ud;
  }

  // connexion
  static Future<dynamic> connect(String log, String mdp) async {
    final response = await http.post(Uri.parse("http://192.168.1.182:81/api/connect_userdata.php"), 
      body: jsonEncode(<String, String> { "Login": log, "Motdepasse": Rc.encryptAESQr(mdp, 'MiCee', '01122024') }),
    );
    List<Map<String, dynamic>> user = []; ud = {};
    if (response.statusCode == 200) {
      if(response.body == "Compte ou Mot de passe incorrect."){
        return response.body;
      } else {
        ud = {};
        ud.addEntries({"id": jsonDecode(response.body)[0]['id']}.entries);
        ud.addEntries({"name": jsonDecode(response.body)[0]['name']}.entries);
        mapxmldata(jsonDecode(response.body)[0]['xmlcontent']);
        user.add(ud);
        return user;
      }
    } else {
      return ('Request failed with status: ${response.statusCode}.');
    }
  }

  // create userdata
  static Future<dynamic> createUser(String name, String xlmcontent) async {
    final response = await http.post(Uri.parse("http://192.168.1.182:81/api/create_userdata.php"),
      body: jsonEncode(<String, String> { "name": name, "xmlcontent": xlmcontent }),
    );
    if (response.statusCode == 200) {
      if (response.body == "userdata was created.") {
        return "Utilisateur ajouté.";
      } else {
        return "Impossible d'ajouter l'utilisateur.";
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  // get all usersdata
  static Future<List<Utilisateur>> getAllUsers() async {
    final response = await http.get(Uri.parse("http://192.168.1.182:81/api/read_userdata.php"));
    final List<Map<String, dynamic>> users = []; MainApp.useroption.clear();
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['records'].length > 0){
        for(int i = 0; i < jsonDecode(response.body)['records'].length; i++){
          MainApp.useroption.add("${jsonDecode(response.body)['records'][i]['name']} ~ ${jsonDecode(response.body)['records'][i]['id']}");
          ud = {}; 
          ud.addEntries({"id": jsonDecode(response.body)['records'][i]['id']}.entries);
          ud.addEntries({"name": jsonDecode(response.body)['records'][i]['name']}.entries);
          mapxmldata(jsonDecode(response.body)['records'][i]['xmlcontent']);
          docdata(jsonDecode(response.body)['records'][i]['xmlcontent']);
          users.add(ud);
        }
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
    //print(users);
    return users.map((e) => Utilisateur.fromMap(e)).toList();
  }

  // get one userdata
  static Future<Utilisateur> getOneUser(BigInt id) async {
    final response = await http.post(Uri.parse("http://192.168.1.182:81/api/read_one_userdata.php"),
      body: jsonEncode(<String, dynamic> { "id": id.toString(), }),
    );
    final List<Map<String, dynamic>> user = [];
    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length == 1){
        ud = {};
        ud.addEntries({"id": jsonDecode(response.body)[0]['id']}.entries);
        ud.addEntries({"name": jsonDecode(response.body)[0]['name']}.entries);
        mapxmldata(jsonDecode(response.body)[0]['xmlcontent']);
        mapxmldocdata(jsonDecode(response.body)[0]['xmlcontent']);
        user.add(ud);
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
    return user.map((e) => Utilisateur.fromMap(e)).first;
  }

  // update userdata
  static Future<dynamic> updateUser(BigInt id, String name, String xlmcontent) async {
    final response = await http.post(Uri.parse("http://192.168.1.182:81/api/update_userdata.php"),
      body: jsonEncode(<String, dynamic> { "id": id.toString(), "name": name, "xmlcontent": xlmcontent }),
    );
    if (response.statusCode == 200) {
      if (response.body == "userdata was updated.") {
        return "Utilisateur modifié.";
      } else {
        return "Impossible de modifier l'utilisateur.";
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  // delete userdata
  static Future<dynamic>deleteUser(BigInt id) async {
    final response = await http.post(Uri.parse("http://192.168.1.182:81/api/delete_userdata.php"),
      body: jsonEncode(<String, dynamic> { "id": id.toString() }),
    );
    if (response.statusCode == 200) {
      if (response.body == "userdata was deleted.") {
        return "Utilisateur supprimé.";
      } else {
        return "Impossible de supprimer l'utilisateur.";
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  // Search a user from collection
  static Future<List<Utilisateur>> searchData (List<Utilisateur> lu, String s) async {
    return lu.where((u) => u.name.toLowerCase().contains(s.toLowerCase()) || u.Nom.toLowerCase().contains(s.toLowerCase())
      //|| u.id.toString().contains(s) || u.IdUser.toString().contains(s) || u.Motdepasse.toLowerCase().contains(s.toLowerCase()) || u.Admin.toString().contains(s)
      || u.Prenom.toLowerCase().contains(s.toLowerCase()) || u.Login.toLowerCase().contains(s.toLowerCase())
      || u.Adresse.toLowerCase().contains(s.toLowerCase()) || u.Tel.toLowerCase().contains(s.toLowerCase())
      || u.Email.toLowerCase().contains(s.toLowerCase()) || u.Ste.toLowerCase().contains(s.toLowerCase())
      || u.Fonction.toLowerCase().contains(s.toLowerCase()) || u.Siret.toLowerCase().contains(s.toLowerCase())
      || u.Psr.toLowerCase().contains(s.toLowerCase()) || u.Precaire.toLowerCase().contains(s.toLowerCase())
      || u.Classique.toLowerCase().contains(s.toLowerCase()) || u.Datenaiss.toString().contains(s)
      || u.Livetime.toString().contains(s) || u.Creation.toString().contains(s)
      || u.Is2kfactor.toString().contains(s) || u.IdRef.toString().contains(s)
    ).toList();
  }

  //
  /*String platform = "";
  if(kIsWeb) {
    platform = getOSInsideWeb();
  }

  String getOSInsideWeb() {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    if( userAgent.contains("iphone"))  return "ios";
    if( userAgent.contains("ipad")) return "ios";
    if( userAgent.contains("android"))  return "Android";
    return "Web";
  }*/
}
