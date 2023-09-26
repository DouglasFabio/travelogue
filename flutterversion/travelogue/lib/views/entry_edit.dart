import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:travelogue/services/entries_services.dart';

class EntryEdit extends StatefulWidget {
  const EntryEdit({Key? key}) : super(key: key);

  @override
  _EntryEditState createState() => _EntryEditState();
}

class _EntryEditState extends State<EntryEdit> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _title = '';
  TextEditingController controladorTexto = TextEditingController();
  DateTime? _dateTravel;
  final LocalAuthentication _localAuth = LocalAuthentication();

  //Future<bool> _authenticateUser() async {
  //  bool authenticated = false;
  //  try {
  //    authenticated = await _localAuth.authenticate(
  //       localizedReason: 'Por favor, autentique para atualizar os dados',
  //        options: const AuthenticationOptions(
  //            useErrorDialogs: true, stickyAuth: true));
  // } catch (e) {
  //    print(e);
  //  }
  //  return authenticated;
 // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final idEntry = ModalRoute.of(context)!.settings.arguments as String;
    _loadData(idEntry);
  }

  Future<void> _loadData(String idEntry) async {
    final travelData = await getEntry(idEntry);
    if (this.mounted) {
      setState(() {
        _name = travelData['visitedLocal'];
        _title = travelData['name'];
        controladorTexto.text = _name;
        //_dateTravel = travelData['dateTravel'];
      });
    }
  }

  Future<void> _atualizarViagem(formData) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final idEntry = ModalRoute.of(context)!.settings.arguments as String;
      final formData = {
        'id': idEntry,
        'name': _name,
        'dateTravel': _dateTravel
      };

      //bool didAuthenticate = await _authenticateUser();

      //if (didAuthenticate) {
        await putEntry(idEntry, formData);
        if (mounted) {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        }
      //} else {
      //  print('Falha na autenticação do usuário');
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    final idEntry = ModalRoute.of(context)!.settings.arguments as String;
    getEntry(idEntry);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar - $_title'),
        actions: [
          IconButton(
            onPressed: () {
              if (_dateTravel == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Por favor, selecione uma data.')),
                );
                return;
              }
              final isValid = _formKey.currentState!.validate();
              if (isValid) {
                _formKey.currentState?.save();
                final formData = {
                  'name': _name,
                  'dateTravel': _dateTravel != null
                      ? DateFormat('yyyy-MM-dd').format(_dateTravel!)
                      : null,
                };
                _atualizarViagem(formData);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha os widgets à esquerda
                children: [
                  TextFormField(
                    controller: controladorTexto,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha este campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Nome'),
                    onSaved: (value) => _name = value!,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Data:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(
                          width:
                              14), // Adiciona algum espaço entre o rótulo e o texto
                      TextButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _dateTravel ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _dateTravel = selectedDate;
                            });
                          }
                        },
                        child: Text(
                          _dateTravel != null
                              ? DateFormat('dd/MM/yyyy').format(_dateTravel!)
                              : 'Selecione a Data da Viagem',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
