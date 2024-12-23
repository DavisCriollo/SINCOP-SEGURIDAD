import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nseguridad/src/api/api_provider.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/models/foto_url.dart';

final _api = ApiProvider();
Future<String?> upLoadImagens(File? newPictureFile) async {
  final dataUser = await Auth.instance.getSession();

  //for multipartrequest
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://backsigeop.neitor.com/api/multimedias'));

  //for token
  request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

  request.files
      .add(await http.MultipartFile.fromPath('foto', newPictureFile!.path));

  //for completing the request
  var response = await request.send();

  //for getting and decoding the response into json format
  var responsed = await http.Response.fromStream(response);

  if (responsed.statusCode == 200) {
    final responseFoto = FotoUrl.fromJson(responsed.body);
    final url = responseFoto.urls[0].url;

    print('url de la imagen;*******************> $url ');
    return url;
  } else {
    return null;
  }
}

Future<bool> eliminaUrlServer(String url) async {
  final urlImageDelete = [
    {
      "nombre": "foto",
      "url": url,
    }
  ];

  final dataUser = await Auth.instance.getSession();

  final response = await _api.deleteUrlDelServidor(
    datos: urlImageDelete,
    token: '${dataUser!.token}',
  );

  if (response != null) {
    print('DELETE URL  imagen;*******************> $response ');
    return true;
  } else {
    return false;
  }
}

Future<bool> eliminaAllUrlServer(List<String> urls) async {
  List<Map<String, String>> urlImageDelete = urls.map((url) {
    return {
      "nombre": "foto",
      "url": url,
    };
  }).toList();

  final dataUser = await Auth.instance.getSession();

  final response = await _api.deleteUrlDelServidor(
    datos: urlImageDelete,
    token: '${dataUser!.token}',
  );

  if (response != null) {
    print('DELETE URL imagen;*******************> $response');
    return true;
  } else {
    return false;
  }
}
