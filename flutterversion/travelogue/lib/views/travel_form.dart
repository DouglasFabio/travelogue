import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelogue/models/travel.dart';
import 'package:travelogue/provider/travels.dart';

class TravelForm extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Viagens'),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState!.validate();

              if(isValid){
                _form.currentState?.save();
                Provider.of<TravelsProvider>(context, listen: false).put(
                  Travel(
                    id: _formData['id'],
                    name: _formData['name']!, 
                    travel_date: _formData['travel_date']!,
                  ),
                ); 
                Navigator.of(context).pop();
              }  
            }, 
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
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
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _formData['name'] = value!,
              ),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Data Viagem'),
                onSaved: (value) => _formData['travel_date'] = value!,
              ),
            ]
          ) ,
        )
      ),
    );
  }
}