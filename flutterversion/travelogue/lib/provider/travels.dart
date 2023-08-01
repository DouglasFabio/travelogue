import 'dart:ffi';

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
}