// ignore_for_file: deprecated_member_use, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart'; // https://github.com/bitsdojo/bitsdojo_window/tree/master/bitsdojo_window
import 'package:micee/views/Splashscreen.dart';
import 'package:micee/views/Login.dart';
import 'package:micee/views/Register.dart';
import 'package:micee/views/Dashboard.dart';
import 'package:micee/views/Testpage.dart';

Future main() async {
  await GetStorage.init();

  runApp(const MainApp());

  doWhenWindowReady(() {
    final initialSize = Size(WidgetsBinding.instance.window.physicalSize.width, WidgetsBinding.instance.window.physicalSize.height);
    appWindow.minSize = initialSize; appWindow.size = initialSize;
    appWindow.alignment = Alignment.center; appWindow.title = "MiCee"; 
    //appWindow.maximize();
    appWindow.show();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // app url
  static String baseUrl = "http://192.168.1.53:81/api"; //"http://192.168.1.182:81/api"; //http://localhost:8080/app/v1
  static String splash = '${baseUrl.substring(0, baseUrl.length - 4)}/splash';
  static String login = '${baseUrl.substring(0, baseUrl.length - 4)}/login';
  static String register = '${baseUrl.substring(0, baseUrl.length - 4)}/register';
  static String dashboard = '${baseUrl.substring(0, baseUrl.length - 4)}/dashboard';
  static String forgotPassword = '${baseUrl.substring(0, baseUrl.length - 4)}/forgot_password';
  static String test = '${baseUrl.substring(0, baseUrl.length - 4)}/test';
  static String pdf = '${baseUrl.substring(0, baseUrl.length - 4)}/pdf';

  // textstyle https://fonts.google.com/
  static TextStyle styleall = const TextStyle(color: Color(0xff3a8ac5),);

  // regexp
  static RegExp regexp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
  /*
  /^(?=.*[A-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@])(?!.*[iIoO])\S{6,12}$/

  /^ ces symboles placés en premier indique tout simplement le début de notre chaîne.
  (?=.*[A-z]) permet de tester la présence de lettre (minuscule ou majuscule).
  (?=.*[a-z]) permet de tester la présence de minuscules.
  (?=.*[A-Z]) permet de tester la présence de majuscules.
  (?=.*[0-9]) permet de tester la présence de chiffres.
  (?=.*[$@]) permet de tester la présence de caractères spéciaux parmi $ et @.
  (?!.*[iIoO]) permet de tester l’absence des lettres i, I, o et O.
  \S{6,12} permet de définir une longueur minimal de 6 caractères et maximal de 12.
  $/ vous permet d’indiquer la fin de notre chaîne.
   */

  // app color
  static const Color appcolor = Color(0xFF2174B9), success = Color(0xFF00B749), secondary = Color(0xFFB33CFD), info = Color(0xFF39C0ED),
  warning = Color(0xFFFFAA00), danger = Color(0xFFF93152), indigo = Color(0xFF6710F2), unique = Color(0xFF3F729B),
  gray = Color(0xB3FFFFFF), dark = Color(0xFF262626), bg = Color(0xFFE6E9EE), bg1 = Color(0xFF042B59),
  bg2 = Color(0xFF043875), bg3 = Color(0xFF0553B1), badgecol = Color(0xffec4a79), 
  textwr = Color(0xff3a8ac5), navcolor1 = Color(0xFFA5D6A7), navcolor2 = Color(0xFF00695C), navcolor3 = Color(0xFF2E7D32);

  // win buttons colors
  static final buttonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: navcolor3,
    mouseDown: navcolor3,
    iconMouseOver: Colors.white,
    iconMouseDown: Colors.white
  );

  static final closeButtonColors = WindowButtonColors(
    mouseOver: danger,
    mouseDown: danger,
    iconNormal: Colors.white,
    iconMouseOver: Colors.white
  );

  // Custom msgbox
  static AlertDialog msg (Color bg, ico, Color c, String s) {
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
  static ThemeData ctheme () {
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

  // others //
  static List<String> useroption = [];

  // mois
  static const List<String> mois = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']; 
  // jours
  static const Map<String, String> sday = {'Mon':'Lun', 'Tue':'Mar', 'Wed':'Mer', 'Thu':'Jeu', 'Fri':'Ven', 'Sat':'Sam', 'Sun':'Dim'};
  // jours
  static const Map<String, int> adays = {'Monday':1, 'Tuesday':2, 'Wednesday':3, 'Thursday':4, 'Friday':5, 'Saturday':6, 'Sunday':7};

  // for mysql authenticate
  static final GlobalKey<FormState> mysqlform = GlobalKey<FormState>();
  static final TextEditingController hostController = TextEditingController(), portController = TextEditingController(), userController = TextEditingController(), 
    dbController = TextEditingController(), passwordController = TextEditingController(), ceController = TextEditingController();
  
  // Host
  static final hostField = SizedBox(
    height: 32.5,
    child: TextFormField(
      autofocus: false, controller: hostController, 
      cursorColor: MainApp.textwr,              
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
        labelText: 'Host', labelStyle: MainApp.styleall.copyWith(),
        suffixIcon: const Icon(Clarity.host_solid, size: 18, color: MainApp.textwr,),
        suffixIconConstraints: const BoxConstraints(minWidth: 35,),
      ),
      enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false, 
      style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
      validator: (value) { return (value == null || value.isEmpty) ? 'Host incorrect' : null; },
    )
  );

  // Port
  static final portField = SizedBox(
    height: 32.5,
    child: TextFormField(
      autofocus: false, controller: portController,   
      cursorColor: MainApp.textwr,              
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
        labelText: 'Port', labelStyle: MainApp.styleall.copyWith(),
        suffixIcon: const Icon(AntDesign.project_fill, size: 18, color: MainApp.textwr,),
        suffixIconConstraints: const BoxConstraints(minWidth: 35,),
      ),
      enabled: true, enableSuggestions: false, keyboardType: TextInputType.number, obscureText: false, readOnly: false, 
      style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
      validator: (value) { return (value == null || value.isEmpty) ? 'Port incorrect' : null; }, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    )
  );

  // User
  static final userField = SizedBox(
    height: 32.5,
    child: TextFormField(
      autofocus: false, controller: userController,   
      cursorColor: MainApp.textwr,              
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
        labelText: 'Username', labelStyle: MainApp.styleall.copyWith(),
        suffixIcon: const Icon(FontAwesome.user_solid, size: 18, color: MainApp.textwr,),
        suffixIconConstraints: const BoxConstraints(minWidth: 35,),
      ),
      enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false, 
      style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
      validator: (value) { return (value == null || value.isEmpty) ? 'Username incorrect' : null; },
    )
  );

  // PasswordField
  static final passwordField = SizedBox(
    height: 32.5,
    child: TextFormField(              
      autofocus: false, controller: passwordController,
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

  // Db
  static final dbField = SizedBox(
    height: 32.5,
    child: TextFormField(
      autofocus: false, controller: dbController,   
      cursorColor: MainApp.textwr,              
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
        labelText: 'Database name', labelStyle: MainApp.styleall.copyWith(),
        suffixIcon: const Icon(FontAwesome.database_solid, size: 18, color: MainApp.textwr,),
        suffixIconConstraints: const BoxConstraints(minWidth: 35,),
      ),
      enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false, 
      style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
      validator: (value) { return (value == null || value.isEmpty) ? 'Database name incorrect' : null; },
    )
  );

  // Charencoder
  static final ceField = SizedBox(
    height: 32.5,
    child: TextFormField(
      autofocus: false, controller: ceController,   
      cursorColor: MainApp.textwr,              
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MainApp.textwr,),),
        fillColor: MainApp.textwr, focusColor: MainApp.textwr,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.only(left: 9.5), hintStyle: MainApp.styleall.copyWith(),
        labelText: 'Character encoding', labelStyle: MainApp.styleall.copyWith(),
        suffixIcon: const Icon(MingCute.letter_spacing_fill, size: 18, color: MainApp.textwr,),
        suffixIconConstraints: const BoxConstraints(minWidth: 35,),
      ),
      enabled: true, enableSuggestions: false, keyboardType: TextInputType.text, obscureText: false, readOnly: false, 
      style: MainApp.styleall.copyWith(), toolbarOptions: const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: false,),
      validator: (value) { return (value == null || value.isEmpty) ? 'Character encoding incorrect' : null; },
    )
  );
  
  // Custom mysql
  static AlertDialog mysqldialog (Color bg, Color c, String titre, SizedBox btn1, SizedBox btn2) {
    return AlertDialog(
      //title: Text(titre, style: const TextStyle(color: MyApp.success, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 15.0)),
      //actions: [ MaterialButton(color: MyApp.success, onPressed: (){ Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 11.0)),) ],
      //actionsAlignment: MainAxisAlignment.center,
      backgroundColor: bg,
      content: SizedBox(
        height: 472, width: 320,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 20),
          child: Form(
            key: mysqlform,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Big Text
                Text(titre, style: MainApp.styleall.copyWith(fontSize: 20, fontWeight: FontWeight.bold),),

                const Divider(color: MainApp.textwr), const SizedBox(height: 20.0,),

                hostField, const SizedBox(height: 15.0), portField, const SizedBox(height: 15.0), 

                userField, const SizedBox(height: 15.0), passwordField, const SizedBox(height: 15.0), 
                
                dbField, const SizedBox(height: 15.0), ceField, const SizedBox(height: 20.0),

                const Divider(color: MainApp.textwr), const SizedBox(height: 5.0,),

                btn1, const SizedBox(height: 10.0,), btn2
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: c, width: 1.2),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          title: 'MiCee',
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(cursorColor: MainApp.textwr, selectionColor: MainApp.dark, selectionHandleColor: MainApp.dark,),
            colorScheme: const ColorScheme.dark(onPrimary: Colors.black, onSurface: Colors.white, primary: Colors.white),
            primaryColor: appcolor,
            primarySwatch: const MaterialColor(
              0xFFFFFFFF,
              <int, Color>{50: Color(0xFFFFFFFF), 100: Color(0xFFFFFFFF), 200: Color(0xFFFFFFFF), 300: Color(0xFFFFFFFF),
                400: Color(0xFFFFFFFF), 500: Color(0xFFFFFFFF), 600: Color(0xFFFFFFFF), 700: Color(0xFFFFFFFF),
                800: Color(0xFFFFFFFF), 900: Color(0xFFFFFFFF),
              },
            ),
            useMaterial3: false,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            dialogBackgroundColor: const Color.fromARGB(250, 0, 0, 0),
            //scaffoldBackgroundColor: Colors.blue.withOpacity(0.1),
          ),
          darkTheme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(cursorColor: MainApp.textwr, selectionColor: MainApp.dark,  selectionHandleColor: MainApp.dark,),
            useMaterial3: false,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
          ),
          themeMode: ThemeMode.system,
          initialRoute: splash,
          routes: {
            splash: (context) => const SplashscreenPage(),
            login: (context) => const LoginPage(),
            register: (context) => const RegisterPage(),
            dashboard: (context) => const DashboardPage(),
            test: (context) => const TestPage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...PhoneFieldLocalization.delegates
          ],
          supportedLocales: const [
            Locale("fr", "FR"), Locale('en', 'US'),
          ],
          locale: const Locale('fr'),
          /*home: Scaffold(
            body: WindowBorder(
              color: Colors.white, width: 1.5,
              child: const CenterSide(),
            ),
          ),*/
        );
      }
    );
  }
}

class CenterSide extends StatelessWidget {
  const CenterSide({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [MainApp.navcolor2, MainApp.navcolor3],
          stops: [0, 2], tileMode: TileMode.clamp,
        ),
      ),
      child: WindowTitleBarBox(
        child: Row(
          children: [
            const SizedBox(width: 5.0,),
            Image.asset("assets/micee-favicon-white.png", height: 25, width: 30, fit: BoxFit.contain), const SizedBox(width: 7.5,),
            Text("MiCee", style: MainApp.styleall.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),), 
            Expanded(child: MoveWindow()), const WindowButtons()
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: MainApp.buttonColors),
        appWindow.isMaximized ? RestoreWindowButton(colors: MainApp.buttonColors, onPressed: maximizeOrRestore,) : MaximizeWindowButton(colors: MainApp.buttonColors, onPressed: maximizeOrRestore,),
        CloseWindowButton(colors: MainApp.closeButtonColors),
      ],
    );
  }
}
// https://youtu.be/FImV8Qpe66k
