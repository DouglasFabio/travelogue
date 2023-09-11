import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelogue/services/travel_services.dart';

class TravelForm extends StatefulWidget {
  TravelForm({Key? key}) : super(key: key);

  @override
  _TravelFormState createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final _form = GlobalKey<FormState>();
  String _name = '';
  DateTime? _dateTravel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Viagens'),
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
              final isValid = _form.currentState!.validate();
              if (isValid) {
                _form.currentState?.save();
                final formData = {
                  'name': _name,
                  'dateTravel': _dateTravel != null
                      ? DateFormat('yyyy-MM-dd').format(_dateTravel!)
                      : null,
                };
                postTravel(formData);
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
          key: _form,
          child: Column(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha os widgets à esquerda
                children: [
                  TextFormField(
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