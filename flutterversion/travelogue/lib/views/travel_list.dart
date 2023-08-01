import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/components/travel_tile.dart';
import 'package:travelogue/models/travel.dart';
import 'package:travelogue/provider/travels.dart';
import 'package:travelogue/routes/app_routes.dart';

class TravelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TravelsProvider travels = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Travelogue'),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.of(context).pushNamed(AppRoutes.TRAVEL_FORM)
            }, 
            icon: Icon(Icons.add_circle_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: travels.count,
        itemBuilder: (context, i) => TravelTile(travels.byIndex(i)),
        ),
    );
  }
}