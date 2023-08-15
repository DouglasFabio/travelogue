import 'package:flutter/material.dart';

class TravelEdit extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  TravelEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edição de viagens'),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState!.validate();

              if(isValid){
                _form.currentState?.save(); 
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