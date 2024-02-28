// ignore_for_file: file_names, non_constant_identifier_names

class Utilisateur {
  final int? id;
  final String name;
  final int IdUser;
  final String Nom, Prenom, Login, Motdepasse, Adresse, Tel, Email; 
  final int Admin; 
  final String Ste, Fonction, Siret; 
  final String Psr, Precaire, Classique;
  final DateTime Datenaiss, Livetime, Creation; 
  final int Is2kfactor, IdRef;
  final dynamic docs; // documents

  // constructeur
  Utilisateur({this.id, required this.name, required this.IdUser, required this.Nom, required this.Prenom, required this.Login, required this.Motdepasse,
    required this.Adresse, required this.Tel, required this.Email, required this.Admin, required this.Ste, required this.Fonction, required this.Siret, 
    required this.Psr, required this.Precaire, required this.Classique, required this.Datenaiss, required this.Livetime, required this.Creation, 
    required this.Is2kfactor, required this.IdRef, this.docs
  });


  // methode
  Utilisateur.fromMap(Map<String, dynamic> map) :
    id = int.parse(map['id']), name = map['name'], IdUser = int.parse(map['IdUser']), Nom = map['Nom'], Prenom = map['Prenom'],
    Login = map['Login'], Motdepasse = map['Motdepasse'], Adresse = map['Adresse'], Tel = map['Tel'], Email = map['Email'], 
    Admin = int.parse(map['Admin']), Ste = map['Ste'], Fonction = map['Fonction'], Siret = map['Siret'], Psr = map['Psr'], 
    Precaire = map['Precaire'], Classique = map['Classique'], Datenaiss = DateTime.parse(map['Datenaiss']), Livetime = DateTime.parse(map['Livetime']), 
    Creation = DateTime.parse(map['Creation']), Is2kfactor = int.parse(map['Is2kfactor']), IdRef = int.parse(map['IdRef']), docs = map['docs'];

  // fonction
  Map<String, dynamic> toMap() {
    return {
      "id": id, "name": name, "IdUser": IdUser, "Nom": Nom, "Prenom": Prenom, "Login": Login, "Motdepasse": Motdepasse, "Adresse": Adresse, "Tel": Tel, 
      "Email": Email, "Admin": Admin, "Ste": Ste, "Fonction": Fonction, "Siret": Siret, "Psr": Psr, "Precaire": Precaire, "Classique": Classique, 
      "Datenaiss": Datenaiss, "Livetime": Livetime, "Creation": Creation, "Is2kfactor": Is2kfactor, "IdRef": IdRef, "docs": docs 
    };
  }

  @override
  String toString() {
    return '''Utilisateur { 
      id: $id, name: $name, IdUser: $IdUser, Nom: $Nom, Prenom: $Prenom, Login: $Login, Motdepasse: $Motdepasse, Adresse: $Adresse, Tel: $Tel, 
      Email: $Email, Admin: $Admin, Ste: $Ste, Fonction: $Fonction, Siret: $Siret, Psr: $Psr, Precaire: $Precaire, Classique: $Classique, 
      Datenaiss: $Datenaiss, Livetime: $Livetime, Creation: $Creation, Is2kfactor: $Is2kfactor, IdRef: $IdRef, docs: $docs; 
    ''';
  }
}
