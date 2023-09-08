import 'package:flutter/material.dart';
import 'dart:io';
import 'package:travelogue/services/entries_services.dart';


class EntryGallery extends StatefulWidget {
  const EntryGallery({Key? key}) : super(key: key);

  @override
  _EntryGalleryState createState() => _EntryGalleryState();
}

class _EntryGalleryState extends State<EntryGallery> {
  List<dynamic> _dados = [];

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final idEntry =
      ModalRoute.of(context)!.settings.arguments as String;
  _buscarDadosDaAPI(idEntry);
}

  Future<void> _buscarDadosDaAPI(idEntry) async {
    final dados = await getImages(idEntry);
    setState(() {
      _dados = dados;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria'),
      ),
      body: GridView.builder(
        itemCount: _dados.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Image.file(
            File(_dados[index].split(',')),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
