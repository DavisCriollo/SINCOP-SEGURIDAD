import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nseguridad/src/api/api_provider.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/utils/crea_uuid.dart';

class GestionDocumentalController extends ChangeNotifier {
  GlobalKey<FormState> gestionDocFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> contenidoDocFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  void resetValuesGestionDocumental() {
    _inputAsunto = '';
    _inputLugar = '';
    _labelPerfil = '';
    _labelTipo = '';
    _listaDePersonal = [];
    _listaDeContenidos = [];
    _inputTitulo = '';
    _inputContenido = '';
  }

  bool validateForm() {
    if (gestionDocFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormAddContenido() {
    if (contenidoDocFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //================================== FECHA Y HORA DEL COMUNICADO  ==============================//
  String? _inputFecha =
      '${DateTime.now().year}-${(DateTime.now().month) < 10 ? '0${DateTime.now().month}' : '${DateTime.now().month}'}-${(DateTime.now().day) < 10 ? '0${DateTime.now().day}' : '${DateTime.now().day}'}';
  get getInputfecha => _inputFecha;
  void onInputFechaChange(String? date) {
    _inputFecha = date;

    notifyListeners();
  }

  String? _inputAsunto = '';
  get getInputAsunto => _inputAsunto;
  void onInputAsuntoChange(String? date) {
    _inputAsunto = date;

    notifyListeners();
  }

  String? _inputLugar = '';
  String? get getInputLugar => _inputLugar;
  void onLugarChange(String? text) {
    _inputLugar = text;
    notifyListeners();
  }

  String? _labelTipo = '';

  String? get getLabelTipo => _labelTipo;

  void setLabelTipo(String value) {
    _labelTipo = value;
    notifyListeners();
  }

//========================== MODAL CREAR CONTENIDO  =======================//
  String? _inputTitulo = '';
  String? get getInputTitulo => _inputTitulo;
  void onTituloChange(String? text) {
    _inputTitulo = '';
    _inputTitulo = text;
    print('EL TITULO MODAL: $_inputTitulo');
    notifyListeners();
  }

  String? _inputCabecera = '';
  String? get getInputCabecera => _inputCabecera;
  void onCabeceraChange(String? text) {
    _inputCabecera = '';
    _inputCabecera = text;
    print('EL Cabecera MODAL: $_inputCabecera');
    notifyListeners();
  }

  String? _inputContenido = '';
  String? get getInputContenido => _inputContenido;
  void onContenidoChange(String? text) {
    _inputContenido = '';
    _inputContenido = text;
    print('EL TITULO MODAL: $_inputContenido');
    notifyListeners();
  }

  String? _fotoContenido = '';
  String? get getFotoContenido => _fotoContenido;
  void onFotoContenido(String? url) {
    _fotoContenido = '';
    _fotoContenido = url;
    print('_fotoContenido MODAL: $_fotoContenido');
    notifyListeners();
  }

  String? _idContenido = '';
  String? get getIdContenido => _idContenido;
  void onIdContenido(String? url) {
    _idContenido = '';
    _idContenido = url;
    print('_idContenido MODAL: $_idContenido');
    notifyListeners();
  }

//========================== SELECT  =======================//
  String? _labelPerfil = '';

  String? get getLabelPerfil => _labelPerfil;

  void setLabelPerfil(String value) {
    _labelPerfil = value;
    notifyListeners();
  }

//============== OBTENEMOS LA INFORMACION DEL PERSONAL ELEGIDO ===============/

  List<Map<String, dynamic>> _listaDePersonal = [];
  List get getListaDePersonal => _listaDePersonal;
  void setListaDePersonal(dynamic inf) {
    _listaDePersonal.removeWhere((e) => (e['perId'] == inf['perId']));

    _listaDePersonal.add({
      "perId": inf['perId'],
      "perDocNumero": inf['perDocNumero'],
      "perApellidos": inf['perApellidos'],
      "perNombres": inf['perNombres'],
      "perFoto": inf['perFoto'],
    });
    print('el data del guardia: $_listaDePersonal');
    notifyListeners();
  }

  // ================== ELIMINA GUARDIA AGREGADO =====================//
  void eliminarItemListaDePersonal(int id) {
    _listaDePersonal.removeWhere((e) => (e['perId'] == id));

    _listaDePersonal.forEach(((element) {}));

    notifyListeners();
  }
//============== OBTENEMOS LA INFORMACION DEL CONTENIDO ===============/

  List<Map<String, dynamic>> _listaDeContenidos = [];
  List get getListaDeContenidos => _listaDeContenidos;
  void setListaDeContenidos(Map<String, dynamic> data) {
    _listaDeContenidos.add(data);

    _listaDeContenidos = _listaDeContenidos.reversed.toList();
    // print('Lista de Contenidos: $_listaDeContenidos');
    notifyListeners();
  }

  // ================== ELIMINA GUARDIA AGREGADO =====================//
  void eliminarItemListaDeContenidos(String id) {
    _listaDeContenidos.removeWhere((e) => (e['id'] == id));

    _listaDeContenidos.forEach(((element) {}));

    notifyListeners();
  }

  ///AGREGAMOS LA IMAGEN EN PANTALLA ////
  String _url = '';
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setImage(File image) {
    _selectedImage = image;
    _url = _selectedImage!.path;
    print('LA FOTO ESTA EN : $image');
    notifyListeners();
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void deleteImage() {
    if (_selectedImage != null) {
      _selectedImage!.delete();
      clearImage();
    }
  }

  void agregarContenido() {
    String uuidV4 = '';
    uuidV4 = generateUniqueId();

    final dataItem = {
      "cabecera": "CONTENIDO${_listaDeContenidos.length + 1}", // input
      "titulo": _inputTitulo, // input
      "contenido": _inputContenido, // textarea
      "foto": _urlImage, // input foto
      "id": uuidV4, // generar un codigo uuid
    };
    setListaDeContenidos(dataItem);
    clearImage();

    //  print('Lista Contenidos: $dataItem');
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  String _urlImage = "";
  String get getUrlImage => _urlImage;

  void setUrlImge(String data) {
    _urlImage = "";
    _urlImage = data;
    print('IMAGEN URL: $_urlImage');

    agregarContenido();

    notifyListeners();
  }

  bool _errorUrl = true;
  bool get getErrorUrl => _errorUrl;
  void setErrorUrl(bool data) {
    _errorUrl = data;
    notifyListeners();
  }

  Future getUrlsServer() async {
// print('ES LOS URLSTEMP: ${_urlsTemp.runtimeType}');

    final dataUser = await Auth.instance.getSession();

    final response = await _api.saveUrlAlServidor(
      urlFile: _selectedImage,
      token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorUrl = true;
      // setListaUrlse(response['data']);
      // print('ES LOS URLS: ${response['urls'][0]}');
      setUrlImge(response.toString());
      notifyListeners();
      // return response;
    }
    if (response == null) {
      _errorUrl = false;
      notifyListeners();
    }
    return response;
  }

  Future eliminaUrlServer(String url) async {
    final urlImageDelete = [
      {
        "nombre": "foto",
        "url": url,
      }
    ];
// print('ES LOS URLSTEMP: ${_urlImageDelete}');

    final dataUser = await Auth.instance.getSession();

    final response = await _api.deleteUrlDelServidor(
      datos: urlImageDelete,
      token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorUrl = true;
      // setListaUrlse(response['data']);
      // print('ES LOS URLS: ${response['urls'][0]}');
      // setUrlImge(response.toString());
      notifyListeners();
      return 'true';
      // return response;
    }
    if (response == null) {
      _errorUrl = false;
      notifyListeners();
      return 'false';
    }
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future crearActaDegestion(
    BuildContext context,
  ) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();

    final Map<String, dynamic> actaContenidos = {};
    for (var item in _listaDeContenidos) {
      actaContenidos.addAll({
        "${item['cabecera']}": {
          "titulo": item['cabecera'], // input
          "contenido": item['contenido'], // textarea
          "foto": item['foto'], // input foto
          "id": item['id'], // generar un codigo uuid
        },
      });
    }

    final pyloadNuevaActa = {
      "tabla": "acta_entrega_recepcion", //DEFECTO
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, //LOGIN

      "actaTipo": _labelTipo, //DEfaul
      "actaSecuencia": 0, // defaul
      "actaEstado": "ACTIVA", //defaul
      "actaAsunto": _inputAsunto, //input
      "actaLugar": _inputLugar, //input
      "actaFecha": _inputFecha, //input
      "actaPerId": infoUser.id, // id login
      "actaPerNombre": infoUser.nombre, // nombre login
      "actaPerDocNumero": infoUser.usuario, // usuario login
      "actaPerfilPara":
          _labelPerfil, // ["GUARDIAS","SUPERVISORES","ADMINISTRACION"]
      "actaGuardias": _listaDePersonal,
      "actaContenido": actaContenidos,
      //  {
      //   "contenido1": {
      //     "titulo": "ANTECEDENTE", // input
      //     "contenido": "", // textarea
      //     "foto": "", // input foto
      //     "id": "9fa11e38-b12c-4f34-8061-2f1378fbcd79", // generar un codigo uuid
      //   },
      // },
      "actaUser": infoUser.usuario, // login
      "actaEmpresa": infoUser.rucempresa, // login
    };
    serviceSocket.socket!.emit('client:guardarData', pyloadNuevaActa);

//=======================================================================//
  }

  dynamic _infoActaGestion;
  dynamic get getInfoActaGestion => _infoActaGestion;

  void setInfoActaGestion(dynamic info) {
    _infoActaGestion = info;
// print('=========> $_info');
    _labelTipo = info['actaTipo'];
    _inputAsunto = info['actaAsunto'];
    _inputLugar = info['actaLugar'];
    _inputFecha = info['actaFecha'];
    setLabelPerfil(info['actaPerfilPara']);

    for (var item in info['actaGuardias']) {
      _listaDePersonal.addAll([item]);
    }

    // Transformar el mapa a la estructura deseada
    for (var clave in info['actaContenido'].keys) {
      var item = info['actaContenido'][clave];
      final dataItem = {
        "cabecera": clave, // input
        "titulo": item['titulo'], // input
        "contenido": item['contenido'], // textarea
        "foto": item['foto'],
        "id": item['id'], // generar un codigo uuid
      };

      setListaDeContenidos(dataItem);
    }

    notifyListeners();
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  String _estadoActa = "";
  String get getEstadoActa => _estadoActa;

  void setEstadoActa(String data) {
    _estadoActa = "";
    _estadoActa = data;
    // print('ESTADO: $_estadoActa');
    notifyListeners();
  }

  Future editaActaDegestion(
    BuildContext context,
  ) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();

    final Map<String, dynamic> actaContenidos = {};
    for (var item in _listaDeContenidos) {
      actaContenidos.addAll({
        "${item['cabecera']}": {
          "titulo": item['cabecera'], // input
          "contenido": item['contenido'], // textarea
          "foto": item['foto'], // input foto
          "id": item['id'], // generar un codigo uuid
        },
      });
    }

    _labelTipo = getInfoActaGestion['actaTipo'];
    _inputAsunto = getInfoActaGestion['actaAsunto'];
    _inputLugar = getInfoActaGestion['actaLugar'];
    _inputFecha = getInfoActaGestion['actaFecha'];

    final pyloadEditaActa = {
      "tabla": "acta_entrega_recepcion", //DEFECTO
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, //LOGIN

      "actaId": getInfoActaGestion['actaId'],
      "actaTipo": getInfoActaGestion['actaTipo'], //DEfaul
      "actaSecuencia": getInfoActaGestion['actaSecuencia'], // defaul
      "actaEstado": getEstadoActa, //defaul
      "actaAsunto": getInfoActaGestion['actaAsunto'], //input
      "actaLugar": getInfoActaGestion['actaLugar'], //input
      "actaFecha": getInfoActaGestion['actaFecha'], //input
      "actaPerId": infoUser.id, // id login
      "actaPerNombre": infoUser.nombre, // nombre login
      "actaPerDocNumero": infoUser.usuario, // usuario login
      "actaPerfilPara": getInfoActaGestion[
          'actaPerfilPara'], // ["GUARDIAS","SUPERVISORES","ADMINISTRACION"]
      "actaGuardias": _listaDePersonal,
      "actaContenido": actaContenidos,
      //  {
      //   "contenido1": {
      //     "titulo": "ANTECEDENTE", // input
      //     "contenido": "", // textarea
      //     "foto": "", // input foto
      //     "id": "9fa11e38-b12c-4f34-8061-2f1378fbcd79", // generar un codigo uuid
      //   },
      // },
      "actaUser": infoUser.usuario, // login
      "actaEmpresa": infoUser.rucempresa, // login
    };
    serviceSocket.socket!.emit('client:actualizarData', pyloadEditaActa);

//=======================================================================//
// print('=====LA EDICION DE LA DATA====> $_pyloadEditaActa');
//=======================================================================//
  }
//=================== BUSCA PERSONA=====================//

  //===================BOTON SEARCH CLIENTE==========================//
//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaPersona;

  String? _inputBuscaPersona;
  get getInputBuscaClienteMulta => _inputBuscaPersona;
  void onInputBuscaPersonaChange(String? text) {
    _inputBuscaPersona = text;
    // print(' GUARDIA MULTA :$_inputBuscaPersona');

//================================================================================//
    if (_inputBuscaPersona!.length >= 3) {
      _deboucerSearchBuscaPersona?.cancel();
      _deboucerSearchBuscaPersona =
          Timer(const Duration(milliseconds: 500), () {
        // setPersona('Guardias');
        buscaPersonaGestion(_inputBuscaPersona);
      });
    } else if (_inputBuscaPersona!.isEmpty) {
      buscaPersonaGestion('');
    } else {
      buscaPersonaGestion('');
    }
//================================================================================//

    notifyListeners();
  }

  //===================BUSCAR PERSONA GESTION =====================//
  List _listaPersonalGestion = [];
  List get getListaPersonalGestion => _listaPersonalGestion;

  void setInfoBusquedaPersonalGestion(List data) {
    _listaPersonalGestion = data;
    notifyListeners();
  }

  bool? _errorPersonalGestion; // sera nulo la primera vez
  bool? get getErrorPersonalGestion => _errorPersonalGestion;
  set setErrorPersonalGestion(bool? value) {
    _errorPersonalGestion = value;
    notifyListeners();
  }

  Future buscaPersonaGestion(String? search) async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getAllPersonasDirigidoA(
      search: search,
      estado: _labelPerfil,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorPersonalGestion = true;
      setInfoBusquedaPersonalGestion(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorPersonalGestion = false;
      notifyListeners();
      return null;
    }
  }
}
