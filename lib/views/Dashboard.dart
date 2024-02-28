// ignore_for_file: depend_on_referenced_packages, file_names, deprecated_member_use, non_constant_identifier_nameseasy_sidemenu, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';
import 'package:micee/main.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart'; // https://github.com/Jamalianpour/easy_sidemenu/pull/58/commits/e64aa68e0141a2d93e0c92ef2b2080917aa4c41f => correctif du bug
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:select_field/select_field.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:download/download.dart';
import 'package:path_provider/path_provider.dart';
import 'package:micee/bo/Userdata.dart';
import 'package:micee/models/Userdatamodel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final GlobalKey<FormState> _userform = GlobalKey<FormState>();
  final GlobalKey<FormState> _userdelform = GlobalKey<FormState>();
  final GlobalKey<FormState> _folderform = GlobalKey<FormState>();
  final GlobalKey<FormState> _folderdelform = GlobalKey<FormState>();

  late bool submitnom, submitprenom, submithbd, submitemail, submitaddress, submitlogin, submitpassword, submitcpassword, 
  submitstatut, submitnomste, submitfctste, submitsiretste, submitpsr, submitpre, submitcla,
  submituser, submitnomfichier, submitstatutdoc, submitanatech, submitanaad, submitcomtech, submitcomad, submitprime, submitsyn; 
  late dynamic submitphone;

  late TextEditingController _nomController, _prenomController, _hbdController, _emailController, _addressController, 
  _loginController, _passwordController, _cpasswordController, _statutController, _nomsteController, _fctsteController, 
  _siretsteController, _psrController, _preController, _claController,
  _userController, _nomfichierController, _statutdocController, _anatechController, _anaadController, _comtechController, 
  _comadController, _primeController, _synController,
  _searchuserController, _searchfolderController;
  late PhoneController _phoneController;
  
  SideMenuController sideMenu = SideMenuController();
  PageController pageController = PageController();

  PdfViewerController pdfc = PdfViewerController();

  Userdatamodel UserModel = Userdatamodel();
  late Future<List<Utilisateur>> futuredata, ncdata, nddata, fddata; 
  late List<Utilisateur> sfudata, sfddata;
  String? selectedValue; final List<String> selectoption = <String>['Entreprise', 'Particulier'], pdffile = [];
  FilePickerResult? filePickerResult;
  late int id, rel, iddoc; late double hsd; late dynamic docts;
  late bool en, prt;

  final Sessiondata = GetStorage();

  @override
  void initState() {
    // implement initState
    super.initState();

    _nomController = TextEditingController(); _prenomController = TextEditingController(); _hbdController = TextEditingController();
    _emailController = TextEditingController(); _addressController = TextEditingController(); _phoneController = PhoneController(null);
    _loginController = TextEditingController(); _passwordController = TextEditingController(); _cpasswordController = TextEditingController();
    _statutController = TextEditingController(); _nomsteController = TextEditingController(); _fctsteController = TextEditingController(); 
    _siretsteController = TextEditingController(); _psrController = TextEditingController(); _preController = TextEditingController(); 
    _claController = TextEditingController();

    _userController = TextEditingController(); _nomfichierController = TextEditingController(); _statutdocController = TextEditingController(); 
    _anatechController = TextEditingController(); _anaadController = TextEditingController(); _comtechController = TextEditingController(); 
    _comadController = TextEditingController(); _primeController = TextEditingController(); _synController = TextEditingController();

    submitnom = false; _nomController.addListener(() { setState(() { submitnom = _nomController.text.trim().isNotEmpty; }); });
    submitprenom = false; _prenomController.addListener(() { setState(() { submitprenom = _prenomController.text.trim().isNotEmpty; }); });
    submithbd = false; _hbdController.addListener(() { setState(() { submithbd = _hbdController.text.trim().isNotEmpty; }); });
    submitemail = false; _emailController.addListener(() { setState(() { submitemail = _emailController.text.trim().isNotEmpty; }); });
    submitaddress = false; _addressController.addListener(() { setState(() { submitaddress = _addressController.text.isNotEmpty; }); });
    submitphone = null; _phoneController.addListener(() { setState(() { submitphone = _phoneController.value; }); });
    submitlogin = false; _loginController.addListener(() { setState(() { submitlogin = _loginController.text.trim().isNotEmpty; }); });
    submitpassword = false; _passwordController.addListener(() { setState(() { submitpassword = _passwordController.text.trim().isNotEmpty; }); });
    submitcpassword = false; _cpasswordController.addListener(() { setState(() { submitcpassword = _cpasswordController.text.trim().isNotEmpty; }); });
    submitnomste = false;  _nomsteController.addListener(() { setState(() { submitnomste = _nomsteController.text.trim().isNotEmpty; }); });
    submitfctste = false;  _fctsteController.addListener(() { setState(() { submitfctste = _fctsteController.text.trim().isNotEmpty; }); });
    submitsiretste = false;  _siretsteController.addListener(() { setState(() { submitsiretste = _siretsteController.text.trim().isNotEmpty; }); });
    submitpsr = false;  _psrController.addListener(() { setState(() { submitpsr = _psrController.text.trim().isNotEmpty; }); });
    submitpre = false;  _preController.addListener(() { setState(() { submitpre = _preController.text.trim().isNotEmpty; }); });
    submitcla = false;  _claController.addListener(() { setState(() { submitcla = _claController.text.trim().isNotEmpty; }); });
    submitstatut = false;  _statutController.addListener(() { setState(() { submitstatut = _statutController.text.trim().isNotEmpty; }); });
    
    submituser = false;  _userController.addListener(() { setState(() { submituser = _userController.text.trim().isNotEmpty; }); });
    submitnomfichier = false; _nomfichierController.addListener(() { setState(() { submitnomfichier = _nomfichierController.text.trim().isNotEmpty; }); });
    submitstatutdoc = false;  _statutdocController.addListener(() { setState(() { submitstatutdoc = _statutdocController.text.trim().isNotEmpty; }); });
    submitanatech = false; _anatechController.addListener(() { setState(() { submitanatech = _anatechController.text.trim().isNotEmpty; }); });
    submitanaad = false; _anaadController.addListener(() { setState(() { submitanaad = _anaadController.text.trim().isNotEmpty; }); });
    submitcomtech = false; _comtechController.addListener(() { setState(() { submitcomtech = _comtechController.text.trim().isNotEmpty; }); });
    submitcomad = false; _comadController.addListener(() { setState(() { submitcomad = _comadController.text.trim().isNotEmpty; }); });
    submitprime = false; _primeController.addListener(() { setState(() { submitprime = _primeController.text.trim().isNotEmpty; }); });
    submitsyn = false; _synController.addListener(() { setState(() { submitsyn = _synController.text.trim().isNotEmpty; }); });

    if(Sessiondata.read("IsLogged") == 0){
      Navigator.pushReplacementNamed(context, MainApp.login);
    } else {
      Future.delayed(Duration.zero,(){ sideMenu.addListener((index) { pageController.jumpToPage(index); }); });
      futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null; hsd = 40.5;
      _searchuserController = TextEditingController(); _searchfolderController = TextEditingController();
      en = false; prt = false;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nomController.dispose(); _prenomController.dispose(); _loginController.dispose(); _hbdController.dispose(); _emailController.dispose();
    /*_phoneController.dispose();*/ _addressController.dispose(); _passwordController.dispose(); _cpasswordController.dispose(); 
    _statutController.dispose(); _nomsteController.dispose(); _fctsteController.dispose(); _siretsteController.dispose(); 
    _psrController.dispose(); _preController.dispose(); _claController.dispose();

    _userController.dispose(); _nomfichierController.dispose(); _statutdocController.dispose(); _anatechController.dispose(); _anaadController.dispose();
    _comtechController.dispose(); _comadController.dispose(); _comadController.dispose(); _primeController.dispose(); _synController.dispose();

    pageController.dispose(); _searchuserController.dispose(); _searchfolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom calendar theme
    ThemeData Ctheme () {
      return ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark( onPrimary: Colors.black, onSurface: Colors.white, primary: Colors.white ), dialogBackgroundColor: const Color.fromARGB(250, 0, 0, 0), 
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white, selectionColor: MainApp.dark, selectionHandleColor: MainApp.dark,),
        //dialogTheme: const DialogTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
        //cardTheme: const CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12,),
            foregroundColor: Colors.white, backgroundColor: Colors.black, 
            shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white, width: 1.2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(25.0)),
          ),
        ),
      );
    }

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

    void resetuserform(){
      _nomController.text = ""; _prenomController.text = ""; _hbdController.text = ""; _emailController.text = ""; _addressController.text = ""; _phoneController.reset();
      _loginController.text = ""; _passwordController.text = ""; _cpasswordController.text = ""; _statutController.text = ""; _nomsteController.text = ""; _fctsteController.text = ""; 
      _siretsteController.text = ""; _psrController.text = ""; _preController.text = ""; _claController.text = ""; en = false; prt = false;
    }

    void resetfolderform(){
      _userController.text = ""; _nomfichierController.text = ""; _statutdocController.text = ""; filePickerResult = null; pdffile.clear();  
      _anatechController.text = ""; _anaadController.text = ""; _comtechController.text = ""; _comadController.text = ""; hsd = 40.5;
      _primeController.text = ""; _synController.text = "";
    }

    // Nom
    final nomField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _nomController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Nom', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(LineAwesome.user_alt_solid, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Nom incorrect' : null; },
      )
    );

    // Prenom
    final prenomField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _prenomController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Prénom', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(LineAwesome.user_alt_solid, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Prénom incorrect' : null; },
      )
    );

    // Hbd
    final hbdField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _hbdController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Date de naissance', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(EvaIcons.calendar_outline, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false,
        onTap: () async { 
          DateTime? dt = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year - 100), lastDate: DateTime.now(),
            locale : const Locale("fr","FR"),
            builder: (context, child) {
              return Theme(data: Ctheme(), child: child!,);
            },
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
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Email', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(EvaIcons.email_outline, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.emailAddress, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        //validator: (value) { return  (EmailValidator.validate(value!) || value.isEmpty) ?  'Email incorrect' : null; },
        validator: (value) { return  (value == null || value.isEmpty) ?  'Email incorrect' : null; },
      )
    );

    // Adresse
    final addressField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _addressController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Adresse', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.location_on_outlined, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Adresse incorrecte' : null; },
      )
    );

    // Phone
    final phoneField = SizedBox(
      height: 32.5,
      child: PhoneFormField(
        autofillHints: const [AutofillHints.telephoneNumber],
        autofocus: false, autocorrect: false, controller: _phoneController,
        countrySelectorNavigator: const CountrySelectorNavigator.dialog(width: 325, height: 500, ),               
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Portable', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(LineAwesome.phone_solid, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        flagSize: 16, defaultCountry : IsoCode.FR, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.phone, obscureText: false, /*readOnly: false,*/
        style: MainApp.styleall.copyWith(), //toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: PhoneValidator.none, //PhoneValidator.compose([PhoneValidator.required(errorText: 'Portable incorrect'), PhoneValidator.validMobile()]),
      )
    );

    // ste Nom
    final nomsteField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _nomsteController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Nom Socièté', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.business, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Nom Socièté incorrect' : null; }
      )
    );

    // ste fct
    final fctsteField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _fctsteController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Fonction Socièté', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.app_registration, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Fonction Socièté incorrecte' : null; }
      )
    );

    // ste siret
    final siretsteField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _siretsteController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Siret Socièté', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.texture, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Siret Socièté incorrecte' : null; }
      )
    );

    // psr
    final psrField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _psrController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'M./Mme/Mlle', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.person_add, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'M./Mme/Mlle incorrect' : null; }
      )
    );

    // pre
    final preField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _preController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Précaire', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.blinds_sharp, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Précaire incorrect' : null; }
      )
    );

    // cla
    final claField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _claController,   
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Classique', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.class_outlined, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return (value == null || value.isEmpty) ? 'Classique incorrect' : null; }
      )
    );

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
        validator: (value) { return (value == null || value.isEmpty) ? 'Login incorrect' : null; }
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

    // cPasswordField
    final cpasswordField = SizedBox(
      height: 32.5,
      child: TextFormField(              
        autofocus: false, controller: _cpasswordController,
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Confirm Password', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(FontAwesome.lock_solid, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: true, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Confirm Password incorrect' : null; },
      )
    );

    // add user btn
    final addUserBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(LineAwesome.save, size: 15, color: Colors.white),
        label: Text("ENREGISTRER", textAlign: TextAlign.center, style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0,),),
        onPressed: () async {
          if(submitnom && submitprenom && submithbd && submitemail && submitaddress && submitphone != null && submitstatut && submitlogin && submitpassword && submitcpassword && _userform.currentState!.validate()){
            if(EmailValidator.validate(_emailController.text)){
              if(_phoneController.value!.isValid(type: PhoneNumberType.mobile) || _phoneController.value!.isValid(type: PhoneNumberType.fixedLine)){
                if(MainApp.regexp.hasMatch(_passwordController.text.trim()) && MainApp.regexp.hasMatch(_cpasswordController.text.trim())){
                  if(_passwordController.text.trim().compareTo(_cpasswordController.text.trim()) == 0){
                    if(_statutController.text.trim().isNotEmpty){
                      if((submitnomste && submitfctste && submitsiretste) || (submitpre && submitpsr && submitcla)){
                        late String ste, fct, sir, psr, pre, cla;
                        if(_statutController.text == 'Entreprise'){
                          ste = _nomsteController.text.toString(); fct = _fctsteController.text.toString(); sir = _siretsteController.text.toString(); 
                          psr = '0'; pre = '0'; cla = '0';
                        }else if(_statutController.text == 'Particulier'){
                          ste = '0'; fct = '0'; sir = '0'; 
                          psr = _psrController.text.toString(); pre = _preController.text.toString(); cla = _claController.text.toString();
                        }
                        await UserModel.createUser(_loginController.text.trim(), UserModel.formaterxmldata(0, _nomController.text, 
                          _prenomController.text, _loginController.text.trim(), _passwordController.text, _addressController.text, 
                          _phoneController.value.toString(), _emailController.text.trim(), 0, ste, fct, sir, psr, pre, cla, '', DateTime.parse(_hbdController.text), 
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(DateTime.now().year, DateTime.now().month + 6, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second))), 
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())), 0, 
                          int.parse(Sessiondata.read("Datas")[0]["id"]))).then((value){
                            if(value == "Utilisateur ajouté."){
                              setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
                              Navigator.of(context, rootNavigator: true).pop();
                              showDialog(context: context, builder: (context){
                                Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  $value');
                              });
                            }else{
                              Navigator.of(context, rootNavigator: true).pop();
                              showDialog(context: context, builder: (context){
                                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  $value');
                              });
                            }
                            resetuserform();
                          }
                        );
                      }else{
                        showDialog(context: context, builder: (context){
                          Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                          return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Détails ${_statutController.text.trim()} incorrects.');
                        });
                      }
                    }else{
                      showDialog(context: context, builder: (context){
                        Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                        return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Statut incorrect.');
                      });
                    }
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
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.success, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // edit user btn
    final editUserBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(LineAwesome.edit_solid, size: 15, color: Colors.white),
        label: Text("MODIFIER", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0,),),
        onPressed: () async {
          if(submitnom && submitprenom && submithbd && submitemail && submitaddress && submitphone != null && submitstatut && submitlogin && submitpassword && submitcpassword && _userform.currentState!.validate()){
            if(EmailValidator.validate(_emailController.text)){
              if(_phoneController.value!.isValid(type: PhoneNumberType.mobile) || _phoneController.value!.isValid(type: PhoneNumberType.fixedLine)){
                if(MainApp.regexp.hasMatch(_passwordController.text.trim()) && MainApp.regexp.hasMatch(_cpasswordController.text.trim())){
                  if(_passwordController.text.trim().compareTo(_cpasswordController.text.trim()) == 0){
                    if(_statutController.text.trim().isNotEmpty){
                      if((submitnomste && submitfctste && submitsiretste) || (submitpre && submitpsr && submitcla)){
                        late String ste, fct, sir, psr, pre, cla;
                        if(_statutController.text == 'Entreprise'){
                          ste = _nomsteController.text.toString(); fct = _fctsteController.text.toString(); sir = _siretsteController.text.toString(); 
                          psr = '0'; pre = '0'; cla = '0';
                        }else if(_statutController.text == 'Particulier'){
                          ste = '0'; fct = '0'; sir = '0'; 
                          psr = _psrController.text.toString(); pre = _preController.text.toString(); cla = _claController.text.toString();
                        } //val.docs.length == 0 ? 0 : val.id as int,
                        await UserModel.updateUser(id, _loginController.text.trim(), UserModel.formaterxmldata(docts.length == 0 ? 0 : id, _nomController.text, 
                          _prenomController.text, _loginController.text.trim(), _passwordController.text, _addressController.text, 
                          _phoneController.value.toString(), _emailController.text.trim(), 0, ste, fct, sir, psr, pre, cla, 
                          docts.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '\\r\\n'), DateTime.parse(_hbdController.text), 
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(DateTime.now().year, DateTime.now().month + 6, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second))), 
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())), 0, 
                          int.parse(Sessiondata.read("Datas")[0]["id"]))).then((value){
                            if(value == "Utilisateur modifié."){
                              setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
                              Navigator.of(context, rootNavigator: true).pop();
                              showDialog(context: context, builder: (context){
                                Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  $value');
                              });
                            }else{
                              Navigator.of(context, rootNavigator: true).pop();
                              showDialog(context: context, builder: (context){
                                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  $value');
                              });
                            }
                            resetuserform();
                          }
                        );
                      }else{
                        showDialog(context: context, builder: (context){
                          Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                          return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Détails ${_statutController.text.trim()} incorrects.');
                        });
                      }
                    }else{
                      showDialog(context: context, builder: (context){
                        Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                        return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Statut incorrect.');
                      });
                    }
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
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.warning, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // delete user btn
    final delUserBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(IonIcons.person_remove, size: 15, color: Colors.white),
        label: Text("SUPPRIMER", textAlign: TextAlign.center, style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),),
        onPressed: () async {
          await UserModel.deleteUser(id).then((value){
            if(value == "Utilisateur supprimé."){
              setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
              Navigator.of(context, rootNavigator: true).pop();
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  $value');
              });
            }else{
              Navigator.of(context, rootNavigator: true).pop();
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  $value');
              });
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.danger, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // Custom userform
    AlertDialog userform (Color bg, Color c, String titre, SizedBox sb) {
      return AlertDialog(
        //title: Text(titre, style: const TextStyle(color: MainApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
        //actions: [ MaterialButton(color: MainApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        //actionsAlignment: MainAxisAlignment.center,
        backgroundColor: bg,
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: _statutController.text.trim().isNotEmpty ? 609 : 467, width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
              child: Form(
                key: _userform,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Big Text
                    Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                    const Divider(color: MainApp.textwr), const SizedBox(height: 20.0,),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // Nom & Prénom 
                      children: [Flexible( child: nomField), const SizedBox(width: 8,), Flexible(child: prenomField),]
                    ), const SizedBox(height: 15.0),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // hbd & email
                      children: [Flexible( child: hbdField), const SizedBox(width: 8,), Flexible(child: emailField),]
                    ), const SizedBox(height: 15.0),
                    
                    addressField, const SizedBox(height: 15.0), phoneField, const SizedBox(height: 15.0), // address & phone

                    SizedBox(height: 32.5, child: SelectField( //Statut
                      textController : _statutController,
                      options: selectoption.map((value) => Option(label: value, value: value)).toList(), //initialOption: Option<String>(label: selectoption[0], value: selectoption[0]),
                      onTextChanged: (value) {
                        setState(() { if(value == "Entreprise"){en = true; prt = false;} if(value == "Particulier"){en = false; prt = true;} });
                      },
                      //onOptionSelected: (option) => debugPrint(option.toString()),
                      inputStyle: MainApp.styleall.copyWith(),
                      inputDecoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
                        labelText: 'Statut', labelStyle: MainApp.styleall.copyWith(),
                        suffixIcon: const Icon(Icons.arrow_drop_down_outlined, size: 18, color: MainApp.textwr,),
                        suffixIconConstraints: const BoxConstraints(minWidth: 35,), 
                      ),
                      menuDecoration: MenuDecoration(
                        margin: const EdgeInsets.only(top: 5), height: 81, alignment: MenuAlignment.center,
                        buttonStyle: TextButton.styleFrom(fixedSize: const Size(double.infinity, 40), backgroundColor: Colors.white, 
                          alignment: Alignment.centerLeft, padding: const EdgeInsets.all(10.0), iconColor: MainApp.textwr,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0.5,)), 
                          textStyle: MainApp.styleall.copyWith(), 
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.transparent, borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [ BoxShadow(offset: Offset.zero, color: MainApp.textwr, blurRadius: 3.5,), ],
                        ),
                        separatorBuilder: (context, index) => Container(height: 1, width: double.infinity, color: Colors.transparent,),
                      ),
                      validator: (value) { return  (value == null || value.isEmpty) ?  'Statut incorrect' : null; },
                    )), const SizedBox(height: 15.0),
                    
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // nom ste & psr
                      children: [const SizedBox(width: 14,), Visibility(visible: en, child: Flexible(child: nomsteField)), Visibility(visible: prt, child: Flexible(child: psrField)), const SizedBox(width: 14,),]
                    ), Visibility(visible: _statutController.text.trim().isNotEmpty, child: const Flexible(child: SizedBox(height: 15.0))),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // fct ste & pre
                      children: [const SizedBox(width: 14,), Visibility(visible: en, child: Flexible(child: fctsteField)), Visibility(visible: prt, child: Flexible(child: preField)), const SizedBox(width: 14,),]
                    ), Visibility(visible: _statutController.text.trim().isNotEmpty, child: const Flexible(child: SizedBox(height: 15.0))),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // siret ste & cla
                      children: [const SizedBox(width: 14,), Visibility(visible: en, child: Flexible(child: siretsteField)), Visibility(visible: prt, child: Flexible(child: claField)), const SizedBox(width: 14,),]
                    ), Visibility(visible: _statutController.text.trim().isNotEmpty, child: const Flexible(child: SizedBox(height: 15.0))),

                    loginField, const SizedBox(height: 15.0), // login
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // pwd & cpwd
                      children: [Flexible( child: passwordField), const SizedBox(width: 8,), Flexible(child: cpasswordField),]
                    ), const SizedBox(height: 20.0),

                    const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,), sb,
                  ],
                ),
              ),
            ),
          );
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
      );
    }

    // Custom userdel
    AlertDialog userdel (Color bg, Color c, String titre, SizedBox sb, String mes) {
      return AlertDialog(
        //title: Text(titre, style: const TextStyle(color: MyApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
        //actions: [ MaterialButton(color: MyApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        //actionsAlignment: MainAxisAlignment.center,
        backgroundColor: bg,
        content: SizedBox(
          height: 168, width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
            child: Form(
              key: _userdelform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Big Text
                  Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                  const Divider(color: MainApp.textwr), const SizedBox(height: 20.0,),

                  Text(mes, style: MainApp.styleall.copyWith(fontSize: 12.5,),),  const SizedBox(height: 25.0),

                  const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),

                  sb,
                ],
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
      );
    }

    // File name
    final filenameField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _nomfichierController,                 
        cursorColor: MainApp.gray,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.gray,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.gray,),),
          fillColor: MainApp.gray, focusColor: MainApp.gray,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Nom fichier', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(LineAwesome.file_pdf, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false,
        keyboardType: TextInputType.text, obscureText: false, readOnly: true,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Nom fichier incorrect' : null; },
      )
    );

    // Ana tech
    final anatechField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _anatechController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'ANA technique', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Bootstrap.pencil, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Analyse technique incorrecte' : null; },
      )
    );

    // Ana admin
    final anaadField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _anaadController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'ANA administrative', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Bootstrap.pencil_fill, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Analyse administrative incorrecte' : null; },
      )
    );

    // Com tech
    final comtechField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _comtechController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'CM technique', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Bootstrap.pencil, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Commentaire technique incorrect' : null; },
      )
    );

    // Com admin
    final comadField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _comadController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'CM administratif', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Bootstrap.pencil_fill, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Commentaire administratif incorrect' : null; },
      )
    );

    // Prime
    final primeField = SizedBox(
      height: 32.5,
      child: TextFormField(
        autofocus: false, controller: _primeController,                 
        cursorColor: MainApp.textwr,          
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Prime', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(BoxIcons.bx_euro, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))], 
        enabled: true, enableSuggestions: false, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false,), obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Prime incorrecte' : null; },
      )
    );

    // Synthèse
    final synField = SizedBox(
      height: 132,
      child: TextFormField(
        autofocus: false, controller: _synController,                 
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
          labelText: 'Synthèse', labelStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(BoxIcons.bx_money_withdraw, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.multiline, obscureText: false, readOnly: false, minLines: null, maxLines: null, expands: true,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        validator: (value) { return  (value == null || value.isEmpty) ?  'Synthèse incorrecte' : null; },
      )
    );

    // add file btn
    final addFileBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(LineAwesome.file_pdf_solid, size: 15, color: Colors.white),
        label: Text("SELECTIONNER UN FICHIER", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0,),),
        onPressed: () async {
          filePickerResult = await FilePicker.platform.pickFiles(
            dialogTitle: 'MiCee', allowedExtensions: ['pdf'], type: FileType.custom,
            //onFileLoading: (FilePickerStatus status) => print(status),
          );
          if(filePickerResult != null) {
            setState(() { pdffile.clear(); });
            if(filePickerResult!.files.single.size <= 5000000){ // 5 Mo
              if(filePickerResult!.files.single.extension == "pdf"){
                _nomfichierController.text = filePickerResult!.files.single.name;
                pdffile.add(filePickerResult!.files.single.name);
                if(kIsWeb){
                  PlatformFile file = filePickerResult!.files.single;
                  pdffile.add(base64Encode(file.bytes!));
                  //print(base64Encode(file.bytes!)); //print(String.fromCharCodes(file.bytes!));
                }else{
                  File file = File(filePickerResult!.files.single.path!);
                  pdffile.add(base64Encode(file.readAsBytesSync()));
                  //print(base64Encode(file.readAsBytesSync())); //print(String.fromCharCodes(file.readAsBytesSync()));
                }
              }else{
                _nomfichierController.text = "";
                // ignore: use_build_context_synchronously
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                  return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Le fichier choisi doit être un PDF.');
                });
              }
            }else{
              _nomfichierController.text = "";
              // ignore: use_build_context_synchronously
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Le fichier choisi ne doit pas dépasser 5 Mo.');
              });
            }
          }else{
            _nomfichierController.text = "";
            // ignore: use_build_context_synchronously
            showDialog(context: context, builder: (context){
              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Aucun fichier n\'a été choisi.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.textwr, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)),),
        ),
      )
    );

    // add folder btn
    final addFolderBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(LineAwesome.save, size: 15, color: Colors.white),
        label: Text("ENREGISTRER", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0,),),
        onPressed: () async {
          if(submituser && submitnomfichier && submitstatutdoc && submitanatech && submitanaad && submitcomtech && submitcomad && submitprime && submitsyn && _folderform.currentState!.validate()) {
            if(_userController.text.trim().isNotEmpty) {
              if(_statutdocController.text.trim().isNotEmpty) {
                if(_anatechController.text.isNotEmpty) {
                  if(_anaadController.text.isNotEmpty) {
                    if(_comtechController.text.isNotEmpty) {
                      if(_comadController.text.isNotEmpty) {
                        if(_primeController.text.isNotEmpty) {
                          if(_synController.text.isNotEmpty) {
                            var i = UserModel.useroption.where((e) => e.split(' ~ ')[0].toLowerCase().contains(_userController.text.trim().toString().toLowerCase())).toString().split(" ~ ")[1].split(")")[0];
                            late int aa, bb, cc, dd;
                            if(_statutdocController.text == "En cours"){ aa = 1; bb = 0; cc = 0; dd = 0; 
                            } else if(_statutdocController.text == "Complément") { aa = 1; bb = 1; cc = 0; dd = 0; 
                            } else if(_statutdocController.text == "Instruction"){ aa = 1; bb = 1; cc = 1; dd = 0; 
                            } else if(_statutdocController.text == "Décision"){ aa = 1; bb = 1; cc = 1; dd = 1; }
                            await UserModel.getOneUser(int.parse(i.toString())).then((val) {
                              UserModel.updateUser(val.id as int, val.name, UserModel.formaterxmldata(val.id as int, val.Nom, val.Prenom, val.Login, val.Motdepasse,
                                val.Adresse, val.Tel, val.Email, 0, val.Ste, val.Fonction, val.Siret, val.Psr, val.Precaire, val.Classique, val.docs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(', ', '\\r\\n') + 
                                UserModel.docforxmldata(val.docs.length + 1, "${pdffile[0]} ~ ${pdffile[1]}", aa, bb, cc, dd, _anatechController.text, _anaadController.text, _comtechController.text, 
                                _comadController.text, double.parse(_primeController.text), _synController.text), 
                                DateTime.parse(val.Datenaiss.toString()), DateTime.parse(val.Livetime.toString()), DateTime.parse(val.Creation.toString()), 0, val.IdRef)).then((value){
                                  if(value == "Utilisateur modifié."){
                                    setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
                                    Navigator.of(context, rootNavigator: true).pop();
                                    showDialog(context: context, builder: (context){
                                      Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  Dossier ajouté.');
                                    });
                                  }else{
                                    Navigator.of(context, rootNavigator: true).pop();
                                    showDialog(context: context, builder: (context){
                                      Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Impossible d\'ajouter le dossier.');
                                    });
                                  }
                                  resetfolderform();
                                }
                              );
                            });
                          } else {
                            showDialog(context: context, builder: (context){
                              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Synthèse incorrecte.');
                            });
                          }
                        } else {
                          showDialog(context: context, builder: (context){
                            Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                            return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Prime incorrecte P >= 0.99€.');
                          });
                        }
                      } else {
                        showDialog(context: context, builder: (context){
                          Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                          return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Commentaire administratif incorrect.');
                        });
                      }
                    } else {
                      showDialog(context: context, builder: (context){
                        Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                        return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Commentaire technique incorrect.');
                      });
                    }
                  } else {
                    showDialog(context: context, builder: (context){
                      Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Analyse administrative incorrecte.');
                    });
                  }
                } else {
                  showDialog(context: context, builder: (context){
                    Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                    return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Analyse technique incorrecte.');
                  });
                }
              } else {
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                  return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Statut document incorrect.');
                });
              }
            } else {
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Utilisateur incorrect.');
              });
            }
          } else {
            showDialog(context: context, builder: (context){
              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.success, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // edit folder btn
    final editFolderBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(Icons.rule_folder_outlined, size: 15, color: Colors.white),
        label: Text("MODIFIER", textAlign: TextAlign.center,  style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0,),),
        onPressed: () async {
          if(submituser && submitnomfichier && submitstatutdoc && submitanatech && submitanaad && submitcomtech && submitcomad && submitprime && submitsyn && _folderform.currentState!.validate()) {
            if(_userController.text.trim().isNotEmpty) {
              if(_statutdocController.text.trim().isNotEmpty) {
                if(_anatechController.text.isNotEmpty) {
                  if(_anaadController.text.isNotEmpty) {
                    if(_comtechController.text.isNotEmpty) {
                      if(_comadController.text.isNotEmpty) {
                        if(_primeController.text.isNotEmpty) {
                          if(_synController.text.isNotEmpty) {
                            late int aa, bb, cc, dd; late dynamic datadoc;
                            if(_statutdocController.text == "En cours"){ aa = 1; bb = 0; cc = 0; dd = 0; 
                            } else if(_statutdocController.text == "Complément") { aa = 1; bb = 1; cc = 0; dd = 0; 
                            } else if(_statutdocController.text == "Instruction"){ aa = 1; bb = 1; cc = 1; dd = 0; 
                            } else if(_statutdocController.text == "Décision"){ aa = 1; bb = 1; cc = 1; dd = 1; }
                            await UserModel.getOneUser(id).then((val) {
                              datadoc = "<?xml version='1.0' encoding='UTF-8'?>\\r\\n"
                                "${UserModel.docforxmldata(iddoc, '${pdffile[0]} ~ ${pdffile[1]}', aa, bb, cc, dd, _anatechController.text, _anaadController.text, _comtechController.text, 
                                _comadController.text, double.parse(_primeController.text), _synController.text)}";
                              datadoc = datadoc.substring(0, datadoc.length - 4);
                              val.docs[iddoc - 1] = xml.XmlDocument.parse(datadoc).findElements("Doc").first;
                              UserModel.updateUser(val.id as int, val.name, UserModel.formaterxmldata(val.id as int, val.Nom, val.Prenom, val.Login, val.Motdepasse,
                                val.Adresse, val.Tel, val.Email, 0, val.Ste, val.Fonction, val.Siret, val.Psr, val.Precaire, val.Classique, 
                                val.docs.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(', ', '\\r\\n'), DateTime.parse(val.Datenaiss.toString()), 
                                DateTime.parse(val.Livetime.toString()), DateTime.parse(val.Creation.toString()), 0, val.IdRef)).then((value){
                                  if(value == "Utilisateur modifié."){
                                    setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
                                    Navigator.of(context, rootNavigator: true).pop();
                                    showDialog(context: context, builder: (context){
                                      Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  Dossier modifié.');
                                    });
                                  }else{
                                    Navigator.of(context, rootNavigator: true).pop();
                                    showDialog(context: context, builder: (context){
                                      Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Impossible de modifier le dossier.');
                                    });
                                  }
                                  resetfolderform();
                                }
                              );
                            });
                          } else {
                            showDialog(context: context, builder: (context){
                              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Synthèse incorrecte.');
                            });
                          }
                        } else {
                          showDialog(context: context, builder: (context){
                            Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                            return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Prime incorrecte P >= 0.99€.');
                          });
                        }
                      } else {
                        showDialog(context: context, builder: (context){
                          Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                          return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Commentaire administratif incorrect.');
                        });
                      }
                    } else {
                      showDialog(context: context, builder: (context){
                        Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                        return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Commentaire technique incorrect.');
                      });
                    }
                  } else {
                    showDialog(context: context, builder: (context){
                      Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                      return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Analyse administrative incorrecte.');
                    });
                  }
                } else {
                  showDialog(context: context, builder: (context){
                    Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                    return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Analyse technique incorrecte.');
                  });
                }
              } else {
                showDialog(context: context, builder: (context){
                  Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                  return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Statut document incorrect.');
                });
              }
            } else {
              showDialog(context: context, builder: (context){
                Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Utilisateur incorrect.');
              });
            }
          } else {
            showDialog(context: context, builder: (context){
              Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
              return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, '  Merci de remplir tous les champs.');
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.warning, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );

    // delete folder btn
    final delFolderBtn = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon( //ElevatedButton
        icon: const Icon(Icons.folder_delete_outlined, size: 15, color: Colors.white),
        label: Text("SUPPRIMER", textAlign: TextAlign.center, style: MainApp.styleall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),),
        onPressed: () async {
          List<xml.XmlElement> datadoc = []; int cpt = 0;
          UserModel.getOneUser(id).then((val) {
            if(val.docs.length == 1){ val.docs.clear(); } else if (val.docs.length > 1) {
              val.docs.removeAt(iddoc - 1);
              for(final xm in val.docs){
                cpt++; var xmlt = xml.XmlDocument.parse("<?xml version='1.0' encoding='UTF-8'?>\\r\\n$xm").findElements("Doc").first.findElements("IdDoc").first.toString();
                var xmlstr = "<?xml version='1.0' encoding='UTF-8'?>\\r\\n${xm.toString().replaceAll(xmlt, "<IdDoc>$cpt</IdDoc>")}";
                datadoc.add(xml.XmlDocument.parse(xmlstr).findElements("Doc").first);
              }
            }
            UserModel.updateUser(val.id as int, val.name, UserModel.formaterxmldata(val.docs.length == 0 ? 0 : val.id as int, val.Nom, val.Prenom, val.Login, val.Motdepasse,
              val.Adresse, val.Tel, val.Email, 0, val.Ste, val.Fonction, val.Siret, val.Psr, val.Precaire, val.Classique, 
              datadoc.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(', ', '\\r\\n'), DateTime.parse(val.Datenaiss.toString()), 
              DateTime.parse(val.Livetime.toString()), DateTime.parse(val.Creation.toString()), 0, val.IdRef)).then((value){
                if(value == "Utilisateur modifié."){
                  setState(() {futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;});
                  Navigator.of(context, rootNavigator: true).pop();
                  showDialog(context: context, builder: (context){
                    Future.delayed(const Duration(milliseconds: 1000), () { Navigator.of(context).pop(true); });
                    return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.checkmark_circle, MainApp.success, '  Dossier supprimé.');
                  });
                }else{
                  Navigator.of(context, rootNavigator: true).pop();
                  showDialog(context: context, builder: (context){
                    Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                    return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.danger, '  Impossible de supprimer le dossier.');
                  });
                }
                resetfolderform();
              }
            );
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: MainApp.danger, side: const BorderSide(color: MainApp.gray, width: 1.5,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)),),
        ),
      )
    );
    
    // Custom folderform
    AlertDialog folderform (Color bg, Color c, String titre, SizedBox sb) {
      return AlertDialog(
        //title: Text(titre, style: const TextStyle(color: MainApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
        //actions: [ MaterialButton(color: MainApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        //actionsAlignment: MainAxisAlignment.center,
        backgroundColor: bg,
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 609, width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
              child: Form(
                key: _folderform,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, 
                  children: <Widget>[
                    // Big Text
                    Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                    const Divider(color: MainApp.textwr), const SizedBox(height: 20.0,),

                    SizedBox(height: 32.5, child: SelectField( // user
                      textController : _userController,
                      options: UserModel.useroption.map((value) => Option(label: value.split(' ~ ')[0], value: value.split(' ~ ')[0])).toList(), //initialOption: Option<String>(label: selectoption[0], value: selectoption[0]),
                      onTextChanged: (value) {
                        setState(() {  });
                      },
                      //onOptionSelected: (option) => debugPrint(option.toString()),
                      inputStyle: MainApp.styleall.copyWith(),
                      inputDecoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
                        labelText: 'Utilisateur', labelStyle: MainApp.styleall.copyWith(),
                        suffixIcon: const Icon(Icons.arrow_drop_down_outlined, size: 18, color: MainApp.textwr,),
                        suffixIconConstraints: const BoxConstraints(minWidth: 35,), 
                      ),
                      menuDecoration: MenuDecoration(
                        margin: const EdgeInsets.only(top: 5), height: double.tryParse((40.5 * UserModel.useroption.length).toString()), alignment: MenuAlignment.center,
                        buttonStyle: TextButton.styleFrom(fixedSize: const Size(double.infinity, 40), backgroundColor: Colors.white, 
                          alignment: Alignment.centerLeft, padding: const EdgeInsets.all(10.0), iconColor: MainApp.textwr,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0.5,)), 
                          textStyle: MainApp.styleall.copyWith(), 
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.transparent, borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [ BoxShadow(offset: Offset.zero, color: MainApp.textwr, blurRadius: 3.5,), ],
                        ),
                        separatorBuilder: (context, index) => Container(height: 1, width: double.infinity, color: Colors.transparent,),
                      ),
                      validator: (value) { return  (value == null || value.isEmpty) ?  'Utilisateur incorrect' : null; },
                    )), const SizedBox(height: 15.0),

                    filenameField, const SizedBox(height: 15.0), addFileBtn, const SizedBox(height: 15.0), 

                    SizedBox(height: 32.5, child: SelectField( // statut doc
                      textController : _statutdocController,
                      options: ["En cours", "Complément", "Instruction", "Décision"].map((val) => Option(label: val, value: val)).toList(), //initialOption: Option<String>(label: selectoption[0], value: selectoption[0]),
                      onTextChanged: (value) {
                        setState(() {  });
                      },
                      //onOptionSelected: (option) => debugPrint(option.toString()),
                      inputStyle: MainApp.styleall.copyWith(),
                      inputDecoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
                        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
                        labelText: 'Statut document', labelStyle: MainApp.styleall.copyWith(),
                        suffixIcon: const Icon(Icons.arrow_drop_down_outlined, size: 18, color: MainApp.textwr,),
                        suffixIconConstraints: const BoxConstraints(minWidth: 35,), 
                      ),
                      menuDecoration: MenuDecoration(
                        margin: const EdgeInsets.only(top: 5), height: hsd, alignment: MenuAlignment.center,
                        buttonStyle: TextButton.styleFrom(fixedSize: const Size(double.infinity, 40), backgroundColor: Colors.white, 
                          alignment: Alignment.centerLeft, padding: const EdgeInsets.all(10.0), iconColor: MainApp.textwr,
                          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0.5,)), 
                          textStyle: MainApp.styleall.copyWith(), 
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.transparent, borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [ BoxShadow(offset: Offset.zero, color: MainApp.textwr, blurRadius: 3.5,), ],
                        ),
                        separatorBuilder: (context, index) => Container(height: 1, width: double.infinity, color: Colors.transparent,),
                      ),
                      validator: (value) { return  (value == null || value.isEmpty) ?  'Statut document incorrect' : null; },
                    )), const SizedBox(height: 15.0),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // ana tech & admin
                      children: [Flexible( child: anatechField), const SizedBox(width: 8,), Flexible(child: anaadField),]
                    ), const SizedBox(height: 15.0), 
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // com tech & admin
                      children: [Flexible( child: comtechField), const SizedBox(width: 8,), Flexible(child: comadField),]
                    ), const SizedBox(height: 15.0), 
                    primeField, const SizedBox(height: 15.0), synField, const SizedBox(height: 20.0),

                    const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,), sb,
                  ],
                ),
              ),
            ),
          );
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
      );
    }

    // Custom folderdel
    AlertDialog folderdel (Color bg, Color c, String titre, SizedBox sb, String mes) {
      return AlertDialog(
        //title: Text(titre, style: const TextStyle(color: MyApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
        //actions: [ MaterialButton(color: MyApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        //actionsAlignment: MainAxisAlignment.center,
        backgroundColor: bg,
        content: SizedBox(
          height: 168, width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
            child: Form(
              key: _folderdelform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Big Text
                  Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                  const Divider(color: MainApp.textwr), const SizedBox(height: 13.0,),

                  Text(mes, style: MainApp.styleall.copyWith(fontSize: 12.5,),),  const SizedBox(height: 18.0),

                  const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),

                  sb,
                ],
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
      );
    }

    // Custom pdfviewer
    AlertDialog pdfviewer (Color bg, Color c, String titre, Uint8List data, String pdffilename) {
      return AlertDialog(
        //title: Text(titre, style: const TextStyle(color: MyApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
        //actions: [ MaterialButton(color: MyApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
        //actionsAlignment: MainAxisAlignment.center,
        backgroundColor: bg,
        content: SizedBox(
          height: 897, width: 710,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Big Text
                Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),

                Row(mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Text("${pdfc.pageCount}  Pages", style: MainApp.styleall.copyWith(),), const SizedBox(width: 10.0,),
                    IconButton(onPressed: (){ pdfc.previousPage(); }, icon: const Icon(Icons.arrow_left_sharp), color: MainApp.textwr, tooltip: "Précédent",
                      splashRadius: 16.0, highlightColor: MainApp.unique, hoverColor: MainApp.bg,), const SizedBox(width: 1.5,),
                    Text("${pdfc.pageNumber} / ${pdfc.pageCount}", style: MainApp.styleall.copyWith(),), const SizedBox(width: 1.5,),
                    IconButton(onPressed: (){ pdfc.nextPage(); }, icon: const Icon(Icons.arrow_right_sharp), color: MainApp.textwr, tooltip: "Suivant",
                      splashRadius: 16.0, highlightColor: MainApp.unique, hoverColor: MainApp.bg,), const SizedBox(width: 10.0,),
                    IconButton(onPressed: (){ pdfc.zoomLevel += 1; }, icon: const Icon(Icons.zoom_in), color: MainApp.textwr, tooltip: "Zoom +",
                      splashRadius: 16.0, highlightColor: MainApp.unique, hoverColor: MainApp.bg,), const SizedBox(width: 1.5,),
                    IconButton(onPressed: (){ pdfc.zoomLevel -= 1; }, icon: const Icon(Icons.zoom_out), color: MainApp.textwr, tooltip: "Zoom -",
                      splashRadius: 16.0, highlightColor: MainApp.unique, hoverColor: MainApp.bg,), const SizedBox(width: 10.0,),
                    IconButton(onPressed: () async { 
                        if(kIsWeb){
                          download(Stream.fromIterable(data), '$pdffilename.pdf');
                        } else {
                          //download(Stream.fromIterable(data), '$pdffilename.pdf');  ceci marche mais le doc ne se trouve pas dans le rep downloads
                          final Directory? downloadsDir = await getDownloadsDirectory();
                          final File file = File('${downloadsDir?.path}\\$pdffilename.pdf');
                          await file.writeAsBytes(data);
                          // ignore: use_build_context_synchronously
                          showDialog(context: context, builder: (context){
                            Future.delayed(const Duration(seconds: 4), () { Navigator.of(context).pop(true); });
                            return msg(const Color.fromARGB(200, 0, 0, 0), IonIcons.information_circle, MainApp.info, ' ${downloadsDir?.path}\\$pdffilename.pdf prêt.');
                          });
                        }
                      }, icon: const Icon(Icons.file_download_outlined), color: MainApp.textwr, tooltip: "Télécharger",
                      splashRadius: 16.0, highlightColor: MainApp.unique, hoverColor: MainApp.bg,)
                  ], 
                ), const SizedBox(height: 5.0,),

                SizedBox(height: 712, child: SfPdfViewer.memory(data, controller: pdfc,),), const SizedBox(height: 20.0,),
                
                const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),
              ]
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
      );
    }

    // headerboxes
    final headerbox = <Widget>[
      Container(width: 320, height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
        child: Card( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
          shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
          child: Column( 
            children: [ 
              const SizedBox(height: 5.0,), Text('Nouveau(x) client(s)', style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 2.5,), const Divider(indent: 5.0, color: MainApp.textwr, endIndent: 5.0,),
              SizedBox(height: 84, child: FutureBuilder(
                future: ncdata, builder: (BuildContext context, AsyncSnapshot<List<Utilisateur>> nc) {
                  if(nc.hasData) {
                    if(nc.data!.isNotEmpty) { int z = 0;
                      return ListView.builder(padding: const EdgeInsets.only(left: 15, right: 15), 
                        itemCount: nc.data!.length, shrinkWrap: true, itemBuilder: (BuildContext context, int index) {
                          List<Widget> array = <Widget>[];
                          if(nc.data?[index].IdUser == 0){
                            z++;
                            array.add(const Divider(color: MainApp.dark,));
                            array.add(
                              Row(mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  const Icon(Icons.person, size: 12.5, color: MainApp.textwr,),
                                  Text(' ${nc.data?[index].Nom} / ${nc.data?[index].Email} / +${nc.data?[index].Tel.split("countryCode: ")[1].split(",")[0]}'
                                    ' ${nc.data?[index].Tel.split("nsn: ")[1].substring(0, nc.data![index].Tel.split("nsn: ")[1].length - 1)}', 
                                    style: MainApp.styleall.copyWith(fontSize: 12.5,),),
                                ]
                              ),
                            );
                          }
                          if(nc.data!.length - 1 == index){
                            if(z > 0) array.add(const Divider(color: MainApp.dark,));
                          }
                          return Column(mainAxisAlignment: MainAxisAlignment.center, children: array,);
                        },
                      );
                    }else{
                      return Center(
                        child: Text("Aucun(e)s client(e)s trouvé(e)s", style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                })
              ),
              const Divider(indent: 5.0, color: MainApp.textwr, endIndent: 5.0,),
            ]
          ),
        ),
      ),
      const SizedBox(width: 5, height: 5,),
      Container(width: 320, height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
        child: Card( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
          shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
          child: Column(
            children: [
              const SizedBox(height: 5.0,), Text('Dossier(s) en cours', style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 2.5,), const Divider(indent: 5.0, color: MainApp.textwr, endIndent: 5.0,),
              SizedBox(height: 84, child: FutureBuilder(
                future: nddata, builder: (BuildContext context, AsyncSnapshot<List<Utilisateur>> nd) {
                  if(nd.hasData) {
                    if(nd.data!.isNotEmpty) { int z = 0;
                      return ListView.builder(padding: const EdgeInsets.only(left: 15, right: 15), 
                        itemCount: nd.data!.length, shrinkWrap: true, itemBuilder: (BuildContext context, int index) {
                          List<Widget> array = <Widget>[];
                          if(nd.data?[index].IdUser != 0 && nd.data?[index].docs!.length > 0){
                            for(var i = 0; i < nd.data?[index].docs!.length; i++){ 
                              if(nd.data?[index].docs[i]['StatutDoc']['Decision'] == '0'){
                                z++;
                                array.add(const Divider(color: MainApp.dark,));
                                array.add(
                                  Row(mainAxisAlignment: MainAxisAlignment.center, 
                                    children: [
                                      const Icon(Icons.folder_rounded, size: 12.5, color: MainApp.textwr,),
                                      Text(nd.data?[index].Ste != '0' ? 
                                      ' ${nd.data?[index].Ste} (${nd.data![index].docs!.length}) / ${nd.data![index].docs![i]['Msg'].split(" ~ ")[0]}' : ' ${nd.data?[index].Psr} (${nd.data![index].docs!.length}) / ${nd.data![index].docs![i]['Msg'].split(" ~ ")[0]}', 
                                      style: MainApp.styleall.copyWith(fontSize: 12.5,),),
                                    ],
                                  ),
                                );
                              }
                            }
                          }
                          if(nd.data!.length - 1 == index){
                            if(z > 0) array.add(const Divider(color: MainApp.dark,));
                          }
                          return Column(mainAxisAlignment: MainAxisAlignment.center, children: array,);
                        }, 
                      );
                    }else{
                      return Center(
                        child: Text("Aucun(s) dossier(s) en cours trouvé(s)", style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                })
              ),
              const Divider(indent: 5.0, color: MainApp.textwr, endIndent: 5.0,),
            ]
          ),
        ),
      ),
      const SizedBox(width: 5, height: 5,),
      Container(width: 320, height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
        child: Card( 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
          shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
          child: Column(
            children: [
              const SizedBox(height: 5.0,), Text('Dossier(s) terminé(s)', style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 2.5,), const Divider(indent: 5.0, color: MainApp.textwr, endIndent: 5.0,),
              SizedBox(height: 84, child: FutureBuilder(
                future: fddata, builder: (BuildContext context, AsyncSnapshot<List<Utilisateur>> fd) {
                  if(fd.hasData) {
                    if(fd.data!.isNotEmpty) { int z = 0;
                      return ListView.builder(padding: const EdgeInsets.only(left: 15, right: 15), 
                        itemCount: fd.data!.length, shrinkWrap: true, itemBuilder: (BuildContext context, int index) {
                          List<Widget> array = <Widget>[];
                          if(fd.data?[index].IdUser != 0 && fd.data?[index].docs!.length > 0){
                            for(var i = 0; i < fd.data?[index].docs!.length; i++){ 
                              if(fd.data?[index].docs[i]['StatutDoc']['Decision'] == '1'){
                                z++;
                                array.add(const Divider(color: MainApp.dark,));
                                array.add(
                                  Row(mainAxisAlignment: MainAxisAlignment.center, 
                                    children: [
                                      const Icon(Icons.folder_zip_rounded, size: 12.5, color: MainApp.textwr,),
                                      Text(fd.data?[index].Ste != '0' ? 
                                      ' ${fd.data?[index].Ste} (${fd.data![index].docs!.length}) / ${fd.data![index].docs![i]['Msg'].split(" ~ ")[0]}' : ' ${fd.data?[index].Psr} (${fd.data![index].docs!.length}) / ${fd.data![index].docs![i]['Msg'].split(" ~ ")[0]}', 
                                      style: MainApp.styleall.copyWith(fontSize: 12.5,),),
                                    ],
                                  ),
                                );
                              }
                            }
                          }
                          if(fd.data!.length - 1 == index){
                            if(z > 0) array.add(const Divider(color: MainApp.dark,));
                          }
                          return Column(mainAxisAlignment: MainAxisAlignment.center, children: array,);
                        }, 
                      );
                    }else{
                      return Center(
                        child: Text("Aucun(s) dossier(s) terminé(s) trouvé(s)", style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                })
              ),
            ]
          ),
        ),
      ),
    ];

    // footer ligne
    final footerligne = <Widget>[
      Flexible(child: Text('  Etat : Connecté(e)', style: MainApp.styleall.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold),),),
      const SizedBox(width: 0.5,), 
      Flexible(child: Text('  Statut : ${(Sessiondata.read("Datas")[0]["Admin"] == "1") ? "Administrateur" : "Utilisateur"}', style: MainApp.styleall.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold),),), 
      const SizedBox(width: 0.5,), 
      Flexible(child: Text('  Expire le : ${Sessiondata.read("Datas")[0]["Livetime"]}  ', style: MainApp.styleall.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold),),), 
      //const SizedBox(width: 0.5,), 
      //Flexible(child: Text('  ${Sessiondata.read("Datas")[0]}', style: MainApp.styleall.copyWith(fontSize: 12.5, fontWeight: FontWeight.bold),),),
    ];

    // Search user
    final searchuserField = SizedBox(
      height: 32.5,
      child: TextField(
        autofocus: false, controller: _searchuserController,
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          hintText: "Rechercher un(e) utilisateur(ise)...", hintStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.search_sharp, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        onChanged: (s) { 
          //setState(() { futuredata = _searchuserController.text.isEmpty ? UserModel.getAllUsers() : UserModel.searchData(s); });
          setState(() {
            if(_searchuserController.text.isEmpty){
              futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;
            }else{
              futuredata = UserModel.searchData(sfudata, s); futuredata.then((r) => rel = r.length);
            }
          });
        },
      )
    );

    // Search folder
    final searchfolderField = SizedBox(
      height: 32.5,
      child: TextField(
        autofocus: false, controller: _searchfolderController,
        cursorColor: MainApp.textwr,              
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
          fillColor: MainApp.textwr, focusColor: MainApp.textwr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 9.5),
          hintText: "Rechercher un dossier...", hintStyle: MainApp.styleall.copyWith(),
          suffixIcon: const Icon(Icons.search_sharp, size: 18, color: MainApp.textwr,),
          suffixIconConstraints: const BoxConstraints(minWidth: 35,),
        ),
        enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false,
        style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
        onChanged: (s) { 
          //setState(() { futuredata = _searchfolderController.text.isEmpty ? UserModel.getAllUsers() : UserModel.searchData(s); });
          setState(() {
            if(_searchfolderController.text.isEmpty){
              futuredata = UserModel.getAllUsers(); ncdata = futuredata; nddata = futuredata; fddata = futuredata; rel = 0; docts = null;
            }else{
              futuredata = UserModel.searchData(sfddata, s); futuredata.then((r) => rel = r.length);
            }
          });
        },
      )
    );

    return Scaffold(
      /*appBar: AppBar(
        title: const Center(child: Text('Awesome AppBar')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [MainApp.bg, MainApp.bg1, MainApp.bg2, MainApp.bg3],
              stops: [0.2, 0.5, 0.8, 0.7],
              tileMode: TileMode.mirror,
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
            colors: [MainApp.navcolor2, MainApp.navcolor3],
            stops: [0, 2],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SideMenu(
                    controller: sideMenu, //showToggle: true, alwaysShowFooter: true,
                    style: SideMenuStyle(
                      itemBorderRadius: const BorderRadius.all(Radius.circular(5)),
                      itemOuterPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
                      openSideMenuWidth: 250, showTooltip: true,
                      displayMode: MediaQuery.of(context).size.width >= 650 ? SideMenuDisplayMode.open : SideMenuDisplayMode.compact,
                      hoverColor: MainApp.navcolor2, selectedHoverColor: MainApp.gray,
                      selectedColor: Colors.white, iconSize: 20, //toggleColor: Colors.white,
                      selectedTitleTextStyle: const TextStyle(color: MainApp.dark),
                      unselectedTitleTextStyle: const TextStyle(color: Colors.white),
                      selectedIconColor: MainApp.dark, unselectedIconColor: Colors.white,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),),
                      backgroundColor: MainApp.navcolor3
                    ),
                    title: Column(
                      children: [
                        const SizedBox(height: 8.0,),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 161, maxWidth: 211,),
                          child: Image.asset("assets/micee-high-resolution-logo-white-transparent.png", fit: BoxFit.contain),
                        ),
                        const Divider(indent: 8.0, endIndent: 8.0,),
                        Padding(padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.5),
                          child: MediaQuery.of(context).size.width >= 650 ? DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true, hint: const Row(children: [
                                Icon(Icons.add_circle_sharp, color: Colors.white, size: 20,), SizedBox(width: 4,), 
                                Expanded(child: Text(' Ajouter',  overflow: TextOverflow.ellipsis,),),
                              ]),
                              items: ['Utilisateur','Dossier'].map((String item) => DropdownMenuItem<String>(value: item,
                                //child: Text(item, style: const TextStyle(color: Colors.black,), overflow: TextOverflow.ellipsis,),
                                child: Row(children: [
                                  Icon(item == 'Utilisateur' ? FontAwesome.user_plus_solid : FontAwesome.folder_plus_solid, color: Colors.white, size: 15,), const SizedBox(width: 7,), 
                                  Expanded(child: Text(' $item', style: const TextStyle(color: Colors.white,), overflow: TextOverflow.ellipsis,),),
                                ]),
                              )).toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() { /*selectedValue = value;*/ });
                                resetuserform(); resetfolderform();
                                if(value == 'Utilisateur'){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return userform(Colors.white, MainApp.success, 'AJOUT UTILISATEUR', addUserBtn);
                                  });
                                }
                                if(value == 'Dossier'){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return folderform(Colors.white, MainApp.success, 'AJOUT DOSSIER', addFolderBtn);
                                  });
                                }
                              },
                              buttonStyleData: ButtonStyleData(height: 50, width: 249, elevation: 2, padding: const EdgeInsets.only(left: 9, right: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white,), color: MainApp.navcolor2,),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 20, ),
                                //iconSize: 20, iconEnabledColor: Colors.yellow, iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(maxHeight: 200, width: 242,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white,), color: MainApp.navcolor2,),
                                padding: const EdgeInsets.only(), offset: const Offset(0, -5),
                                scrollbarTheme: ScrollbarThemeData(radius: const Radius.circular(40), thickness: MaterialStateProperty.all(6), thumbVisibility: MaterialStateProperty.all(true),),
                              ),
                              menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.only(left: 12, right: 12),),
                            ),
                          ) : const SizedBox(),
                        ),
                      ],
                    ),
                    items: [
                      SideMenuItem(
                        title: 'Dashboard',
                        onTap: (index, _) {sideMenu.changePage(index);},
                        icon: const Icon(Icons.home),
                        /*badgeContent: const Text('3', style: TextStyle(color: Colors.white),),
                        badgeColor: MainApp.badgecol,*/
                      ),
                      SideMenuItem(
                        title: 'Utilisateurs',
                        onTap: (index, _) {sideMenu.changePage(index);},
                        icon: const Icon(Icons.supervisor_account),
                      ),
                      SideMenuItem(
                        title: 'Dossiers',
                        onTap: (index, _) {sideMenu.changePage(index);},
                        icon: const Icon(Icons.folder_copy_rounded),
                        /*trailing: Container(
                          decoration: const BoxDecoration(
                            color: MainApp.badgecol, borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                            child: Text('New', style: TextStyle(fontSize: 11, color: Colors.white),),
                          )
                        ),*/
                      ),
                      SideMenuItem(
                        title: 'Paramètres',
                        onTap: (index, _) {sideMenu.changePage(index);},
                        icon: const Icon(Icons.settings),
                      ),
                      SideMenuItem(
                        title: 'Déconnexion',
                        onTap: (index, _) {Sessiondata.erase(); Sessiondata.write('IsLogged', 0); Navigator.pushNamed(context, MainApp.login);},
                        icon: const Icon(Icons.exit_to_app),
                      ),
                      /*SideMenuItem(
                        builder: (context, displayMode) { return const Divider(indent: 8.0, endIndent: 8.0,); },
                      ),*/
                    ],
                    footer: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5)),
                        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          child: Text('© MiCee 2024', style: MainApp.styleall.copyWith(color: MainApp.gray, fontSize: 12.5, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (int page) { setState(() { sideMenu.changePage(page); }); },
                      children: [
                        /*1st*/
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 8,),
                              Flex(
                                direction: MediaQuery.of(context).size.width >= 1300 ? Axis.horizontal : Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: headerbox,
                              ),
                              const Divider(indent: 5.0, endIndent: 5.0,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: MediaQuery.of(context).size.height - 240,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center, //mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 15.0,),
                                      Text('Dashboard', style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: MainApp.textwr),),
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: footerligne,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                        /*2nd*/ 
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 8,),
                              Flex(
                                direction: MediaQuery.of(context).size.width >= 1300 ? Axis.horizontal : Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: headerbox,
                              ),
                              const Divider(indent: 5.0, endIndent: 5.0,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: MediaQuery.of(context).size.height - 240,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center, //mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 15.0,),
                                      Padding(padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: searchuserField,),
                                      const SizedBox(height: 3.0,),
                                      Text("$rel résultat(s) de la recherche", style: MainApp.styleall.copyWith(fontSize: 10, fontWeight: FontWeight.bold),),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: Divider(color: MainApp.textwr),), 
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                        child: SizedBox(height: MediaQuery.of(context).size.height - 361, width: MediaQuery.of(context).size.width - 18,
                                          child: FutureBuilder(
                                            future: futuredata,
                                            builder: (BuildContext context, AsyncSnapshot<List<Utilisateur>> users) {
                                              if (users.hasData) {
                                                if(users.data!.isNotEmpty) {
                                                  sfudata = users.data!;
                                                  return ListView.builder(itemCount: users.data?.length, shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.textwr, width: 1.2), ),
                                                        shadowColor: Colors.transparent, color: MainApp.bg, elevation: 5,
                                                        child: ListTile(
                                                          leading: const Icon(ZondIcons.user_solid_circle, color: MainApp.textwr, size: 50, ), //Image.asset('assets/user.png', fit:BoxFit.cover,),
                                                          title: Text('${users.data?[index].Nom}  ${users.data?[index].Prenom}  ${users.data?[index].Email}', style: MainApp.styleall.copyWith(fontSize: 13,),),
                                                          subtitle: Text('${users.data?[index].Adresse} / +${users.data?[index].Tel.split("countryCode: ")[1].split(",")[0]} ${users.data?[index].Tel.split("nsn: ")[1].substring(0, users.data![index].Tel.split("nsn: ")[1].length - 1)}', 
                                                            style: MainApp.styleall.copyWith(fontSize: 11,),),
                                                          trailing: Row(mainAxisSize: MainAxisSize.min,
                                                            children: MediaQuery.of(context).size.width >= 650 ? [
                                                              FloatingActionButton(tooltip: 'Modifier', foregroundColor: MainApp.warning, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                                                shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                                                onPressed: () {
                                                                  setState((){ 
                                                                    if(users.data?[index].Ste != '0'){ _statutController.text = "Entreprise"; en = true; prt = false; }
                                                                    if(users.data?[index].Psr != '0'){ _statutController.text = "Particulier"; en = false; prt = true; }
                                                                  });
                                                                  UserModel.getOneUser(users.data![index].id!).then((val) {
                                                                    id = val.id!; docts = val.docs!; _nomController.text = val.Nom; _prenomController.text = val.Prenom; _hbdController.text = DateFormat('yyyy-MM-dd').format(val.Datenaiss);
                                                                    _emailController.text = val.Email; _addressController.text = val.Adresse; _phoneController.value = PhoneNumber.parse(val.Tel.split('nsn: ')[1].substring(0, val.Tel.split('nsn: ')[1].length - 1), 
                                                                    destinationCountry: IsoCode.fromJson(val.Tel.split('isoCode: ')[1].split(",")[0].split(".")[1]));
                                                                    _loginController.text = val.Login; _passwordController.text = ""; _cpasswordController.text = "";
                                                                    if(val.Ste != '0'){  
                                                                      _nomsteController.text = val.Ste; _fctsteController.text = val.Fonction; _siretsteController.text = val.Siret;
                                                                      _psrController.text = ""; _preController.text = ""; _claController.text = "";
                                                                    }
                                                                    if(val.Psr != '0'){
                                                                      _nomsteController.text = ""; _fctsteController.text = ""; _siretsteController.text = "";
                                                                      _psrController.text = val.Psr; _preController.text = val.Precaire; _claController.text = val.Classique;
                                                                    } 
                                                                  });
                                                                  showDialog(context: context, builder: (BuildContext context){
                                                                    return userform(Colors.white, MainApp.warning, 'MODIF UTILISATEUR', editUserBtn);
                                                                  });
                                                                },
                                                                child: const Icon(Icons.edit,),
                                                              ), const SizedBox(width: 10,), 
                                                              FloatingActionButton(tooltip: 'Supprimer', foregroundColor: MainApp.danger, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                                                shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                                                onPressed: () {
                                                                  UserModel.getOneUser(users.data![index].id!).then((val) {
                                                                    id = val.id!; docts = val.docs!;
                                                                    showDialog(context: context, builder: (context){
                                                                      return userdel(Colors.white, MainApp.danger, 'SUPPR UTILISATEUR', delUserBtn, 'Voulez-vous supprimer ${val.Login} ?');
                                                                    });
                                                                  });
                                                                },
                                                                child: const Icon(Icons.delete,),
                                                              ),
                                                            ] : [],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }else{
                                                  return Center(
                                                    child: Text("Aucun(e)s utilisateur(rise)s trouvé(e)s", style: MainApp.styleall.copyWith(fontSize: 35, fontWeight: FontWeight.bold),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: Divider(color: MainApp.textwr),),
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: footerligne,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                        /*3rd*/
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 8,),
                              Flex(
                                direction: MediaQuery.of(context).size.width >= 1300 ? Axis.horizontal : Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: headerbox,
                              ),
                              const Divider(indent: 5.0, endIndent: 5.0,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: MediaQuery.of(context).size.height - 240,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center, //mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 15.0,),
                                      Padding(padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: searchfolderField,),
                                      const SizedBox(height: 3.0,),
                                      Text("$rel résultat(s) de la recherche", style: MainApp.styleall.copyWith(fontSize: 10, fontWeight: FontWeight.bold),),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: Divider(color: MainApp.textwr),),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                        child: SizedBox(height: MediaQuery.of(context).size.height - 361, width: MediaQuery.of(context).size.width - 18,
                                          child: FutureBuilder(
                                            future: futuredata,
                                            builder: (BuildContext context, AsyncSnapshot<List<Utilisateur>> docsdata) {
                                              //docsdata.data?.removeWhere((w) => w.IdDoc == 0);
                                              if (docsdata.hasData) {
                                                if(docsdata.data!.isNotEmpty) {
                                                  sfddata = docsdata.data!; int z = 0;
                                                  return ListView.builder(itemCount: docsdata.data?.length, shrinkWrap: true,
                                                    itemBuilder: (context, index){
                                                      return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.textwr, width: 1.2), ),
                                                        shadowColor: Colors.transparent, color: MainApp.bg, elevation: 5,
                                                        child: ExpansionTile(iconColor: MainApp.textwr, collapsedIconColor: MainApp.textwr, backgroundColor: MainApp.bg,
                                                          leading: const Icon(AntDesign.folder_open_fill, color: MainApp.textwr, size: 50, ), 
                                                          title: Text(docsdata.data?[index].Ste != '0' ? 
                                                            '${docsdata.data?[index].Ste} / ${docsdata.data?[index].Adresse} / +${docsdata.data?[index].Tel.split("countryCode: ")[1].split(",")[0]} ${docsdata.data?[index].Tel.split("nsn: ")[1].substring(0, docsdata.data![index].Tel.split("nsn: ")[1].length - 1)}' : 
                                                            '${docsdata.data?[index].Psr} / ${docsdata.data?[index].Adresse} / +${docsdata.data?[index].Tel.split("countryCode: ")[1].split(",")[0]} ${docsdata.data?[index].Tel.split("nsn: ")[1].substring(0, docsdata.data![index].Tel.split("nsn: ")[1].length - 1)}', 
                                                            style: MainApp.styleall.copyWith(fontSize: 13,)
                                                          ),
                                                          subtitle: Text('${docsdata.data![index].docs!.length}  Dossier(s)', style: MainApp.styleall.copyWith(fontSize: 11,),),
                                                          children: <Widget>[
                                                            Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1), side: const BorderSide(color: MainApp.bg, width: 1.2), ),
                                                              shadowColor: Colors.transparent, color: MainApp.gray, elevation: 5,
                                                              child: ListView.builder(padding: const EdgeInsets.only(left: 10, right: 10),
                                                                itemCount: docsdata.data![index].docs!.length, shrinkWrap: true, itemBuilder: (BuildContext context, int i) {
                                                                  List<Widget> array = <Widget>[];
                                                                  if(docsdata.data![index].docs!.length > 0){
                                                                    z++;
                                                                    array.add(const Divider(color:MainApp.dark,),);
                                                                    array.add(
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: <Widget>[ 
                                                                          const Icon(AntDesign.file_pdf_outline, size: 50, color: MainApp.textwr,),
                                                                          Flexible(
                                                                            child: SizedBox(width: 250, height: 28,
                                                                              child: Text('  ${docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[0]}\n' 
                                                                                '  Prime : ${docsdata.data?[index].docs![i]['Prime']} €\n',
                                                                                style: MainApp.styleall.copyWith(fontSize: 13.0,), textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            child: SizedBox(width: 350, 
                                                                              child: Text('  Statut : ${(docsdata.data?[index].docs![i]['StatutDoc']['Complement'] == "0") ? "En cours" 
                                                                                : (docsdata.data?[index].docs![i]['StatutDoc']['Instruction'] == "0") ? "Complément" 
                                                                                : (docsdata.data?[index].docs![i]['StatutDoc']['Decision'] == "0") ? "Instruction"
                                                                                : (docsdata.data?[index].docs![i]['StatutDoc']['Decision'] == "1") ? "Décision" : "" }\n'
                                                                                '  Analyse Technique : ${docsdata.data?[index].docs![i]['AnaTech']}\n'
                                                                                '  Analyse Administrative : ${docsdata.data?[index].docs![i]['AnaAdmin']}\n'
                                                                                '  Com Technique : ${docsdata.data?[index].docs![i]['ComTech']}\n'
                                                                                '  Com Administrative : ${docsdata.data?[index].docs![i]['ComAdmin']}\n'
                                                                                '  Synthèse : ${docsdata.data?[index].docs![i]['Synthese']}', 
                                                                                style: MainApp.styleall.copyWith(fontSize: 12.5,), 
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10,),
                                                                          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              FloatingActionButton(tooltip: 'Consulter', foregroundColor: MainApp.success, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                                                                shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                                                                onPressed: () async {
                                                                                  await showDialog(context: context, builder: (BuildContext context){
                                                                                    return pdfviewer(Colors.white, MainApp.textwr, docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[0], base64Decode(docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[1]), 
                                                                                      docsdata.data?[index].Ste != '0' ? "${docsdata.data?[index].Ste}_${docsdata.data?[index].docs![i]['IdDoc']}" : "${docsdata.data?[index].Psr}_${docsdata.data?[index].docs![i]['IdDoc']}");
                                                                                  });
                                                                                },
                                                                                child: const Icon(AntDesign.eye_fill,),
                                                                              ), const SizedBox(width: 10,),
                                                                              FloatingActionButton(tooltip: 'Modifier', foregroundColor: MainApp.warning, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                                                                shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                                                                onPressed: () { 
                                                                                  setState(() { hsd = 162; });
                                                                                  UserModel.getOneUser(docsdata.data![index].id!).then((val) {
                                                                                    id = val.id!; iddoc = int.parse(docsdata.data?[index].docs![i]['IdDoc']); //docts = val.docs!; 
                                                                                    _userController.text = val.name; _nomfichierController.text = docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[0];
                                                                                    pdffile.add(docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[0]); pdffile.add(docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[1]);
                                                                                    if(docsdata.data?[index].docs![i]['StatutDoc']['Complement'] == '0'){ _statutdocController.text = "En cours"; 
                                                                                    } else if(docsdata.data?[index].docs![i]['StatutDoc']['Instruction'] == '0'){ _statutdocController.text = "Complément"; 
                                                                                    } else if(docsdata.data?[index].docs![i]['StatutDoc']['Decision'] == '0'){ _statutdocController.text = "Instruction"; 
                                                                                    } else if(docsdata.data?[index].docs![i]['StatutDoc']['Decision'] == '1'){ _statutdocController.text = "Décision"; }
                                                                                    _anatechController.text = docsdata.data?[index].docs![i]['AnaTech']; _anaadController.text = docsdata.data?[index].docs![i]['AnaAdmin'];
                                                                                    _comtechController.text = docsdata.data?[index].docs![i]['ComTech']; _comadController.text = docsdata.data?[index].docs![i]['ComAdmin'];
                                                                                    _primeController.text = docsdata.data?[index].docs![i]['Prime']; _synController.text = docsdata.data?[index].docs![i]['Synthese'];
                                                                                  });
                                                                                  showDialog(context: context, builder: (BuildContext context){
                                                                                    return folderform(Colors.white, MainApp.warning, 'MODIF DOSSIER', editFolderBtn);
                                                                                  });
                                                                                },
                                                                                child: const Icon(Icons.edit,),
                                                                              ), const SizedBox(width: 10,),
                                                                              FloatingActionButton(tooltip: 'Supprimer', foregroundColor: MainApp.danger, backgroundColor: MainApp.gray, hoverColor: Colors.black12, mini: true,
                                                                                shape: RoundedRectangleBorder(side: const BorderSide(width: 1.25, color: Colors.black12), borderRadius: BorderRadius.circular(100)),
                                                                                onPressed: () {
                                                                                  setState(() { });
                                                                                  UserModel.getOneUser(docsdata.data![index].id!).then((val) {
                                                                                    id = val.id!; iddoc = int.parse(docsdata.data?[index].docs![i]['IdDoc']); //docts = val.docs!;
                                                                                    showDialog(context: context, builder: (context){
                                                                                      return folderdel(Colors.white, MainApp.danger, 'SUPPR DOSSIER', delFolderBtn, 'Voulez-vous supprimer ${docsdata.data?[index].docs![i]['Msg'].split(" ~ ")[0]} ?');
                                                                                    });
                                                                                  });
                                                                                },
                                                                                child: const Icon(Icons.delete,),
                                                                              ),
                                                                            ]
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                  if(docsdata.data![index].docs!.length - 1 == i){ 
                                                                    if(z > 0) array.add(const Divider(color:MainApp.dark,),);
                                                                  }
                                                                  return Padding(padding: const EdgeInsets.only(left: 10.0, right: 10.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: array,),);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                          //trailing: Text('${docsdata.data![index].docs!.length}  Dossier(s)', style: MainApp.styleall.copyWith(fontSize: 11,),),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }else{
                                                  return Center(
                                                    child: Text("Aucuns dossiers trouvés", style: MainApp.styleall.copyWith(fontSize: 35, fontWeight: FontWeight.bold),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), child: Divider(color: MainApp.textwr),),
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: footerligne,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                        /*4th*/
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 8,),
                              Flex(
                                direction: MediaQuery.of(context).size.width >= 1300 ? Axis.horizontal : Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: headerbox,
                              ),
                              const Divider(indent: 5.0, endIndent: 5.0,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: MediaQuery.of(context).size.height - 240,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center, //mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 15.0,),
                                      Text('Paramètres', style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: MainApp.textwr),),
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Container(width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width >= 650 ? 280 : 80), 
                                height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: MainApp.navcolor2, width: 1.2), ),
                                  shadowColor: Colors.transparent, color: Colors.white, elevation: 5,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: footerligne,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
