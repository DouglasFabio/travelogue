import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:travelogue/routes/app_routes.dart';
import 'package:travelogue/services/entries_services.dart';

class TravelSearch extends StatefulWidget {
  const TravelSearch({Key? key}) : super(key: key);

  @override
  _TravelListState createState() => _TravelListState();
}

class _TravelListState extends State<TravelSearch> {
  List<dynamic> _dados = [];

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> _authenticateUser() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
         localizedReason: 'Por favor, autentique para atualizar os dados',
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));
   } catch (e) {
      print(e);
    }
    return authenticated;
  }

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

  Future<void> _removerEntrada (String id) async {
    bool didAuthenticate = await _authenticateUser();

    if (didAuthenticate) {
    await deleteEntry(id);
    final idViagemSelecionada =
      ModalRoute.of(context)!.settings.arguments as String;
  _buscarDadosDaAPI(idViagemSelecionada);
    } else {
      print('Falha na autenticação do usuário');
    }
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
              width: 150,
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.ENTRY_GALLERY,
                      arguments: _dados[i]['id'],
                    ),
                    icon: const Icon(Icons.collections),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.ENTRY_EDIT,
                      arguments: _dados[i]['id'],
                    ),
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () => _removerEntrada(_dados[i]['id']),
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