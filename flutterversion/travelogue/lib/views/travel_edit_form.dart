import 'package:flutter/material.dart';
import 'package:travelogue/services/travel_services.dart';

class TravelEdit extends StatefulWidget {
  const TravelEdit({Key? key}) : super(key: key);

  @override
  _TravelEditState createState() => _TravelEditState();
}

class _TravelEditState extends State<TravelEdit> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime? _dateTravel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final idTravel = ModalRoute.of(context)!.settings.arguments as String;
    _loadData(idTravel);
  }

  Future<void> _loadData(String idTravel) async {
    final travelData = await getOneTravel(idTravel);
    setState(() {
      _name = travelData[0];
      _dateTravel = DateTime.parse(travelData[1]);
    });
  }

  Future<void> _atualizarViagem() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final idTravel = ModalRoute.of(context)!.settings.arguments as String;
      final formData = {'name': _name, 'dateTravel': _dateTravel};
      await putTravel(idTravel, formData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edição de viagens'),
        actions: [
          IconButton(
            onPressed: () => _atualizarViagem(),
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
              TextFormField(
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha este campo';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _name = value!,
              ),
              InputDatePickerFormField(
                initialDate: _dateTravel!,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                fieldLabelText: 'Data Viagem',
                onDateSaved: (value) => _dateTravel = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
