import 'package:flutter/material.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/services/travel_services.dart';


class TravelList extends StatelessWidget {
  const TravelList({super.key});

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
                              AppRoutes.TRAVEL_EDIT,
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