import 'dart:convert';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var urlViagem = Uri.parse('https://10.0.2.2:7298/api/Viagem');
final client = http.Client();


Future<List> getTravel() async {
  var response = await http.get(urlViagem);

  if(response.statusCode == 200){
    return jsonDecode(utf8.decode(response.bodyBytes));
  }else{
    throw Exception('Erro ao carregar');
  }

}

Future<Map<String, dynamic>> getOneTravel(String id) async {
  final url = '$urlViagem/$id';
  var response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    return jsonDecode(utf8.decode(response.bodyBytes));
  }else{
    throw Exception('Erro ao carregar');
  }

}

Future<void> postTravel(Map<String, dynamic> formData) async {
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode(formData, toEncodable: (value) {
    if (value is DateTime) {
      return value.toIso8601String().substring(0,10);
    }
    return value;
  });

  final response = await client.post(urlViagem, headers: headers, body: body);

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

Future<void> deleteTravel(String id) async {
  final url = '$urlViagem/$id';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    
  } else {
    print('Erro ao deletar os dados: ${response.statusCode}');
  }
}

Future<void> putTravel(String id, Map<String, dynamic> formData) async {
  final url = '$urlViagem/$id';
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode(formData, toEncodable: (value) {
    if (value is DateTime) {
      return value.toIso8601String().substring(0,10);
    }
    return value;
  });

  final response = await http.put(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    // Item atualizado com sucesso
  } else {
    // Houve um erro ao atualizar o item
  }
}