// ignore_for_file: depend_on_referenced_packages, file_names, unused_local_variable, deprecated_member_use, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:micee/main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:micee/models/Userdatamodel.dart';
import 'package:micee/mysql/database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //final Utilisateur User = Utilisateur();
  //final Userdatamodel UserModel = Userdatamodel();
  final GlobalKey<FormState> _loginform = GlobalKey<FormState>();

  late bool submitlogin, submitpassword;
  late TextEditingController _loginController, _passwordController;

  final Sessiondata = GetStorage();
  final DBconnexionSql DB = DBconnexionSql();  

  @override
  void initState() {
    // implement initState
    super.initState();

    Sessiondata.erase(); Sessiondata.write('IsLogged', 0);

    _loginController = TextEditingController(); _passwordController = TextEditingController();
    submitlogin = false; _loginController.addListener(() { setState(() { submitlogin = _loginController.text.trim().isNotEmpty; }); });
    submitpassword = false; _passwordController.addListener(() { setState(() { submitpassword = _passwordController.text.trim().isNotEmpty; }); });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Login
    final loginField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _loginController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Login', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(FontAwesome.circle_user, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false, 
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Login incorrect' : null; },
      )
    );
  
    // PasswordField
    final passwordField = SizedBox(
      height: 32.5,
      child: TextFormField(              
        autofocus: false, controller: _passwordController,
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Password', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(FontAwesome.lock_solid, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: true, readOnly: false, 
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Password incorrect' : null; },
      )
    );

    // LoginButton
    final loginButton =  SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(IonIcons.log_in, size: 15, color: Colors.white),
        label: Text("CONNEXION", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),),
        onPressed: () async {
          if(submitlogin && submitpassword && _loginform.currentState!.validate()){
            final con = await DB.chechconn(); final List<String> conn = await DB.getparam();
            MainApp.hostController.text = conn[0]; MainApp.portController.text = conn[1]; MainApp.userController.text = conn[2]; 
            MainApp.passwordController.text = conn[3]; MainApp.dbController.text = conn[4]; MainApp.ceController.text = conn[5];
            if(con == false){
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Connexion à la base de données perdue.');
              });
              Future.delayed(const Duration(seconds: 5), () {
                showDialog(context: context, builder: (BuildContext context){
                  return MainApp.mysqldialog(Colors.white, MainApp.textwr, "CONNEXION A MYSQL", 
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton.icon( //ElevatedButton
                        icon: const Icon(LineAwesome.save, size: 15, color: MainApp.textwr),
                        label: Text("ENREGISTRER LE PARAMETRAGE", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: MainApp.textwr, fontWeight: FontWeight.bold, fontSize: 10.0),),
                        onPressed: () async {
                          if(MainApp.hostController.text.trim().isNotEmpty && MainApp.portController.text.trim().isNotEmpty && MainApp.userController.text.trim().isNotEmpty && 
                            MainApp.passwordController.text.trim().isNotEmpty && MainApp.dbController.text.trim().isNotEmpty && MainApp.ceController.text.trim().isNotEmpty && 
                            MainApp.mysqlform.currentState!.validate()) {
                            await DB.saveparam(MainApp.hostController.text.trim(), int.parse(MainApp.portController.text.trim()), MainApp.userController.text.trim(), 
                              MainApp.passwordController.text, MainApp.dbController.text.trim(), MainApp.ceController.text.trim()).then((val){
                              if(val.existsSync()){
                                showDialog(context: context, builder: (context){
                                  Future.delayed(const Duration(seconds: 3), () { Navigator.of(context).pop(true); });
                                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.success, '  Paramètres sauvegardés.');
                                });
                              } else {
                                showDialog(context: context, builder: (context){
                                  Future.delayed(const Duration(seconds: 3), () { Navigator.of(context).pop(true); });
                                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Impossible de sauver les paramètres.');
                                });
                              }
                            });
                          } else {
                            showDialog(context: context, builder: (context){
                              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                              return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainApp.gray, side: const BorderSide(color: MainApp.textwr, width: 1.5,),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
                        ),
                      )
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton.icon( //ElevatedButton
                        icon: const Icon(IonIcons.checkmark_done_circle, size: 15, color: Colors.white),
                        label: Text("TESTER LA CONNEXION", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),),
                        onPressed: () async {
                          if(MainApp.hostController.text.trim().isNotEmpty && MainApp.portController.text.trim().isNotEmpty && MainApp.userController.text.trim().isNotEmpty && 
                            MainApp.passwordController.text.trim().isNotEmpty && MainApp.dbController.text.trim().isNotEmpty && MainApp.ceController.text.trim().isNotEmpty && 
                            MainApp.mysqlform.currentState!.validate()) {
                            await DB.chechconn().then((val){
                              if(val == true){
                                showDialog(context: context, builder: (context){
                                  Future.delayed(const Duration(seconds: 3), () { Navigator.of(context).pop(true); });
                                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.success, '  Connexion à la base de données réussie.');
                                });
                                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                              } else {
                                showDialog(context: context, builder: (context){
                                  Future.delayed(const Duration(seconds: 3), () { Navigator.of(context).pop(true); });
                                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Connexion à la base de données échouée.');
                                });
                              }
                            });
                          } else {
                            showDialog(context: context, builder: (context){
                              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                              return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainApp.textwr, side: const BorderSide(color: MainApp.gray, width: 1.5,),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
                        ),
                      )
                    )
                  );
                });
              });
            }else{
              final u = await Userdatamodel.connect(_loginController.text.trim(), _passwordController.text.trim());
              if(u.runtimeType == String) {
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  $u');
                });
              } else if(u.runtimeType == List<Map<String, dynamic>>) {
                Sessiondata.write('IsLogged', 1); Sessiondata.write('Datas', u);
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bienvenu(e) ${_loginController.text}')),);
                Navigator.pushReplacementNamed(context, MainApp.dashboard);
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                  return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  Bienvenu(e) ${_loginController.text}.');
                });
              }
            }
          } else {
            showDialog(context: context, builder: (context){
              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
              return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.textwr, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // LinkButton Login / Password forget
    final linkButtonFLP = TextButton(
      onPressed: () {
        showDialog(context: context, builder: (context){
          Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
          return MainApp.msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Cette fonctionnalité est en cours de développement.');
        });
      },
      child: Text('Login ou Password oublié ?', style: MainApp.styleall.copyWith(fontSize: 12.5),),
    );

    // LinkButton register
    final linkButtonR = TextButton(
      onPressed: () {Navigator.pushNamed(context, MainApp.register);},
      child: Text('Inscrivez-vous ici', style: MainApp.styleall.copyWith(decoration: TextDecoration.underline, fontSize: 12.5),),
    );

    return Scaffold(
      /*appBar: AppBar(
        title: const Center(child: Text('Awesome AppBar')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [MainApp.bg, MainApp.bg1, MainApp.bg2, MainApp.bg3],
              stops: [0.2, 0.5, 0.8, 0.7], tileMode: TileMode.mirror,
            ),
          ),
        ),
      ),*/
      //resizeToAvoidBottomInset: false,
      //backgroundColor: const Color.fromARGB(255, 33, 116, 185),
      body: WindowBorder(
        color: Colors.white, width: 1.5,
        child: Column(
          children: [const CenterSide(), 
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight, end: Alignment.bottomLeft,
                    colors: [MainApp.navcolor2, MainApp.navcolor3],
                    stops: [0, 2], tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      //height: MediaQuery.of(context).size.height,
                      width: 320,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.textwr, width: 1.8), ),
                        shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
                          child: Form(
                            key: _loginform,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Logo
                                Container(
                                  alignment: Alignment.center, child: Image.asset('assets/user.png', fit:BoxFit.cover, height: 100, width: 100,),
                                ),
                                const SizedBox(height: 10,),

                                // Big Text
                                Text('AUTHENTIFICATION', style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                                const Divider(color: MainApp.textwr), const SizedBox(height: 20.0,),

                                loginField,  const SizedBox(height: 15.0),

                                passwordField, const SizedBox(height: 12.5),

                                linkButtonFLP, const SizedBox(height: 12.5,),

                                const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),
                                
                                loginButton, const SizedBox(height: 5.0,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}