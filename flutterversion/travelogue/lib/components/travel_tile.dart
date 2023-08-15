import 'package:flutter/material.dart';
import 'package:travelogue/models/travel.dart';
import 'package:travelogue/routes/app_routes.dart';

class TravelTile extends StatelessWidget {

  final Travel travel;
  const TravelTile(this.travel, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.card_travel)),
      title: Text(travel.name),
      subtitle: Text(travel.travelDate),
      trailing: SizedBox(
        width: 100,
        child:Row( 
          children: <Widget>[
            IconButton(
              onPressed: () => {
                Navigator.of(context).pushNamed(
                  AppRoutes.TRAVEL_FORM,
                  arguments: travel,
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
}