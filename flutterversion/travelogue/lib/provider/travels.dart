import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travelogue/data/dummy_travels.dart';
import 'package:travelogue/models/travel.dart';

class TravelsProvider with ChangeNotifier {
  final Map<String, Travel> _items = {...DUMMY_TRAVELS};

  List<Travel> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Travel byIndex(int i){
    return _items.values.elementAt(i);
  }

  void put(Travel travel){
    if(travel == null){
      return;
    }

    // Se o ID estiver preenchido, ou existir na lista, então UPDATE.
    if(travel.id != null && travel.id.trim().isNotEmpty && _items.containsKey(travel.id)){
      _items.update(travel.id, (_) => Travel(name: travel.name, travel_date: travel.travel_date));
    }else{
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(id, () => Travel(
        id: id, 
        name: travel.name, 
        travel_date: travel.travel_date
        )
      );
    }

    notifyListeners();
  }

  void delete(Travel travel){
    if(travel != null && travel.id != null){
      _items.remove(travel.id);
      notifyListeners();
    }
  }
}