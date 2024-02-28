// ignore_for_file: depend_on_referenced_packages, file_names, unused_local_variable, deprecated_member_use, non_constant_identifier_names, unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:micee/main.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';
//import 'package:games/models/Utilisateur_model_sql.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  //final Utilisateur User = Utilisateur();
  final GlobalKey<FormState> _registerform = GlobalKey<FormState>();

  late bool submitnom, submitprenom, submithbd, submitemail, submitlogin, submitpassword, submitcpassword; 
  late dynamic submitphone;

  late TextEditingController _nomController, _prenomController, _hbdController, _emailController, _loginController,
  _passwordController, _cpasswordController;
  late PhoneController _phoneController;

  @override
  void initState() {
    // implement initState
    super.initState();

    _nomController = TextEditingController(); _prenomController = TextEditingController(); _hbdController = TextEditingController();
    _emailController = TextEditingController(); _phoneController = PhoneController(null);
    _loginController = TextEditingController(); _passwordController = TextEditingController(); _cpasswordController = TextEditingController();

    submitnom = false;  _nomController.addListener(() { setState(() { submitnom = _nomController.text.trim().isNotEmpty; }); });
    submitprenom = false; _prenomController.addListener(() { setState(() { submitprenom = _prenomController.text.trim().isNotEmpty; }); });
    submithbd = false; _hbdController.addListener(() { setState(() { submithbd = _hbdController.text.trim().isNotEmpty; }); });
    submitemail = false; _emailController.addListener(() { setState(() { submitemail = _emailController.text.trim().isNotEmpty; }); });
    submitphone = null; _phoneController.addListener(() { setState(() { submitphone = _phoneController.value; }); });
    submitlogin = false; _loginController.addListener(() { setState(() { submitlogin = _loginController.text.trim().isNotEmpty; }); });
    submitpassword = false; _passwordController.addListener(() { setState(() { submitpassword = _passwordController.text.trim().isNotEmpty; }); });
    submitcpassword = false; _cpasswordController.addListener(() { setState(() { submitcpassword = _cpasswordController.text.trim().isNotEmpty; }); });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nomController.dispose(); _prenomController.dispose(); _loginController.dispose(); _hbdController.dispose(); _emailController.dispose();
    /*_phoneController.dispose();*/ _passwordController.dispose(); _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom msgbox
    AlertDialog msg (Color bg, ico, Color c, String s) {
      return AlertDialog(
        //actions: [ MaterialButton(color: Colors.white, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        backgroundColor: bg,
        content: RichText(
          text: TextSpan( children: [ WidgetSpan(child: Icon(ico, color: c, size: 20,),), TextSpan(text: s, style: const TextStyle(color: Colors.white)), ], ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
        //title: const Text("AUTHENTIFICATION", style: TextStyle(color: Color.fromARGB(255, 33, 116, 185), decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
      );
    }

    // Custom calendar theme
    ThemeData Ctheme () {
      return ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark( onPrimary: Colors.black, onSurface: Colors.white, primary: Colors.white ),
        dialogBackgroundColor: const Color.fromARGB(250, 0, 0, 0),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12, fontFamily: 'Roboto'),
            foregroundColor: Colors.white, backgroundColor: Colors.black, 
            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white, width: 1.2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(5)),
          ),
        ),
      );
    }

    // Nom
    final nomField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _nomController,                 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Nom', suffixIcon: const Icon(LineAwesome.user_alt_solid, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Nom incorrect' : null; },
      )
    );

    // Prenom
    final prenomField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _prenomController,                 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Prénom', suffixIcon: const Icon(LineAwesome.user_alt_solid, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Prénom incorrect' : null; },
      )
    );

    // Hbd
    final hbdField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _hbdController,                 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Date de naissance', suffixIcon: const Icon(EvaIcons.calendar_outline, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false,
        onTap: () async { 
          DateTime? dt = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(DateTime.now().year - 60), lastDate: DateTime(DateTime.now().year - 18),
            locale : const Locale("fr","FR"),
            builder: (context, child) {
              return Theme(data: Ctheme(), child: child!,);
            }
          ); 
          if(dt != null){ setState(() { _hbdController.text = DateFormat('yyyy-MM-dd').format(dt); }); }
        },
        readOnly: true, style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Date de naissance incorrect' : null; },
      )
    );

    // Email
    final emailField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _emailController,                 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Email', suffixIcon: const Icon(EvaIcons.email_outline, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.emailAddress, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (EmailValidator.validate(value!) || value.isEmpty) ?  'Email incorrect' : null; },
      )
    );

    // Phone
    final phoneField = SizedBox(
      height: 32.5,
      child: PhoneFormField(
        autofillHints: const [AutofillHints.telephoneNumber],
        autofocus: false, autocorrect: false, controller: _phoneController,
        countrySelectorNavigator: const CountrySelectorNavigator.dialog(width: 325, height: 500, ),               
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Portable', suffixIcon: const Icon(LineAwesome.phone_solid, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        flagSize: 16, defaultCountry : IsoCode.FR,
        enabled: true, enableSuggestions: false, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.phone, obscureText: false, /*readOnly: false,*/
        style: MainApp.styleall.copyWith(), //toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: PhoneValidator.none, //PhoneValidator.compose([PhoneValidator.required(errorText: 'Portable incorrect'), PhoneValidator.validMobile()]),
      )
    );

    // Login
    final loginField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _loginController,                 
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Login', suffixIcon: const Icon(FontAwesome.circle_user, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Login incorrect' : null; },
      )
    );

    // PasswordField
    final passwordField = SizedBox(
      height: 32.5,
      child: TextFormField(              
        autofocus: false, controller: _passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Password', suffixIcon: const Icon(FontAwesome.lock_solid, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: true, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Password incorrect' : null; },
      )
    );

    // cPasswordField
    final cpasswordField = SizedBox(
      height: 32.5,
      child: TextFormField(              
        autofocus: false, controller: _cpasswordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          labelText: 'Confirm Password', suffixIcon: const Icon(FontAwesome.lock_solid, size: 18,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: true, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Confirm Password incorrect' : null; },
      )
    );

    // RegisterButton
    final registerButton = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(LineAwesome.save, size: 15, color: Colors.white),
        label: Text("ENREGISTRER", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),),
        onPressed: () {
          if(submitnom && submitprenom && submithbd && submitemail && submitphone != null && submitlogin && submitpassword && submitcpassword /*&& _registerform.currentState!.validate()*/){
            if(EmailValidator.validate(_emailController.text)){
              if(_phoneController.value!.isValid(type: PhoneNumberType.mobile) || _phoneController.value!.isValid(type: PhoneNumberType.fixedLine)){
                if(MainApp.regexp.hasMatch(_passwordController.text.trim()) && MainApp.regexp.hasMatch(_cpasswordController.text.trim())){
                  if(_passwordController.text.trim().compareTo(_cpasswordController.text.trim()) == 0){
                    /*// constructor for login
                    Utilisateur User = Utilisateur.Userconnect(_loginController.text.trim(), _passwordController.text.trim());
                    // login
                    User.Connect().then((res) {
                      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bienvenu(e) ${_loginController.text}')),);
                      showDialog(context: context, builder: (context){
                        Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                        if(res.runtimeType == String){
                          return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  $res');
                        }else{
                          if(res.length > 0){
                            //Navigator.pushReplacementNamed(context, '/dashboard');
                            return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle_sharp, MainApp.success, '  Bienvenu(e) ${_loginController.text}');
                          }else{
                            return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Login ou Password incorrect(s).');
                          }
                        }
                      });
                    });*/
                  }else{
                    showDialog(context: context, builder: (context){
                      Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Passwords non identiques.');
                    });
                  }
                }else{
                  showDialog(context: context, builder: (context){
                    Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                    return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Password exemple "Aaaa0@".');
                  });
                }
              }else{
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                  return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, ' Portable incorrect.');
                });
              }
            }else{
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Email incorrect.');
              });
            }
          } else {
            showDialog(context: context, builder: (context){
              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.warning, MainApp.warning, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(5, 255, 255, 255), side: const BorderSide(color: Colors.white, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // LinkButton login
    final linkButtonL = TextButton(
      onPressed: () {Navigator.pushNamed(context, MainApp.login);},
      child: Text('Authentifiez-vous ici', style: MainApp.styleall.copyWith(decoration: TextDecoration.underline, fontSize: 12.5),),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight, end: Alignment.bottomLeft,
            colors: [MainApp.bg, MainApp.bg2],
            stops: [0, 2], tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              //height: MediaQuery.of(context).size.height,
              width: 370,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Colors.white, width: 1.8), ),
                shadowColor: Colors.transparent, color: const Color.fromARGB(15, 255, 255, 255), elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
                  child: Form(
                    key: _registerform,
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
                        Text('INSCRIPTION', style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                        const Divider(color: Colors.white), const SizedBox(height: 20.0,),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // Nom // Prénom
                          children: [Flexible( child: nomField), const SizedBox(width: 8,), Flexible(child: prenomField),]
                        ), const SizedBox(height: 15.0),

                        hbdField, const SizedBox(height: 15.0),

                        emailField, const SizedBox(height: 15.0),

                        phoneField, const SizedBox(height: 15.0),

                        loginField, const SizedBox(height: 15.0),

                        passwordField, const SizedBox(height: 15.0),

                        cpasswordField, const SizedBox(height: 20.0),

                        const Divider(color: Colors.white), const SizedBox(height: 20.0,),

                        registerButton, const SizedBox(height: 5.0,),

                        linkButtonL,                
                      ]
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}