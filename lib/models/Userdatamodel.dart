// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:micee/random/randomcode.dart';
import 'package:micee/bo/Userdata.dart';

class Userdatamodel {
  static final RandomCode Rc = RandomCode();
  static Map<String, dynamic> ud = {};
  static String datadoc =  "<Doc>\\r\\n<IdDoc>0</IdDoc>\\r\\n<Msg>...</Msg>\\r\\n<StatutDoc>\\r\\n<Encours>0</Encours>\\r\\n<Complement>0</Complement>\\r\\n<Instruction>0</Instruction>\\r\\n<Decision>0</Decision>\\r\\n</StatutDoc>\\r\\n<AnaTech>0</AnaTech>\\r\\n<AnaAdmin>0</AnaAdmin>\\r\\n<ComTech>0</ComTech>\\r\\n<ComAdmin>0</ComAdmin>\\r\\n<Prime>0</Prime>\\r\\n<Synthese>0</Synthese>\\r\\n</Doc>\\r\\n";
  List<String> useroption = [];

  String formaterxmldata(int id, String nom, String prenom, String login, String mdp, String ad, String tel, String mail,
    int admin, String ste, String fct, String sir, String psr, String pre, String cla, String dd, DateTime dn, DateTime lt, DateTime cre, int is2k, int idr) {
    return "<?xml version='1.0' encoding='UTF-8'?>\\r\\n"
      "<utilisateur>\\r\\n"
        "<IdUser>$id</IdUser>\\r\\n<Nom>$nom</Nom>\\r\\n<Prenom>$prenom</Prenom>\\r\\n<Login>$login</Login>\\r\\n<Motdepasse>${Rc.encryptAESQr(mdp, 'MiCee', '01122024')}</Motdepasse>\\r\\n<Adresse>$ad</Adresse>\\r\\n<Tel>$tel</Tel>\\r\\n<Email>$mail</Email>\\r\\n"
        "<Statut>\\r\\n"
          "<Admin>$admin</Admin>\\r\\n"
          "<Entreprise>\\r\\n<Ste>$ste</Ste>\\r\\n<Fonction>$fct</Fonction>\\r\\n<Siret>$sir</Siret>\\r\\n</Entreprise>\\r\\n"
          "<Particulier>\\r\\n<Psr>$psr</Psr>\\r\\n<Precaire>$pre</Precaire>\\r\\n<Classique>$cla</Classique>\\r\\n</Particulier>\\r\\n"
        "</Statut>\\r\\n"
        "<Dossiers>\\r\\n"
          "$dd"
        "</Dossiers>\\r\\n"
        "<Datenaiss>$dn</Datenaiss>\\r\\n<Livetime>$lt</Livetime>\\r\\n<Creation>$cre</Creation>\\r\\n<Is2kfactor>$is2k</Is2kfactor>\\r\\n<IdRef>$idr</IdRef>\\r\\n"
      "</utilisateur>";
  }

  String docforxmldata(int docid, String msg, int en, int cp, int ins, int dec, String at, String aa, String ct, String ca, double pr, String sy) {
    datadoc = '';
    datadoc +=  "<Doc>\\r\\n"
                  "<IdDoc>$docid</IdDoc>\\r\\n<Msg>$msg</Msg>\\r\\n"
                  "<StatutDoc>\\r\\n"
                    "<Encours>$en</Encours>\\r\\n<Complement>$cp</Complement>\\r\\n<Instruction>$ins</Instruction>\\r\\n<Decision>$dec</Decision>\\r\\n"
                  "</StatutDoc>\\r\\n"
                  "<AnaTech>$at</AnaTech>\\r\\n<AnaAdmin>$aa</AnaAdmin>\\r\\n<ComTech>$ct</ComTech>\\r\\n<ComAdmin>$ca</ComAdmin>\\r\\n<Prime>$pr</Prime>\\r\\n<Synthese>$sy</Synthese>\\r\\n"
                "</Doc>\\r\\n";
    return datadoc;
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
  Future<dynamic> connect(String log, String mdp) async {
    final response = await http.post(Uri.parse("http://localhost:8080/api/connect_userdata.php"), //Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'})
      //headers: <String, String> {"Access-Control-Allow-Origin": "*", "Content-Type": "application/json; charset=UTF-8",},
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
  Future<dynamic> createUser(String name, String xlmcontent) async {
    final response = await http.post(Uri.parse("http://localhost:8080/api/create_userdata.php"),
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
  Future<List<Utilisateur>> getAllUsers() async {
    final response = await http.get(Uri.parse("http://localhost:8080/api/read_userdata.php"));
    final List<Map<String, dynamic>> users = []; useroption = [];
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['records'].length > 0){
        for(int i = 0; i < jsonDecode(response.body)['records'].length; i++){
          useroption.add("${jsonDecode(response.body)['records'][i]['name']} ~ ${jsonDecode(response.body)['records'][i]['id']}");
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
  Future<Utilisateur> getOneUser(int id) async {
    final response = await http.post(Uri.parse("http://localhost:8080/api/read_one_userdata.php"),
      body: jsonEncode(<String, int> { "id": id, }),
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
  Future<dynamic> updateUser(int id, String name, String xlmcontent) async {
    final response = await http.post(Uri.parse("http://localhost:8080/api/update_userdata.php"),
      body: jsonEncode(<String, dynamic> { "id": id, "name": name, "xmlcontent": xlmcontent }),
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
  Future<dynamic>deleteUser(int id) async {
    final response = await http.post(Uri.parse("http://localhost:8080/api/delete_userdata.php"),
      body: jsonEncode(<String, dynamic> { "id": id }),
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
  Future<List<Utilisateur>> searchData (List<Utilisateur> lu, String s) async {
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
