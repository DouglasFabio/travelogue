import 'package:flutter/material.dart';
import 'package:travelogue/services/entries_services.dart';
import 'package:travelogue/services/travel_services.dart';

class EntryForm extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  String _visitedLocal = '';
  DateTime? _dateVisit;
  String _description = ''; 
  String _midiaPath = '';


  EntryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Entrada'),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState!.validate();
              if(isValid){
                _form.currentState?.save();
                final formData = {
                  'visitedLocal': _visitedLocal,
                  'dateVisit': _dateVisit,
                  'description': _description,
                  'midiaPath': _midiaPath,
                  'codTravel': 'colocarID'
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
          child: Column(
            children: [
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
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
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Descrição'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Links para Midias'),
                onSaved: (value) => _midiaPath = value!,
              ),
            ]
          ) ,
        )
      ),
    );
  }
}