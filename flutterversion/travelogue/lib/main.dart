import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/provider/travels.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/views/travel_form.dart';
import 'package:travelogue/views/travel_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TravelsProvider(), 
      child: MaterialApp(
        title: 'Travelogue Dev Mob. II',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.HOME: (_) => TravelList(),
          AppRoutes.TRAVEL_FORM: (context) => TravelForm()
        },
      ),
    );
  }
}
