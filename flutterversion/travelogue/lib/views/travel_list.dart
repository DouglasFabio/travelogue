import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/components/travel_tile.dart';
import 'package:travelogue/provider/travels.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:http/http.dart' as http;

class TravelList extends StatelessWidget {
  const TravelList({super.key});


  Future<List> getTravel() async {

    var url = Uri.parse('http://10.0.2.2:5000/api/Viagem');
    var response = await http.get(url);

    if(response.statusCode == 200){
      return jsonDecode(utf8.decode(response.bodyBytes));
    }else{
      throw Exception('Erro ao carregar');
    }

  }

  @override
  Widget build(BuildContext context) { 
    final TravelsProvider travels = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travelogue'),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.of(context).pushNamed(AppRoutes.TRAVEL_FORM)
            }, 
            icon: const Icon(Icons.add_circle_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: getTravel(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(
              child: Text('Erro ao carregar dados.'),
            );
          }
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) => TravelTile(travels.byIndex(i)),
              //itemCount: travels.count,
              //itemBuilder: (context, i) => TravelTile(travels.byIndex(i)),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}