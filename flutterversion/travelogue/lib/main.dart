import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/views/entry_form.dart';
import 'package:travelogue/views/entry_gallery.dart';
import 'package:travelogue/views/travel_edit_form.dart';
import 'package:travelogue/views/travel_form.dart';
import 'package:travelogue/views/travel_list.dart';
import 'package:travelogue/views/travel_search.dart';

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Travelogue Dev Mob. II',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        AppRoutes.HOME: (_) => const TravelList(),
        AppRoutes.TRAVEL_FORM: (context) => TravelForm(),
        AppRoutes.TRAVEL_EDIT: (context) => const TravelEdit(),
        AppRoutes.TRAVEL_SEARCH: (context) => const TravelSearch(),
        AppRoutes.ENTRY_FORM:(context) => const EntryForm(),
        AppRoutes.ENTRY_GALLERY:(context) => const EntryGallery()
      },
    );
  }
}
