import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/services/entries_services.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({Key? key}) : super(key: key);

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _form = GlobalKey<FormState>();
  String _visitedLocal = '';
  DateTime? _dateVisit;
  String _description = '';
  String _midiaPath = '';
  List<String> _imagePaths = [];
  bool _btnClicked = false;
  TextStyle _registroImagensStyle =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

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

  @override
  Widget build(BuildContext context) {
    final idViagemSelecionada =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Entrada"),
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
              final isValid = _form.currentState!.validate();
              if (isValid) {
                _form.currentState?.save();
                final formData = {
                  'visitedLocal': _visitedLocal,
                  'dateVisit': _dateVisit,
                  'description': _description,
                  'midiaPath': _midiaPath,
                  'codTravel': idViagemSelecionada
                };
                if (_imagePaths.isEmpty) {
                  // Altere a cor do texto para vermelho e exiba um alerta
                  setState(() {
                    _registroImagensStyle = const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Erro'),
                        content: const Text(
                            'Por favor, selecione pelo menos uma imagem.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  });
                  return;
                }
                postEntry(formData);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _form,
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