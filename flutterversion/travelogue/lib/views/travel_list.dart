import 'package:flutter/material.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/services/travel_services.dart';

class TravelList extends StatefulWidget {
  const TravelList({Key? key}) : super(key: key);

  @override
  _TravelListState createState() => _TravelListState();
}

class _TravelListState extends State<TravelList> {
  List<dynamic> _dados = [];

  @override
  void initState() {
    super.initState();
    _buscarDadosDaAPI();
  }

  Future<void> _buscarDadosDaAPI() async {
    final dados = await getTravel();
    setState(() {
      _dados = dados;
    });
  }

  Future<void> _removerViagem(String id) async {
    await deleteTravel(id);
    _buscarDadosDaAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travelogue'),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.TRAVEL_FORM),
            icon: const Icon(Icons.add_circle_outlined),
          ),
          IconButton(
            onPressed: _buscarDadosDaAPI,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dados.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.card_travel)),
            title: Text(_dados[i]['name']),
            subtitle: Text(_dados[i]['dateTravel']),
            trailing: SizedBox(
              width: 150,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.TRAVEL_SEARCH,
                      arguments: _dados[i]['id'],
                    ),
                    icon: const Icon(Icons.travel_explore),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.TRAVEL_EDIT,
                      arguments: _dados[i]['id'],
                    ),
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => _removerViagem(_dados[i]['id']),
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}