import 'dart:convert';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var urlEntrada = Uri.parse('https://10.0.2.2:7298/api/Entrada/');
final client = http.Client();


Future<List> getImages(String idEntry) async {
  final url = 'https://10.0.2.2:7298/api/Entrada/$idEntry';
  var response = await http.get(Uri.parse(url));
  
  if(response.statusCode == 200){
    return jsonDecode(utf8.decode(response.bodyBytes));
  }else{
    throw Exception('Erro ao carregar');
  }
}


Future<List> getEntries(String idViagem) async {
  var response = await http.get(urlEntrada);

  if(response.statusCode == 200){
    return jsonDecode(utf8.decode(response.bodyBytes));
  }else{
    throw Exception('Erro ao carregar');
  }

}

Future<List> getEntry(String idViagem) async {
  final url = '$urlEntrada$idViagem';
  var response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    return jsonDecode(utf8.decode(response.bodyBytes));
  }else{
    throw Exception('Erro ao carregar');
  }

}

Future<void> postEntry(Map<String, dynamic> formData) async {
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode(formData, toEncodable: (value) {
    if (value is DateTime) {
      return value.toIso8601String().substring(0,10);
    }
    return value;
  });

  final response = await client.post(urlEntrada, headers: headers, body: body);

  print('Resposta da API: ${response.body}');

  if (response.statusCode == 200) {
    ElegantNotification.success(
      width: 360,
      notificationPosition: NotificationPosition.topLeft,
      animation: AnimationType.fromTop,
      title: const Text('Sucesso'),
      description: const Text('Viagem cadastrada com sucesso!'),
      onDismiss: () {},
    ).show;
  } else {
    // Houve um erro ao enviar os dados
    print('Erro ao enviar os dados: ${response.statusCode}');
  }
}
