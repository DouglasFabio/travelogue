import 'package:flutter/material.dart';
import 'package:travelogue/services/travel_services.dart';

class TravelForm extends StatelessWidget {

  final _form = GlobalKey<FormState>();
  String _name = '';
  DateTime? _dateTravel;

  TravelForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Viagens'),
        actions: [
          IconButton(
            onPressed: () {
              final isValid = _form.currentState!.validate();
              if(isValid){
                _form.currentState?.save();
                final formData = {
                  'name': _name,
                  'dateTravel': _dateTravel
                };
                postTravel(formData); 
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
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _name = value!,
              ),
              InputDatePickerFormField(
                fieldLabelText: 'Data Viagem',
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                onDateSaved: (value) => _dateTravel = value,
              ),
            ]
          ) ,
        )
      ),
    );
  }
}