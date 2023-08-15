import 'dart:convert';
import 'package:flutter/material.dart';
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
              itemBuilder: (context, i){
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.card_travel)),
                  title: Text(snapshot.data![i]['name']),
                  subtitle: Text(snapshot.data![i]['dateTravel']),
                  trailing: SizedBox(
                    width: 100,
                    child:Row( 
                      children: <Widget>[
                        IconButton(
                          onPressed: () => {
                            Navigator.of(context).pushNamed(
                              AppRoutes.TRAVEL_FORM,
                              arguments: snapshot.data![i]['id'],
                            )
                          }, 
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: () => {}, 
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ], 
                  ),
                  ),
                );
              }
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