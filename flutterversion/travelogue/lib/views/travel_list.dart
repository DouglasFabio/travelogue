import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/components/travel_tile.dart';

class TravelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travels = Provider.of(context);

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