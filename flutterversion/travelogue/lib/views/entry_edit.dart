import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String _visitedLocal = '';
  DateTime? _dateVisit;
  String _description = '';
  String _midiaPath = '';
  List<String> _imagePaths = [];
  bool _btnClicked = false;
  TextStyle _registroImagensStyle =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imagePaths = pickedFiles.map((file) => file.path).toList();
        _midiaPath = _imagePaths.join(',');
        _btnClicked = true;
      });
    }
  }

  Future<void> _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
        _midiaPath = _imagePaths.join(',');
        _btnClicked = true;
      });
    }
  }

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
    final travelData = await getEntryEdit(idEntry);
    if (this.mounted) {
      setState(() {
        //_id = travelData['id'];
        //_visitedLocal = travelData['visitedLocal'];
        //controladorTexto.text = _name;
        //_dateTravel = travelData['dateTravel'];
      });
    }
  }

  Future<void> _atualizarEntrada(formData) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final idEntry = ModalRoute.of(context)!.settings.arguments as String;
      final formData = {
        'id': idEntry,
        'visitedLocal': _visitedLocal,
        'dateVisit': _dateVisit,
        'description': _description,
        'midiaPath': _midiaPath
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
        title: Text('Editar - $_visitedLocal'),
        actions: [
          IconButton(
            onPressed: () {
              if (_dateVisit == null) {
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
                  'id': idEntry,
                  'visitedLocal': _visitedLocal,
                  'description': _description,
                  'midiaPath': _midiaPath,
                  'dateVisit': _dateVisit != null
                      ? DateFormat('yyyy-MM-dd').format(_dateVisit!)
                      : null,
                };
                _atualizarEntrada(formData);
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
            child: Column(children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Local visitado'),
                onSaved: (value) => _visitedLocal = value!,
              ),
              TextFormField(
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value!,
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
                        initialDate: _dateVisit ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _dateVisit = selectedDate;
                        });
                      }
                    },
                    child: Text(
                      _dateVisit != null
                          ? DateFormat('dd/MM/yyyy').format(_dateVisit!)
                          : 'Selecione a Data da Visita',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26), // Adiciona um espaço entre os widgets
              Text(
                'REGISTRO DE IMAGENS',
                style: _registroImagensStyle,
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Abrir galeria'),
              ),
              ElevatedButton(
                onPressed: _camera,
                child: const Icon(Icons.camera_alt),
              ),
              ..._imagePaths.map(
                (path) => InteractiveViewer(
                  child: Image.file(
                    File(path),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
