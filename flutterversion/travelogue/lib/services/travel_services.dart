import 'dart:convert';
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
    // Dados enviados com sucesso
    print('Dados enviados com sucesso');
  } else {
    // Houve um erro ao enviar os dados
    print('Erro ao enviar os dados: ${response.statusCode}');
  }
}