import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
    final idEntry = ModalRoute.of(context)!.settings.arguments as String;
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
    // Achatando a lista de caminhos de arquivos
    var allMidiaPaths = _dados.expand((item) {
      var midiaPath = item['midiaPath'];
      if (midiaPath is String && midiaPath.isNotEmpty) {
        return midiaPath.split(',');
      } else {
        return const Iterable.empty();
      }
    }).toList();

    if (allMidiaPaths.isEmpty) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria'),
      ),
      body: GridView.builder(
        itemCount: allMidiaPaths.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: PhotoView(
                    imageProvider: FileImage(File(allMidiaPaths[index])),
                  ),
                ),
              );
            },
            child: Image.file(
              File(allMidiaPaths[index]),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}