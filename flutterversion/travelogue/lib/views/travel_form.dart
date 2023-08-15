import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/models/travel.dart';
import 'package:travelogue/provider/travels.dart';

class TravelForm extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  TravelForm({super.key});

  void _loadFormData(Travel travelLoad){
    _formData['id'] = travelLoad.id;
    _formData['name'] = travelLoad.name;
    _formData['travel_date'] = travelLoad.travelDate;
  }

  @override
  Widget build(BuildContext context) {

    final travel = ModalRoute.of(context)!.settings.arguments;
    
    //_loadFormData(travel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Viagens'),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState!.validate();

              if(isValid){
                _form.currentState?.save();
                Provider.of<TravelsProvider>(context, listen: false).put(
                  Travel(
                    id: ObjectId,
                    name: _formData['name']!, 
                    travelDate: _formData['travelDate']!,
                  ),
                ); 
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
                initialValue: _formData['name'],
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _formData['name'] = value!,
              ),
              TextFormField(
                initialValue: _formData['travelDate'],
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Data Viagem'),
                onSaved: (value) => _formData['travelDate'] = value!,
              ),
            ]
          ) ,
        )
      ),
    );
  }
}