import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imagePaths = pickedFiles.map((file) => file.path).toList();
        _midiaPath = _imagePaths.join(',');
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final idViagemSelecionada =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(idViagemSelecionada),
        actions: [
          IconButton(
            onPressed: () {
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
              InputDatePickerFormField(
                fieldLabelText: 'Data Visita',
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                onDateSaved: (value) => _dateVisit = value,
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
              const SizedBox(height: 16), // Adiciona um espaço entre os widgets
              const Text(
                'REGISTRO DE IMAGENS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Abrir galeria'),
              ),
              ElevatedButton(
                onPressed: _camera,
                child: const Text('Tirar Foto com a Câmera'),
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
