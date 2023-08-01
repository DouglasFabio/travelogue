import 'package:flutter/material.dart';
import 'package:travelogue/components/travel_tile.dart';
import 'package:travelogue/data/dummy_travels.dart';

class TravelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travels = {...DUMMY_TRAVELS};

    return Scaffold(
      appBar: AppBar(
        title: Text('Travelogue'),
        actions: <Widget>[
          IconButton(
            onPressed: () => {}, 
            icon: Icon(Icons.add_circle_outlined),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: travels.length,
        itemBuilder: (context, i) => TravelTile(travels.values.elementAt(i)),
        ),
    );
  }
}