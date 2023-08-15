import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/provider/travels.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/views/travel_form.dart';
import 'package:travelogue/views/travel_list.dart';

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
    return ChangeNotifierProvider(
      create: (context) => TravelsProvider(), 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travelogue Dev Mob. II',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.HOME: (_) => const TravelList(),
          AppRoutes.TRAVEL_FORM: (context) => TravelForm()
        },
      ),
    );
  }
}
