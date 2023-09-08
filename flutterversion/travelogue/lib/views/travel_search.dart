import 'package:flutter/material.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/services/entries_services.dart';

class TravelSearch extends StatefulWidget {
  const TravelSearch({Key? key}) : super(key: key);

  @override
  _TravelListState createState() => _TravelListState();
}

class _TravelListState extends State<TravelSearch> {
  List<dynamic> _dados = [];

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final idViagemSelecionada =
      ModalRoute.of(context)!.settings.arguments as String;
  _buscarDadosDaAPI(idViagemSelecionada);
}

  Future<void> _buscarDadosDaAPI(idViagemSelecionada) async {
    final dados = await getEntry(idViagemSelecionada);
    setState(() {
      _dados = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final idViagemSelecionada =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Entries'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.ENTRY_FORM,
                arguments: idViagemSelecionada),
            icon: const Icon(Icons.add_circle_outlined),
          ),
          IconButton(
            onPressed: () {
              _buscarDadosDaAPI(idViagemSelecionada);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dados.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.travel_explore)),
            title: Text(_dados[i]['visitedLocal']),
            subtitle: Text(_dados[i]['dateVisit']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.TRAVEL_EDIT,
                      arguments: _dados[i]['id'],
                    ),
                    icon: const Icon(Icons.collections),
                    color: Colors.blue,
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
