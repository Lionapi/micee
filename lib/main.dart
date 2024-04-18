// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:micee/views/Splashscreen.dart';
import 'package:micee/views/Login.dart';
import 'package:micee/views/Register.dart';
import 'package:micee/views/Dashboard.dart';
import 'package:micee/views/Testpage.dart';

Future main() async {
  await GetStorage.init();

  runApp(const MainApp());
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
  
  //
  static List<String> useroption = [];

  // mois
  static const List<String> mois = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']; 
  // jours
  static const Map<String, String> sday = {'Mon':'Lun', 'Tue':'Mar', 'Wed':'Mer', 'Thu':'Jeu', 'Fri':'Ven', 'Sat':'Sam', 'Sun':'Dim'};
  // jours
  static const Map<String, int> adays = {'Monday':1, 'Tuesday':2, 'Wednesday':3, 'Thursday':4, 'Friday':5, 'Saturday':6, 'Sunday':7};

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
          //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      }
    );
  }
}
// https://youtu.be/FImV8Qpe66k
