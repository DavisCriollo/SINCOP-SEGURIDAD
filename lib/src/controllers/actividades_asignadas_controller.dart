import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:sincop_app/src/api/api_provider.dart';
// import 'package:sincop_app/src/api/authentication_client.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nseguridad/src/api/api_provider.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/models/crea_fotos.dart';

// import 'package:sincop_app/src/models/crea_fotos.dart';

import '../models/foto_url.dart';

class ActividadesAsignadasController extends ChangeNotifier {
  GlobalKey<FormState> actividadesAsignadasFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> actividadesRondaFormKey = GlobalKey<FormState>();

  final _api = ApiProvider();

  bool validateForm() {
    if (actividadesAsignadasFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormRonda() {
    if (actividadesRondaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void resetValuesActividades() {
    _listaActividadesAsignadas = [];
    _infoActividad;
    _inputTitulo = '';
  }

  void resetValuesRonda() {
    _nombreEvento = "";
    _inputTituloRonda = '';

    _coordenadas = "";
    geolocator.Position? position;

    _infoDataQR = '';
    _dataQR = '';
    _listaFotosUrl = [];
    _listaVideosUrl = [];
  }

//================================= OBTENEMOS TODOS LOS CLIENTES ==============================//

  List _listaActividadesAsignadas = [];
  List get getListaActividadesAsignadas => _listaActividadesAsignadas;

  void setListaActividadesAsignadas(List data) {
    _listaActividadesAsignadas = data;
    // print('las actividades:$_listaActividadesAsignadas');
    //  setCardChildren(_listaActividadesAsignadas);

    notifyListeners();
  }

  bool? _errorActividadesAsignadas; // sera nulo la primera vez
  bool? get getErrorActividadesAsignadas => _errorActividadesAsignadas;

  Future getActividadesAsignadas(String? search, String notificacion) async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getAllActividadesAsignadas(
        search: search,
        notificacion: notificacion,
        token: '${dataUser!.token}',
        opcion: labelActividad);
    if (response != null) {
      _errorActividadesAsignadas = true;
      setListaActividadesAsignadas(response['data']);
      // setCardChildren(response['data']);

      products.addAll(response['data']);

      agruparProductos();

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorActividadesAsignadas = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//================================ OBTENEMOS LA INFO DE LA ACTIVIDAD ==============================//
  dynamic _infoActividad;
  dynamic get getInfoActividad => _infoActividad;
  void setInfoActividad(dynamic info) {
    _infoActividad = info;
// print('DATA DETALLLE   |||||||    $_infoActividad');
    notifyListeners();
  }

//========================== DROPDOWN ACTIVIDADES POR TIPO =======================//
  String? _labelActividad = 'Diurno';

  String? get labelActividad => _labelActividad;

  void setLabelActividad(String value) {
    _labelActividad = value;
    // print('setLabelActividad : $setLabelActividad');
    notifyListeners();
  }

  void resetDropDown() {
    _labelActividad = null;
  }

//=============================== INPUTS =============================//
  String? _inputTitulo = '';
  String? get getInputTitulo => _inputTitulo;
  void setInputTitulo(String? text) {
    _inputTitulo = text;
    // print('_inputTitulo   ${_inputTitulo}');
    notifyListeners();
  }

  //============================================= LISTA DE ITEMS IMVENTARIO====================//
  final List<Map<String, dynamic>> _listItemsInventario = [];
  List<Map<String, dynamic>> get getListItemsInventario => _listItemsInventario;

  void setListItemsInventario(Map<String, dynamic> data) {
    _listItemsInventario.removeWhere((e) => e['id'] == data['id']);
    _listItemsInventario.addAll([data]);
    print('_listItemsInventario   $_listItemsInventario');
    notifyListeners();
  }
  //============================================= SELECT====================//

///////////================= DATA TABLET VESTIMENTA===================/////////////////

  final int _sortColumnIndex = 0;
  final bool _sortAscending = true;

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<dynamic> _dataRows = [];
  List<dynamic> get getDataRows => _dataRows;
  void geLisItems(List<dynamic> items) {
    _dataRows = List<dynamic>.generate(
      items.length,
      (index) => {
        // 'isChecked': false,
        // 'item': 'Item ${index + 1}',
        // 'description': 'Description ${index + 1}',
        "tipo": items[index]['tipo'],
        "bodega": items[index]['bodega'],
        "idBodega": items[index]['idBodega'],
        "fotos": items[index]['fotos'],
        "id": items[index]['id'],
        "nombre": items[index]['nombre'],
        "serie": items[index]['serie'],
        "cantidad": items[index]['cantidad'],
        "valor": items[index]['valor'],
        "estadoEquipo": items[index]['estadoEquipo'],
        "marca": items[index]['marca'],
        "modelo": items[index]['modelo'],
        "talla": items[index]['talla'],
        "color": items[index]['color'],
        "stock": items[index]['stock'],
        "isChecked": false
      },
    );

// notifyListeners();
  }

  int get rowsPerPage => _rowsPerPage;
  int get sortColumnIndex => _sortColumnIndex;
  bool get sortAscending => _sortAscending;
  List<dynamic> get dataRows => _dataRows;

  void updateRowsPerPage(int value) {
    _rowsPerPage = value;
    notifyListeners();
  }

  void updateCheckedStatus(int index, bool value) {
    _dataRows[index]['isChecked'] = value;
    notifyListeners();
  }

//==================GUARDA ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//
  List<dynamic> getSelectedItems() {
    return _dataRows.where((row) => row['isChecked']).toList();
  }

  List<dynamic> getUnselectedItems() {
    return _dataRows.where((row) => !row['isChecked']).toList();
  }
//==================ALMACENA EN UNA LISTA  ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//

  List<dynamic> combinedList = [];
  List<Map<String, dynamic>> _listaVestimentas = [];

  void setUnificaListas(List<dynamic> listas) {
    combinedList = [];
    _listaVestimentas = [];

    combinedList = listas;

    for (var item in combinedList) {
      _listaVestimentas.addAll([
        {
          "tipo": item["tipo"],
          "id": item["id"],
          "nombre": item["nombre"],
          "serie": item["serie"],
          "existe": item["isChecked"],
          "cantidad": item["cantidad"]
        }
      ]);
    }

// print('LISTAS _listaVestimentas $_listaVestimentas');
  }

///////////================= DATA TABLET ARMAS===================/////////////////

  final int _sortColumnArmasIndex = 0;
  final bool _sortAscendingArmas = true;

  int _rowsPerPageArmas = PaginatedDataTable.defaultRowsPerPage;

  List<dynamic> _dataRowsArmas = [];
  List<dynamic> get getDataRowsArmas => _dataRowsArmas;
  void geLisItemsArmas(List<dynamic> items) {
    _dataRowsArmas = List<dynamic>.generate(
      items.length,
      (index) => {
        "tipo": items[index]['tipo'],
        "fotos": items[index]['fotos'],
        "id": items[index]['id'],
        "nombre": items[index]['nombre'],
        "serie": items[index]['serie'],
        "cantidad": items[index]['cantidad'],
        "valor": items[index]['valor'],
        "estadoEquipo": items[index]['estadoEquipo'],
        "marca": items[index]['marca'],
        "modelo": items[index]['modelo'],
        "tipoArma": items[index]['tipoArma'],
        "calibre": items[index]['calibre'],
        "color": items[index]['color'],
        "stock": items[index]['stock'],
        "isChecked": false
      },
    );

// notifyListeners();
  }

  int get rowsPerPageArmas => _rowsPerPageArmas;
  int get sortColumnIndexArmas => _sortColumnArmasIndex;
  bool get sortAscendingArmas => _sortAscendingArmas;
  List<dynamic> get dataRowsArmas => _dataRowsArmas;

  void updateRowsPerPageArmas(int value) {
    _rowsPerPageArmas = value;
    notifyListeners();
  }

  void updateCheckedStatusArmas(int index, bool value) {
    _dataRowsArmas[index]['isChecked'] = value;
    notifyListeners();
  }

//==================GUARDA ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//
  List<dynamic> getSelectedItemsArmas() {
    return _dataRowsArmas.where((row) => row['isChecked']).toList();
  }

  List<dynamic> getUnselectedItemsArmas() {
    return _dataRowsArmas.where((row) => !row['isChecked']).toList();
  }
//==================ALMACENA EN UNA LISTA  ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//

  List<dynamic> combinedListArmas = [];
  List<Map<String, dynamic>> _listaVestimentasArmas = [];

  void setUnificaListasArmas(List<dynamic> listas) {
    combinedListArmas = [];
    _listaVestimentasArmas = [];

    combinedListArmas = listas;

    for (var item in combinedListArmas) {
      _listaVestimentasArmas.addAll([
        {
          "tipo": item["tipo"],
          "id": item["id"],
          "nombre": item["nombre"],
          "serie": item["serie"],
          "existe": item["isChecked"],
          "cantidad": item["cantidad"]
        }
      ]);
    }

// print('LISTAS _listaVestimentas $_listaVestimentasArmas');
  }
///////////================= DATA TABLET MUNICIONES===================/////////////////

  final int _sortColumnMunicionesIndex = 0;
  final bool _sortAscendingMuniciones = true;

  int _rowsPerPageMuniciones = PaginatedDataTable.defaultRowsPerPage;

  List<dynamic> _dataRowsMuniciones = [];
  List<dynamic> get getDataRowsMuniciones => _dataRowsMuniciones;
  void geLisItemsMuniciones(List<dynamic> items) {
    _dataRowsMuniciones = List<dynamic>.generate(
      items.length,
      (index) => {
        "tipo": items[index]['tipo'],
        "fotos": items[index]['fotos'],
        "id": items[index]['id'],
        "nombre": items[index]['nombre'],
        "serie": items[index]['serie'],
        "cantidad": items[index]['cantidad'],
        "valor": items[index]['valor'],
        "estadoEquipo": items[index]['estadoEquipo'],
        "marca": items[index]['marca'],
        "modelo": items[index]['modelo'],
        "tipoArma": items[index]['tipoArma'],
        "calibre": items[index]['calibre'],
        "color": items[index]['color'],
        "stock": items[index]['stock'],
        "isChecked": false
      },
    );

// notifyListeners();
  }

  int get rowsPerPageMuniciones => _rowsPerPageMuniciones;
  int get sortColumnIndexMuniciones => _sortColumnMunicionesIndex;
  bool get sortAscendingMuniciones => _sortAscendingMuniciones;
  List<dynamic> get dataRowsMuniciones => _dataRowsMuniciones;

  void updateRowsPerPageMuniciones(int value) {
    _rowsPerPageMuniciones = value;
    notifyListeners();
  }

  void updateCheckedStatusMuniciones(int index, bool value) {
    _dataRowsMuniciones[index]['isChecked'] = value;
    notifyListeners();
  }

//==================GUARDA ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//
  List<dynamic> getSelectedItemsMuniciones() {
    return _dataRowsMuniciones.where((row) => row['isChecked']).toList();
  }

  List<dynamic> getUnselectedItemsMuniciones() {
    return _dataRowsMuniciones.where((row) => !row['isChecked']).toList();
  }
//==================ALMACENA EN UNA LISTA  ELEMENTOS  SELECCIONADOS Y NO SELECCIONADOS==================//

  List<dynamic> combinedListMuniciones = [];
  List<Map<String, dynamic>> _listaVestimentasMuniciones = [];

  void setUnificaListasMuniciones(List<dynamic> listas) {
    combinedListMuniciones = [];
    _listaVestimentasMuniciones = [];

    combinedListMuniciones = listas;

    for (var item in combinedListMuniciones) {
      _listaVestimentasMuniciones.addAll([
        {
          "tipo": item["tipo"],
          "id": item["id"],
          "nombre": item["nombre"],
          "serie": item["serie"],
          "existe": item["isChecked"],
          "cantidad": item["cantidad"]
        }
      ]);
    }

// print('LISTAS _listaVestimentas $_listaVestimentasMuniciones');
  }

//====================== CREA IINVENTARIO INTERNO==========================//

  //  Future creaInventarioInterno(
  //   BuildContext context,
  // ) async {
  //     final serviceSocket = SocketService();

  //   final infoUser = await Auth.instance.getSession();
  //   final _pyloadNuevoInventario = {
  //     "tabla": "consigna", // defecto
  //     "rucempresa": infoUser!.rucempresa, //login
  //     "rol": infoUser.rol, //login

  //     "act_asigId": 8, //id registro
  // "titulo": "MI REVISION INVENTARIO",
  // "qr": "", // vacio
  // "fotos": [], //no obligatorio (3max)
  // "videos": [], // no obligatorio (1max)
  // "vestimentas": _listaVestimentas,
  // "armas": _listaVestimentasArmas, //formar de acuerdo al listado del endpoint (si existe true caso contrario false)
  // "municiones": _listaVestimentasMuniciones, //formar de acuerdo al listado del endpoint (si existe true caso contrario false)

  //     "conUser": infoUser.usuario, //login
  //     "conEmpresa": infoUser.rucempresa, //login
  //   };

  //   serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoInventario);
  // }

  //========================== GUARDA ACTIVIDAD =======================//
  Future guardaInventarioInterno(BuildContext context) async {
    final infoUser = await Auth.instance.getSession();
    final response = await _api.guardaInventarioInterno(
      infoInventarioInterno: {
        "act_asigId": _infoActividad['act_asigId'], //id registro
        "titulo": _inputTitulo,
        "qr": "", // vacio
        "fotos": [], //no obligatorio (3max)
        "videos": [], // no obligatorio (1max)
        "vestimentas": _listaVestimentas,
        "armas":
            _listaVestimentasArmas, //formar de acuerdo al listado del endpoint (si existe true caso contrario false)
        "municiones":
            _listaVestimentasMuniciones, //formar de acuerdo al listado del endpoint (si existe true caso contrario false)
      },
      token: infoUser!.token,
    );

    if (response != null) {
      return response;
    }
    if (response == null) {
      return null;
    }
  }

  //========================== OBTENEMOS LA INFO DEL QR =======================//

  //=============================== INPUTS =============================//
  String? _inputTituloRonda = '';
  String? get getInputTituloRonda => _inputTituloRonda;
  void setInputTituloRonda(String? text) {
    _inputTituloRonda = text;
    // print('_inputTituloRonda   ${_inputTituloRonda}');
    notifyListeners();
  }

  String? _infoDataQR;
  String? get getInfoDataQR => _infoDataQR;
  void setInfoDataQR(String? info) {
    _infoDataQR = '';
    _infoDataQR = info;

    // print('======================>_infoDataQR   ${_infoDataQR}');

    notifyListeners();
  }

  String? _dataQR = "";
  String? get getDataQR => _dataQR;
  void setDataQR(String? info) {
    _dataQR = '';
    _dataQR = info;

    // print('=========>_dataQR   $_dataQR');

    notifyListeners();
  }

  //========================== GUARDA ACTIVIDAD RONDA=======================//
  Future guardaActividadRonda(BuildContext context, String lugar) async {
    final infoUser = await Auth.instance.getSession();

//  Map<String, dynamic>  _info ={};
// if( _lugar=='RONDAS'){
//  _info={
//   "lugar":_lugar,

//  "act_asigId": _infoActividad['act_asigId'], //id registro
//   "titulo": _inputTituloRonda,
//   "qr": _infoDataQR, // vacio
//   "fotos": _listaFotosUrl, //no obligatorio (3max)
//   "videos":  _listaVideosUrl,
//   "coordenasGps": {
//         "latitud": position!.latitude,
//         "longitud": position!.longitude,
//       },
//     };

// } else if( _lugar=="INVENTARIO EXTERNO") {
//  _info={
//   "lugar":_lugar,

//  "act_asigId": _infoActividad['act_asigId'], //id registro
//   "titulo": _inputTituloRonda,
//   "qr": _infoDataQR, // vacio
//   "fotos": _listaFotosUrl, //no obligatorio (3max)
//   "videos":  _listaVideosUrl,

//     };

// }

    final response = await _api.guardaActividadDeRonda(
      context: context,
      infoInventarioInterno: {
        "act_asigId": _infoActividad['act_asigId'], //id registro
        "titulo": _inputTituloRonda,
        "qr": _infoDataQR, // vacio
        "fotos": _listaFotosUrl, //no obligatorio (3max)
        "videos": _listaVideosUrl,
        "coordenasGps": {
          "latitud": position!.latitude,
          "longitud": position!.longitude,
          // "latitud": '37.4219983',
          // "longitud": '-122.084',
        },
        "id": getIdActividadPorRealizar
      },
      token: infoUser!.token,
    );

    if (response != null) {
      return response;
    }
    if (response == null) {
      return null;
    }

// print('LA DATA $infoInventarioInterno');
  }

  //========================== GUARDA ACTIVIDAD RONDA=======================//
  Future guardaActividadInventarioExterno(
      BuildContext context, String lugar) async {
    final infoUser = await Auth.instance.getSession();

//  Map<String, dynamic>  _info ={};
// if( _lugar=='RONDAS'){
//  _info={
//   "lugar":_lugar,

//  "act_asigId": _infoActividad['act_asigId'], //id registro
//   "titulo": _inputTituloRonda,
//   "qr": _infoDataQR, // vacio
//   "fotos": _listaFotosUrl, //no obligatorio (3max)
//   "videos":  _listaVideosUrl,
//   "coordenasGps": {
//         "latitud": position!.latitude,
//         "longitud": position!.longitude,
//       },
//     };

// } else if( _lugar=="INVENTARIO EXTERNO") {
//  _info={
//   "lugar":_lugar,

//  "act_asigId": _infoActividad['act_asigId'], //id registro
//   "titulo": _inputTituloRonda,
//   "qr": _infoDataQR, // vacio
//   "fotos": _listaFotosUrl, //no obligatorio (3max)
//   "videos":  _listaVideosUrl,

//     };

// }

    final response = await _api.guardaActividadDeInventario(
      context: context,
      infoInventarioInterno:
// _info,
          {
        "act_asigId": _infoActividad['act_asigId'], //id registro
        "titulo": _inputTituloRonda,
        "qr": _infoDataQR, // vacio
        "fotos": _listaFotosUrl, //no obligatorio (3max)
        "videos": _listaVideosUrl,
        "id": getIdActividadPorRealizar
      },
      token: infoUser!.token,
    );

    if (response != null) {
      return response;
    }
    if (response == null) {
      return null;
    }

// print('LA DATA $infoInventarioInterno');
  }

//======================== VAALIDA SCANQR =======================//

  //========================== GEOLOCATOR =======================//
  String? _coordenadas = "";
  geolocator.Position? _position;
  geolocator.Position? get position => _position;
  String? _selectCoords = "";
  String? get getCoords => _selectCoords;
  set setCoords(String? value) {
    _selectCoords = value;

    notifyListeners();
  }

  Future<bool?> checkGPSStatus() async {
    final isEnable = await geolocator.Geolocator.isLocationServiceEnabled();
    geolocator.Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
    });
    return isEnable;
  }

  Future<void> getCurrentPosition() async {
    late geolocator.LocationSettings locationSettings;

    locationSettings = const geolocator.LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 100,
    );
    _position =
        await geolocator.GeolocatorPlatform.instance.getCurrentPosition();
    _position = position;
    _selectCoords = ('${position!.latitude},${position!.longitude}');
    _coordenadas = _selectCoords;

    print('_position : ${position!.latitude},${position!.longitude}');

    notifyListeners();
  }

//==========================TRABAJAMOS CON VIDEO  ===============================//

  String? _pathVideo = '';
  String? get getPathVideo => _pathVideo;

  void setPathVideo(String? path) {
    _pathVideo = path;
    upLoadVideo(_pathVideo);
    notifyListeners();
  }

  String? _urlVideo = '';
  String? get getUrlVideo => _urlVideo;

  void setUrlVideo(String? url) {
    _urlVideo = url;
    notifyListeners();
  }
//============================LOAD VIDEO===========================================//

  List<dynamic> _listaVideosUrl = [];
  List<dynamic> get getVideoUrl => _listaVideosUrl;

  Future<String?> upLoadVideo(String? path) async {
    final dataUser = await Auth.instance.getSession();

    //for multipartrequest
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://jback.neitor.com/api/multimedias'));

    //for token
    request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

    request.files.add(await http.MultipartFile.fromPath('video', path!));

    //for completeing the request
    var response = await request.send();

    //for getting and decoding the response into json format
    var responsed = await http.Response.fromStream(response);
    // final responseData = json.decode(responsed.body);

    if (responsed.statusCode == 200) {
      final responseVideo = FotoUrl.fromJson(responsed.body);
      final urlVideo = responseVideo.urls[0];
      setUrlVideo(responseVideo.urls[0].url);
      _listaVideosUrl.addAll([
        {
          "nombre": responseVideo
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseVideo.urls[0].url
        }
      ]);
    }
    for (var item in _listaVideosUrl) {}
    return null;
  }

  void eliminaVideo() {
    _listaVideosUrl.clear();
    _urlVideo = '';
    _pathVideo = '';
    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  List? _listaFotosUrl = [];
  List? get getListaFotosUrl => _listaFotosUrl;

  final List<dynamic> _listaFotosCrearInforme = [];
  List<dynamic> get getListaFotosInforme => _listaFotosCrearInforme;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFile);
    _listaFotosCrearInforme
        .add(CreaNuevaFotoInformeGuardias(id, _newPictureFile!.path));
    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotosCrearInforme.add(CreaNuevaFotoInformeGuardias(id, path));

    notifyListeners();
  }

  void eliminaFoto(int id) {
    _listaFotosCrearInforme.removeWhere((element) => element!.id == id);

    notifyListeners();
  }

  void opcionesDecamara(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedFile == null) {
      return;
    }
  }

  void eliminaFotoUrl(String url) {
    _listaFotosUrl!.removeWhere((e) => e['url'] == url);
  }

  Future<String?> upLoadImagen(File? newPictureFile) async {
    final dataUser = await Auth.instance.getSession();

    //for multipartrequest
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://backsafe.neitor.com/api/multimedias'));

    //for token
    request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

    request.files
        .add(await http.MultipartFile.fromPath('foto', newPictureFile!.path));

    //for completeing the request
    var response = await request.send();

    //for getting and decoding the response into json format
    var responsed = await http.Response.fromStream(response);
    // final responseData = json.decode(responsed.body);

    if (responsed.statusCode == 200) {
      final responseFoto = FotoUrl.fromJson(responsed.body);
      final fotoUrl = responseFoto.urls[0];
      _listaFotosUrl!.addAll([
        {
          "nombre": responseFoto
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseFoto.urls[0].url
        }
      ]);
      notifyListeners();
    }
    for (var item in _listaFotosUrl!) {}
    return null;
  }
// //========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
// Future<Position?> getCurrentLocation() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Verificar si el servicio de ubicación está habilitado
//   serviceEnabled = await Geolocator.Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Servicio de ubicación desactivado, maneja el caso según tus necesidades
//     return null;
//   }

//   // Verificar el permiso de ubicación
//   permission = await Geolocator.Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     // Permiso de ubicación denegado, solicitar permiso al usuario
//     permission = await Geolocator.Geolocator.requestPermission();
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       // Permiso de ubicación denegado, maneja el caso según tus necesidades
//       return null;
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // Permiso de ubicación denegado permanentemente, maneja el caso según tus necesidades
//     return null;
//   }

//   // Obtener la ubicación actual
//   try {
//     Position position = await Geolocator.Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return position;
//   } catch (e) {
//     // Error al obtener la ubicación, maneja el caso según tus necesidades
//     return null;
//   }
// }

//==================OBTENFO EL NOMBRE DEL EVENTO===================//
  String? _nombreEvento = "";
  String? get getNombreEvento => _nombreEvento;
  void setNombreEvento(String? nombre) {
    _nombreEvento = nombre;
    // print('EL NOMBRE ES:$_nombreEvento');
    notifyListeners();
  }

//==================OBTENFO EL ID DE LA ACTIVIDAD A REALIZAR===================//
  String? _idActividadPorRealizar = "";
  String? get getIdActividadPorRealizar => _idActividadPorRealizar;
  void setIdActividadPorRealizar(String? ids) {
    _idActividadPorRealizar = '';
    _idActividadPorRealizar = ids;
    // print('idActividadPorRealizar: $_idActividadPorRealizar');
    notifyListeners();
  }

//==================OBTENFO EL NOMBRE DEL EVENTO===================//
  String? _timeWorld = "";
  String? get getTimeWolrd => _timeWorld;
  void setTimeWolrd(String? time) {
    _timeWorld = time;

// String inputDateString =_time!;
// DateTime inputDateTime = DateTime.parse(inputDateString);
// DateTime utcDateTime = inputDateTime.toUtc();

// String _fechaUTC = DateFormat('yyyy-MM-dd HH:mm:ss').format(utcDateTime);

//   print('EL _timeWorld ES :$_fechaUTC');
//   _timeWorld=_fechaUTC;
//   notifyListeners();
// }

// Future worldTime() async {

//     final response = await _api.obtenerHoraDesdeInternet(
//         );
//     if (response != null) {
//        setTimeWolrd(response);

//       notifyListeners();
//       return response;
//     }
//     if (response == null) {

//       setTimeWolrd("");
//             notifyListeners();
//       return null;
//     }
//     return null;
  }

//==================OBTENFO LA HORA DEL SISTEMA===================//
  bool _horaActual = false;

  bool get getHoraActual => _horaActual;

  void setHoraActual(bool hora) {
    _horaActual = hora;
    // print('EL NOMBRE ES:$_nombreEvento');
    notifyListeners();
  }

//==================OBTENFO LA HORA DEL SISTEMA===================/
  bool _isActividad = false;

  bool get getIsActividad => _isActividad;

  void setIsActividad(bool act) {
    _isActividad = act;
    print('EL _isActividad ES:$_isActividad');
    notifyListeners();
  }

  void setNotificacionActividad(dynamic actvidad) {
    print('EL _actvidad ES:$actvidad');
    notifyListeners();
  }

//==================PROCESO DE AGRUPAR ITEMS===================//

  Map<String, List<Map<String, dynamic>>> _wordMap = {};
  Map<String, List<Map<String, dynamic>>> get getWordMap => _wordMap;

  void setItemsLista(List<dynamic> listActiv) {
    for (Map<String, dynamic> word in listActiv) {
      String type = word['act_asigEveTipo'] as String;

      if (_wordMap.containsKey(type)) {
        _wordMap[type]!.add(word);
      } else {
        _wordMap[type] = [word];
      }
    }
    // notifyListeners();
  }

  void resetListItems() {
    _wordMap = {};
    notifyListeners();
  }

  //============================MUESTRA LOS ITEMS==============================/
  String _type = '';
  String get getType => _type;
  void setType(String tip) {
    _type = tip;
    // notifyListeners();
  }

  final List<Map<String, dynamic>> _wordList = [];

  List<Map<String, dynamic>> get getWordList => _wordList;

  void setWordList(List<Map<String, dynamic>> list) {
    _wordList.addAll(list);
    // notifyListeners();
  }

  final List<Widget> _cardChildren = [];
  List<Widget> get cardChildren => _cardChildren;

  // void setCardChildren(Map<String, dynamic> _list){
  //   _cardChildren.add(_list);
  // // }
  //============================MUESTRA LOS ITEMS==============================/
  List products = [];
  void setCardChildren(list) {
    products.addAll(list);
    // agruparProductos() ;
    notifyListeners();
  }

  Map<String, List<Map<String, dynamic>>> groupedProducts = {};

  void borrarDatos() {
    products.clear();
    groupedProducts.clear();
    notifyListeners();
  }

  void agruparProductos() {
    groupedProducts.clear();

    for (var product in products) {
      String tipo = product['act_asigEveTipo'];
      if (groupedProducts.containsKey(tipo)) {
        groupedProducts[tipo]!.add(product);
      } else {
        groupedProducts[tipo] = [product];
      }
    }
  }
}
