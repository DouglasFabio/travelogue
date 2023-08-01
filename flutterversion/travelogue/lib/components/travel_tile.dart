import 'package:flutter/material.dart';
import 'package:travelogue/models/travel.dart';
import 'package:travelogue/routes/app_routes.dart';

class TravelTile extends StatelessWidget {

  final Travel travel;
  const TravelTile(this.travel);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.card_travel)),
      title: Text(travel.name),
      subtitle: Text(travel.travel_date),
      trailing: Container(
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
              icon: Icon(Icons.edit),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () => {}, 
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ], 
       ),
      ),
    );
  }
}