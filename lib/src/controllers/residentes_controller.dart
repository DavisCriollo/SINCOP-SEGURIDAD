import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nseguridad/src/api/api_provider.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:provider/provider.dart';

class ResidentesController extends ChangeNotifier {
  GlobalKey<FormState> residentesFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> correoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> telefonoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> personaFormKey = GlobalKey<FormState>();
    GlobalKey<FormState> propiedadFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();

  bool validateForm() {
    if (residentesFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormCorreo() {
    if (correoFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormTelefono() {
    if (telefonoFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormPersona() {
    if (personaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormPropiedad() {
    if (propiedadFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
  void resetValuesResidentes() {
    // _idGuardia;
    // _cedulaGuardia;
    // _nombreGuardia = '';
    // _inputDetalle;
    _idCliente = '';

    _cedulaCliente = '';

    _nombreCliente = '';

    _nombreUbicacion = '';
    _nombrePuesto = '';

    _datosOperativos.clear();

    _itemCedulaResidente = '';

    _itemNombresResidentes = '';

    _itemCasaDepartamentoResidente = '';

    _itemUbicacionResidente = '';

    _email = '';

    _listaCorreoResidente.clear();

    _telefono = '';

    _listaTelefonosResidente.clear();
    _persona = '';
    _listaPersonasAutorizadasResidente.clear();








_nombreNuevoCliente = '';
 _itemTipoPersona = '';
 _puesto = {};
 _dataPersona={}; 
 _dataPersonaPropietario={}; // tomar del endpoit consumido
   _selectedTypeArrendatario='CEDULA'; // radio button
     _selectedTypePropietario='CEDULA';
   _cedulaNPropietario=''; // input
   _nombreNPropietario=''; // input
   _apellidoNPropietario=''; // input
   _listaTelefonosPropietarios.clear(); // input
   _listaCorreosPropietarios.clear(); // input


    _cedulaNArrendatario=''; // input
   _nombreNArrendatario=''; // input
   _apellidoNArrendatario=''; // input
   _listaTelefonosArrendatarios.clear(); // input
   _listaCorreosArrendatarios.clear(); // input
   _listaPropiedad=[];

    notifyListeners();
  }

//==================================+++++++++++++++++++++++++++++++ OBTENEMOS TODOS LOS RESIDENTES  =====++++++++++++++++++++++++++++++++++++++++++++=========================//
  List<dynamic> _listaTodosLosResidentes = [];
  List<dynamic> get getListaTodosLosResidentes => _listaTodosLosResidentes;

  void setListaTodosLosResidentes(List<dynamic> data) {
    _listaTodosLosResidentes = [];
    _listaTodosLosResidentes = data;

    // print('TENEMOS DATA:${_listaTodosLosResidentes}');
    _listaTodosLosResidentes.sort((a, b) {
      if (a['resEstado'] == 'INACTIVA' && b['resEstado'] != 'INACTIVA') {
        return 1; // Mueve a 'a' al final
      } else if (a['resEstado'] != 'INACTIVA' && b['resEstado'] == 'INACTIVA') {
        return -1; // Mueve a 'a' al inicio
      } else {
        return 0; // Mantén el orden actual
      }
    });
    setListFilter(_listaTodosLosResidentes);

    notifyListeners();
  }

  bool? _errorTodosLosResidentes; // sera nulo la primera vez
  bool? get getErrorTodosLosResidentes => _errorTodosLosResidentes;

  Future<dynamic> getTodosLosResidentes(
      String? search, String? notificacion) async {
    final dataUser = await Auth.instance.getSession();

    final response = await _api.getAllResidentes(
      search: search,
      idCli: '${dataUser!.id}',
      notificacion: notificacion,
      token: '${dataUser.token}',
    );

    if (response != null) {
      _errorTodosLosResidentes = true;

      List<Map<String, dynamic>> dataSort = [];
      dataSort = response['data'];
      dataSort.sort((a, b) => b['resFecReg']!.compareTo(a['resFecReg']!));

      // setListaTodosLosResidentes(response['data']);
      setListaTodosLosResidentes(dataSort);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorTodosLosResidentes = false;
      notifyListeners();
      return null;
    }
    return null;
  }

  Future<dynamic> getTodosLosResidentesGuardia(
    String? search,
    String? notificacion,
  ) async {
    final dataUser = await Auth.instance.getSession();
    final idTurno = await Auth.instance.getIdRegistro();
    final response = await _api.getAllResidentesGuardia(
      search: search,
      regId: '${dataUser!.regId}',
      cliId: '',
      cliUbicacion: '',
      cliPuesto: '',
      token: '${dataUser.token}',
    );

    if (response != null) {
      _errorTodosLosResidentes = true;

      List dataSort = [];
      // dataSort = response['data'];
      // dataSort.sort((a, b) => b['resFecReg']!.compareTo(a['resFecReg']!));

      setListaTodosLosResidentes(response['data']);
      // setListaTodosLosResidentes(dataSort);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorTodosLosResidentes = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//==================================+++++++++++++++++++++++++++++++ OBTENEMOS EL CLIENTE POR ID  =====++++++++++++++++++++++++++++++++++++++++++++=========================//
  List<dynamic> _listaClientePorId = [];
  List<dynamic> get getListaClientePorId => _listaClientePorId;

  void setListaClientePorId(List<dynamic> data) {
    _listaClientePorId = data;

    // print('el cliente es: ${_listaClientePorId[0]} ');

    setidCliente(_listaClientePorId[0]['cliId'].toString());
    setCedulaCliente(_listaClientePorId[0]['cliDocNumero']);
    setNombreCliente(_listaClientePorId[0]['cliRazonSocial']);
    for (var item in _listaClientePorId[0]['cliDatosOperativos']) {
      //  _datosOperativos.addAll({item});
      setDatosOperativos(item);
    }
// print('object: $_datosOperativos');

    notifyListeners();
  }

  bool? _errorClientePorId; // sera nulo la primera vez
  bool? get getErrorClientePorId => _errorClientePorId;

  Future<dynamic> getInfoClientePorId() async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getClientePorId(
      idCli: '${dataUser!.id}',
      token: '${dataUser.token}',
    );

    if (response != null) {
      _errorClientePorId = true;

      setListaClientePorId(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClientePorId = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//====================OBTENEMOS INFO DE RESIDENTE=========================//
  int? _idResidente;
  int? _idPer;

  dynamic _infoResidente;
  dynamic get getInfoResidente => _infoResidente;

  void setInfoResidente(dynamic residente) {
    _infoResidente = {};
    _infoResidente = residente;

    // _idResidente = _infoResidente['resId']; // vacio
    // _idPer = _infoResidente['resPerId']; // vacio
    // _idCliente = _infoResidente['resCliId'].toString(); // vacio

    // _cedulaCliente = _infoResidente['resCliDocumento'];
    // _nombreCliente = _infoResidente['resCliNombre'];
    // setLabelNombreEstadoResidente(_infoResidente['resEstado']);
    // // _estadoResidente = _infoResidente['resEstado'];

    // _nombreUbicacion = _infoResidente['resCliUbicacion'];
    // _nombrePuesto = _infoResidente['resCliPuesto'];

    // // _datosOperativos = [];

    // _itemCedulaResidente = _infoResidente['resCedula'];

    // _itemNombresResidentes = _infoResidente['resNombres'];

    // _itemCasaDepartamentoResidente = _infoResidente['resDepartamento'];

    // _itemUbicacionResidente = _infoResidente['resUbicacion'];

    // for (var item in _infoResidente['resCorreo']) {
    //   setListaCorreoResidente(item);
    // }

    // for (var item in _infoResidente['resTelefono']) {
    //   setListaTelefonosResidente(item);
    // }
    // for (var item in _infoResidente['resPersonasAutorizadas']) {
    //   setListaPersonasAutorizadasResidente(item);
    // }
//  print('DATO INFO RESIDENTE: $_infoResidente');
    notifyListeners();
  }

//====================OBTENEMOS INFO DE CLIENTE=========================//
  String? _estadoResidente = '';
  String? get getEstadoResidente => _estadoResidente;
  void setEstadoResidente(String? val) {
    _estadoResidente = val;
    print('_estadoResidente: $_estadoResidente');
    notifyListeners();
  }

  String? _idCliente = '';
  String? get getIdCliente => _idCliente;
  void setidCliente(String? val) {
    _idCliente = val;
    print('_idCliente: $_idCliente');
    notifyListeners();
  }

  String? _cedulaCliente = '';
  String? get getCedulaCliente => _cedulaCliente;
  void setCedulaCliente(String? value) {
    _cedulaCliente = value;
    print('_cedulaCliente: $_cedulaCliente');
    notifyListeners();
  }

  String? _nombreCliente = '';
  String? get getNombreCliente => _nombreCliente;
  void setNombreCliente(String? value) {
    _nombreCliente = value;
    print('_cedulaCliente: $_cedulaCliente');
    notifyListeners();
  }

  // Map<String, dynamic>? _nombrePuesto = {};
  // Map<String, dynamic>? get getNombrePuesto => _nombrePuesto;
  // void setNombrePuesto(Map<String, dynamic>? value) {
  //   _nombrePuesto!.addAll(value!);
  //   print('_cedulaPuesto: $_nombrePuesto');
  //   notifyListeners();
  // }
  String? _nombrePuesto = '';
  String? get getNombrePuesto => _nombrePuesto;
  void setNombrePuesto(String? value) {
    _nombrePuesto = value;
    print('_nombrePuesto: $_nombrePuesto');
    notifyListeners();
  }

  String? _nombreUbicacion = '';
  String? get getNombreUbicacion => _nombreUbicacion;
  void setNombreUbicacion(String? value) {
    _nombreUbicacion = value;
    print('_nombreUbicacion: $_nombreUbicacion');
    notifyListeners();
  }

  final List<Map<String, dynamic>> _datosOperativos = [];
  List get getDatosOperativos => _datosOperativos;
  void setDatosOperativos(Map<String, dynamic> value) {
    _datosOperativos.addAll({value});
    print('_datosOperativos: $_datosOperativos');
    notifyListeners();
  }

//=======================INPUTS DEL RESIDENTE==============================//

  String? _itemCedulaResidente = '';
  String? get getItemCedula => _itemCedulaResidente;
  void setItemCedulaResidente(String? value) {
    _itemCedulaResidente = value;
  }

  String? _itemNombresResidentes = '';
  String? get getItemNombresResidentes => _itemNombresResidentes;
  void setItemNombresResidentes(String? value) {
    _itemNombresResidentes = value;
    print('_itemNombresResidentes: $_itemNombresResidentes');
    notifyListeners();
  }

  String? _itemCasaDepartamentoResidente = '';
  String? get getItemCasaDepartamentoResidente =>
      _itemCasaDepartamentoResidente;
  void setItemCasaDepartamentoResidente(String? value) {
    _itemCasaDepartamentoResidente = value;
    print('_itemCasaDepartamentoResidente: $_itemCasaDepartamentoResidente');
    notifyListeners();
  }

  String? _itemUbicacionResidente = '';
  String? get getItemUbicacionResidente => _itemUbicacionResidente;
  void setItemUbicacionResidente(String? value) {
    _itemUbicacionResidente = value;
    print('_itemUbicacionResidente: $_itemUbicacionResidente');
    notifyListeners();
  }

//======================= VALIDA CORREO==============================//

  String _email = '';

  String get getEmail => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  final List _listaCorreoResidente = [];
  List get getListaCorreoResidente => _listaCorreoResidente;
  void setListaCorreoResidente(String email) {
    _listaCorreoResidente.removeWhere((e) => e == email);
    _listaCorreoResidente.add(email);
    notifyListeners();
  }

  void deleteCorreoResidente(String email) {
    _listaCorreoResidente.removeWhere((e) => e == email);

    notifyListeners();
  }

//======================= AGREGA TELEFONO==============================//

  String _telefono = '';

  String get getTelefono => _telefono;

  void setTelefono(String telefono) {
    _telefono = telefono;
    notifyListeners();
  }

  final List _listaTelefonosResidente = [];
  List get getListaTelefonosResidente => _listaTelefonosResidente;
  void setListaTelefonosResidente(String tel) {
    _listaTelefonosResidente.removeWhere((e) => e == tel);
    _listaTelefonosResidente.add(tel);
    notifyListeners();
  }

  void deleteTelefonosResidente(String email) {
    _listaTelefonosResidente.removeWhere((e) => e == email);

    notifyListeners();
  }
//======================= AGREGA PERSONA AUTORIZADA==============================//

  String _persona = '';

  String get getPersona => _persona;

  void setPersona(String Persona) {
    _persona = Persona;
    notifyListeners();
  }

  final List _listaPersonasAutorizadasResidente = [];
  List get getListaPersonasAutorizadasResidente =>
      _listaPersonasAutorizadasResidente;
  void setListaPersonasAutorizadasResidente(String email) {
    _listaPersonasAutorizadasResidente.removeWhere((e) => e == email);
    _listaPersonasAutorizadasResidente.add(email);
    notifyListeners();
  }

  void deletePersonasAutorizadasResidente(String email) {
    _listaPersonasAutorizadasResidente.removeWhere((e) => e == email);

    notifyListeners();
  }

  //================================== CREA RESIDENTE ==============================//
  Future creaResidente(
    BuildContext context,
  ) async {
    final serviceSocket = context.read<SocketService>();
    final infoUser = await Auth.instance.getSession();

    final pyloadNuevoResidente = {
      "tabla": "residente", // defecto
      "rucempresa": infoUser!.rucempresa, //login
      "rol": infoUser.rol, // login

      "resId": _idResidente, // vacio
      "resPerId": "", // vacio
      "resCliId": _idCliente, //endpoint consumido
      "resCliDocumento": _cedulaCliente, //endpoint consumido
      "resCliNombre": _nombreCliente, //endpoint consumido
      "resCliUbicacion": _nombreUbicacion,
      "resCliPuesto": _nombrePuesto, //endpoint consumido
      "resCedula":
          _itemCedulaResidente, //num.parse(_itemCedulaResidente!.trim().toString()), //number
      "resNombres": _itemNombresResidentes, //string
      "resTelefono": _listaTelefonosResidente, // array telefonos
      "resCorreo": _listaCorreoResidente, // array correos
      "resEstado": "ACTIVA", //defecto interno
      "resDepartamento": _itemCasaDepartamentoResidente, //string
      "resUbicacion": _itemUbicacionResidente, //string
      "resPersonasAutorizadas": _listaPersonasAutorizadasResidente, //array

      "resUser": infoUser.usuario, //login
      "resEmpresa": infoUser.rucempresa,
      "resFecReg": "", // vacio
      "resFecUpd": "" // vacio
    };
    serviceSocket.socket!.emit('client:guardarData', pyloadNuevoResidente);
    print('el PAYLOAD $pyloadNuevoResidente');
  }

  //================================== CREA NUEVO COMUNICADO  ==============================//
  Future creaResidenteGuardia(
    BuildContext context,
  ) async {
    final serviceSocket = context.read<SocketService>();
    final infoUser = await Auth.instance.getSession();
    final idTurno = await Auth.instance.getIdRegistro();

    final pyloadNuevoResidenteGuardia = {
      "tabla": "residente", // defecto
      "rucempresa": infoUser!.rucempresa, //login
      "rol": infoUser.rol, // login

      "resId": _idResidente,
      "resCliId": "",
      "resCliDocumento": "",
      "resCliNombre": "",
      "resCliUbicacion": "",
      "resCliPuesto": "",
      "resCedula": _itemCedulaResidente,
      "resNombres": _itemNombresResidentes, //string
      "resTelefono": _listaTelefonosResidente, // array telefonos
      "resCorreo": _listaCorreoResidente,
      "resEstado": "ACTIVA",
      "resDepartamento": _itemCasaDepartamentoResidente, //string
      "resUbicacion": _itemUbicacionResidente, //string
      "resPersonasAutorizadas": _listaPersonasAutorizadasResidente, //array

      "resUser": infoUser.usuario, //login
      "resEmpresa": infoUser.rucempresa,
      "resFecReg": "", // vacio
      "resFecUpd": "", // vacio
      "regId": idTurno, // regId
    };
    serviceSocket.socket!
        .emit('client:guardarData', pyloadNuevoResidenteGuardia);
    print('el PAYLOAD $pyloadNuevoResidenteGuardia');
  }

  //========================== DROPDOWN ESTADO RESIDENTE=======================//
  String? _labelNombreEstadoResidente;

  String? get labelNombreEstadoResidente => _labelNombreEstadoResidente;

  void setLabelNombreEstadoResidente(String value) async {
    _labelNombreEstadoResidente = value;

    // print('el _labelNombreEstadoResidente ${_labelNombreEstadoResidente}');

    notifyListeners();
  }

  void resetEstadoResidente() {
    _labelNombreEstadoResidente;
  }

  Future editaResidente(
    BuildContext context,
  ) async {
    final serviceSocket = context.read<SocketService>();
    final infoUser = await Auth.instance.getSession();
    final idTurno = await Auth.instance.getIdRegistro();

    final pyloadEditaResidente = {
      "tabla": "residente", // defecto
      "rucempresa": infoUser!.rucempresa, //login
      "rol": infoUser.rol, // login

      "resId": _idResidente, // vacio
      "resPerId": _idPer, // vacio
      "resCliId": _idCliente, //endpoint consumido
      "resCliDocumento": _cedulaCliente, //endpoint consumido
      "resCliNombre": _nombreCliente, //endpoint consumido
      "resCliUbicacion": _nombreUbicacion,
      "resCliPuesto": _nombrePuesto, //endpoint consumido
      "resCedula":
          _itemCedulaResidente, //num.parse(_itemCedulaResidente!.trim().toString()), //number
      "resNombres": _itemNombresResidentes, //string
      "resTelefono": _listaTelefonosResidente, // array telefonos
      "resCorreo": _listaCorreoResidente, // array correos
      "resEstado": _labelNombreEstadoResidente, //defecto interno
      "resDepartamento": _itemCasaDepartamentoResidente, //string
      "resUbicacion": _itemUbicacionResidente, //string
      "resPersonasAutorizadas": _listaPersonasAutorizadasResidente, //array
      "regId": idTurno,

      //  "resId": "",
      //  "resCliId": "",
      // "resCliDocumento": "",
      // "resCliNombre": "",
      // "resCliUbicacion": "",
      // "resCliPuesto": "",
      // "resCedula": "0202626291",
      // "resNombres": "1010",
      // "resTelefono": ["aaa"],
      // "resCorreo": ["s.cmelara12@gmail.com"],
      // "resEstado": _labelNombreEstadoResidente, //defecto interno
      // "resDepartamento": "sa",
      // "resUbicacion": "aa",
      // "resPersonasAutorizadas": ["aaa"],

      "resUser": infoUser.usuario, //login
      "resEmpresa": infoUser.rucempresa,
      "resFecReg": "", // vacio
      "resFecUpd": "" // vacio
    };
    serviceSocket.socket!.emit('client:actualizarData', pyloadEditaResidente);
    // print('el PAYLOAD ${_pyloadEditaResidente}');
  }

  //===================BOTON SEARCH CLIENTE==========================//

  bool _btnSearch = false;
  bool get btnSearch => _btnSearch;

  void setBtnSearch(bool action) {
    _btnSearch = action;
    notifyListeners();
  }
  //===================BOTON SEARCH MORE CLIENTE==========================//

  // bool _btnSearchMore = false;
  // bool get btnSearchMore => _btnSearchMore;

  // void setBtnSearchMore(bool action) {
  //   _btnSearchMore = action;

  //   notifyListeners();
  // }
  List<dynamic> _filteredList = [];
  List<dynamic> get filteredList => _filteredList;
  void setListFilter(List<dynamic> list) {
    _filteredList = [];
    _filteredList.addAll(list);

// print('LA LISTA PARA FILTRAR: $_filteredList');
    notifyListeners();
  }

  // void search(String query) {
  //   List<Map<String, dynamic>> originalList =
  //       List.from(_listaTodosLosResidentes); // Copia de la lista original
  //   if (query.isEmpty) {
  //     _filteredList = originalList;
  //   } else {
  //     _filteredList = originalList.where((resident) {
  //       return
  //           // resident['resCedula'].toLowerCase().contains(query.toLowerCase()) ||
  //           resident['resNombres']
  //                   .toLowerCase().contains(query.toLowerCase());
  //               //     .contains(query.toLowerCase()) ||
  //               // resident['resApellidos']
  //               //     .toLowerCase()
  //               //     .contains(query.toLowerCase()) ||
  //               // resident['resCedulaPropietario']
  //               //     .toLowerCase()
  //               //     .contains(query.toLowerCase()) ||
  //               // resident['resNombrePropietario']
  //               //     .toLowerCase()
  //               //     .contains(query.toLowerCase()) ||
  //               // resident['resApellidoPropietario']
  //               //     .toLowerCase()
  //               //     .contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   notifyListeners();
  // }
void search(String query) {
  List<Map<String, dynamic>> originalList = List.from(_listaTodosLosResidentes); // Copia de la lista original

  if (query.isEmpty) {
    _filteredList = originalList;
  } else {
    _filteredList = originalList.where((resident) {
      // Convertimos los campos a minúsculas y aseguramos que no sean null
      String nombres = resident['resNombres'] ?? '';
      String apellidos = resident['resApellidos'] ?? '';
      String cedulaPropietario = resident['resCedulaPropietario'] ?? '';
      String nombrePropietario = resident['resNombrePropietario'] ?? '';
      String apellidoPropietario = resident['resApellidoPropietario'] ?? '';

      // Verificamos si alguno de los campos contiene la consulta
      return nombres.toLowerCase().contains(query.toLowerCase()) ||
             apellidos.toLowerCase().contains(query.toLowerCase()) ||
             cedulaPropietario.toLowerCase().contains(query.toLowerCase()) ||
             nombrePropietario.toLowerCase().contains(query.toLowerCase()) ||
             apellidoPropietario.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  notifyListeners();
}


//**********************//

  List _listaVisitasResidente = [];
  List get getListaVisitasResidente => _listaVisitasResidente;
  void setListaVisitasResidente(List info) {
    _listaVisitasResidente = [];
    _listaVisitasResidente.addAll(info);

// print('LA LISTA visitantes a residente: $_listaVisitasResidente');

    notifyListeners();
  }

  Future getTodasLasVisitasDelResidente() async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getAllVisitasResidente(
      propietario: _infoResidente["resPerId"].toString(),
      residente: _infoResidente["resPerIdPropietario"].toString(),
      token: '${dataUser!.token}',
    );
    if (response != null) {
      List dataSort = [];
      dataSort = response['data'];
      dataSort.sort((a, b) => b['bitFecReg']!.compareTo(a['bitFecReg']!));
      setListaVisitasResidente(dataSort);
      notifyListeners();
      return response;
    }
    if (response == null) {
      notifyListeners();
      return null;
    }
    return null;
  }





//====================  CREAR RESIDENTES  ==========================//
Map<String,dynamic> _infoCliente={};
Map<String,dynamic> get infoCliente=>_infoCliente;
 String _idNuevoCliente ='';
  
 String get idNuevoCliente =>_idNuevoCliente;
    String _cedulaNuevoCliente = '';
     String get cedulaNuevoCliente =>_cedulaNuevoCliente;
   String _nombreNuevoCliente = '';
    String get nombreNuevoCliente =>_nombreNuevoCliente;

List _cliDatosOperativos=[];
List get cliDatosOperativos=>_cliDatosOperativos;
 Map<String,dynamic> _puesto = {};
   Map<String,dynamic> get puestos =>_puesto;

void setPuestos( Map<String,dynamic> _item){
   _puesto = {};
    _puesto = _item;
     print('puesto $_puesto');
    notifyListeners();
}

 void getInfoClientes(dynamic cliente) {
       _idNuevoCliente ='';
      _cedulaNuevoCliente = '';
    _nombreNuevoCliente = '';
    _cliDatosOperativos=[];

     _infoCliente={};
      _infoCliente.addAll(cliente);

     

         _idNuevoCliente = cliente['cliId'].toString();
   _cedulaNuevoCliente = cliente['cliDocNumero'];
   _nombreNuevoCliente = cliente['cliRazonSocial'];
      _cliDatosOperativos=[];
      _cliDatosOperativos=cliente['cliDatosOperativos'];
      // for (var item in cliente['cliDatosOperativos']) {
      //   _cliDatosOperativos.add(item);
      // }
      print('INFOCLIENTE $_infoCliente');
        print('_cliDatosOperativos $_cliDatosOperativos');
      notifyListeners();
  }

  String? _itemTipoPersona = '';
  String? get getItemTipoPersonal => _itemTipoPersona;
  void setItemTipoPersona(String? val) {
    _itemTipoPersona = val;
    print('TIPO DE PERSONA: $_itemTipoPersona');
    notifyListeners();
  }

//==========RADIO DOCUMENTOs============//
String _selectedTypePropietario = 'CEDULA'; // Valor inicial

  String get selectedTypePropietario => _selectedTypePropietario;

  void setSelectedTypePropietario(String type) {
    _selectedTypePropietario = type;
    notifyListeners(); // Notifica a los widgets que usan este provider
  }
  String _selectedTypeArrendatario = 'CEDULA'; // Valor inicial

  String get selectedTypeArrendatario => _selectedTypeArrendatario;

  void setSelectedTypeArrendatario(String type) {
    _selectedTypeArrendatario = type;
    notifyListeners(); // Notifica a los widgets que usan este provider
  }



//==========BUSCA PERSONA============//
Map<String,dynamic> _dataPersona={};
Map<String,dynamic> get dataPersona=>_dataPersona;

 Map<String,dynamic> _dataPersonaPropietario={};
Map<String,dynamic> get dataPersonaPropietario=>_dataPersonaPropietario;
Future buscaPersona(String _doc, String _tipoDoc, String perfil) async {
  final dataUser = await Auth.instance.getSession();
  final response = await _api.getPersonaResidente(
    documento: _doc,
    tipo: _tipoDoc,
    perfil: perfil,
    token: '${dataUser!.token}',
  );
 

  if (response != null) {
    if (perfil == 'RESIDENTE') {
      _dataPersona = response;
     
    } else if (perfil == 'PROPIETARIO') {
      _dataPersonaPropietario = response;
     
    }

    notifyListeners();
    return response;
  }

  notifyListeners();
  return null;
}
//====================ARRENDATARIO=====================//
 String? _cedulaNArrendatario = '';
  get getCedulaNArrendatario => _cedulaNArrendatario;
  void setCedulaNArrendatario(String? date) {
    _cedulaNArrendatario = date;
    notifyListeners();
  }

  String? _nombreNArrendatario = '';
  get getNombreNArrendatario => _nombreNArrendatario;
  void setNombreNArrendatario(String? date) {
    _nombreNArrendatario = date;
    notifyListeners();
  }

    String? _apellidoNArrendatario = '';
  get getApellidoNArrendatario => _apellidoNArrendatario;
  void setApellidoNArrendatario(String? date) {
    _apellidoNArrendatario = date;
    notifyListeners();
  }

//====================ARRENDATARIO=====================//
 String? _cedulaNPropietario = '';
  get getCedulaNPropietario => _cedulaNPropietario;
  void setCedulaNPropietario(String? date) {
    _cedulaNPropietario = date;
    notifyListeners();
  }

  String? _nombreNPropietario = '';
  get getNombreNPropietario => _nombreNPropietario;
  void setNombreNPropietario(String? date) {
    _nombreNPropietario = date;
    notifyListeners();
  }

    String? _apellidoNPropietario = '';
  get getApellidoNPropietario => _apellidoNPropietario;
  void setApellidoNPropietario(String? date) {
    _apellidoNPropietario = date;
    notifyListeners();
  }

//====================TELEFONOS=====================//
 List _listaTelefonosArrendatarios= [];
 List get getListaTelefonosArrendatarios => _listaTelefonosArrendatarios;
  void setListaTelefonosArrendatarios(String? tel) {
    _listaTelefonosArrendatarios.add(tel);
    notifyListeners();
  }

void deleteTelefonoArrendatario(String _item){

_listaTelefonosArrendatarios.remove(_item);
  notifyListeners();
}



 List _listaTelefonosPropietarios= [];
 List get getListaTelefonosPropietarios => _listaTelefonosPropietarios;
  void setListaTelefonosPropietarios(String? tel) {
    _listaTelefonosPropietarios.add(tel);
    notifyListeners();
  }
void deleteTelefonoPropietario(String _item){

_listaTelefonosPropietarios.remove(_item);
  notifyListeners();
}

//====================CORREOS=====================//

 List _listaCorreosArrendatarios= [];
 List get getListaCorreosArrendatarios => _listaCorreosArrendatarios;
  void setListaCorreosArrendatarios(String? tel) {
    _listaCorreosArrendatarios.add(tel);
    notifyListeners();
  }

void deleteCorreoArrendatario(String _item){

_listaCorreosArrendatarios.remove(_item);
  notifyListeners();
}

 List _listaCorreosPropietarios= [];
 List get getListaCorreosPropietarios => _listaCorreosPropietarios;
  void setListaCorreosPropietarios(String? tel) {
    _listaCorreosPropietarios.add(tel);
    notifyListeners();
  }

void deleteCorreoPropietario(String _item){

_listaCorreosPropietarios.remove(_item);
  notifyListeners();
}




//====================LISTA PROPIEDAD=====================//

 List _listaPropiedad= [];
 List get getListaPropiedad => _listaPropiedad;
  void setListaPropiedad(Map<String,dynamic> tel) {
    _listaPropiedad.add(tel);
    notifyListeners();
  }

void deletePropiedad(Map<String,dynamic> _item){

_listaPropiedad.remove(_item);
  notifyListeners();
}

//*************************//


  String? _inputObservacionNResidente;
  String? get getInputObservacionNResidente => _inputObservacionNResidente;
  void onObservacionChange(String? text) {
    _inputObservacionNResidente = text;
    notifyListeners();
  }
  //===============  CREA NUEVO RESIDENTE ===============//

Future crearNuevoResidente(
    BuildContext context,
  ) async {
    final serviceSocket = context.read<SocketService>();
    final infoUser = await Auth.instance.getSession();
    // final idTurno = await Auth.instance.getIdRegistro();

    final pyloadNuevoResidente = {
 "tabla": "residente", // defecto
  "rucempresa": infoUser!.rucempresa, //login
  "rol": infoUser.rol, // login
  "resUser":  infoUser.usuario, // login
  "resEmpresa":  infoUser.rucempresa, // login

  "resId": "", // default
  "resTipoResidente": _itemTipoPersona, // selected
  "resCliId": _idNuevoCliente, // tomar del endpoit consumido
  "resCliUbicacion": puestos['ubicacion'], // selected
  "resCliPuesto": puestos['puesto'], // selected
  "resObservacion": _inputObservacionNResidente, // input
  "resCliDocumento": "", // vacio
  "resCliNombre": "", // vacio

  "resPerId":_itemTipoPersona== "ARRENDATARIO" ? _dataPersona['perId']:0, // 0 porque es "resTipoResidente": "PROPIETARIO",
  "resTipoDocu": _itemTipoPersona== "ARRENDATARIO" ? _selectedTypeArrendatario:null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resCedula": _itemTipoPersona== "ARRENDATARIO" ? _cedulaNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resNombres":  _itemTipoPersona== "ARRENDATARIO" ? _nombreNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resApellidos":  _itemTipoPersona== "ARRENDATARIO" ? _apellidoNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resTelefono":  _itemTipoPersona== "ARRENDATARIO" ? _listaTelefonosArrendatarios: [], // vacio porque es "resTipoResidente": "PROPIETARIO",
  "resCorreo":  _itemTipoPersona== "ARRENDATARIO" ? _listaCorreosArrendatarios: [], // vacio porque es "resTipoResidente": "PROPIETARIO",
  "resEstado": null, // default

  "resPerIdPropietario": _dataPersonaPropietario['perId'], // tomar del endpoit consumido
  "resTipoDocuPropietario": _selectedTypeArrendatario, // radio button
  "resCedulaPropietario": _cedulaNPropietario, // input
  "resNombrePropietario": _nombreNPropietario, // input
  "resApellidoPropietario": _apellidoNPropietario, // input
  "resTelefonoPropietario": _listaTelefonosPropietarios, // input
  "resCorreoPropietario": _listaCorreosPropietarios, // input
  "resDepartamento": _listaPropiedad
   
};
serviceSocket.socket!.emit('client:guardarData', pyloadNuevoResidente);
  



  }



//=========== OBTENEMOS LA INFORMACION DEL ITEM RESIDENTE ===============//

dynamic _infoItemResidente={};
dynamic get infoItemResidente=>_infoItemResidente;
int?_idArendatario;
int?_idPropietario;
int? _idItemResidente ;
void getDataInfoResidente(dynamic _info) {
_infoItemResidente={};
_infoItemResidente=_info;
print('_infoItemResidente :  ${_infoItemResidente}');

       _idItemResidente =_infoItemResidente['resId']; 

  _idNuevoCliente =_infoItemResidente['resCliId'].toString();
  _cedulaNuevoCliente = _infoItemResidente['resCliDocumento'];
 _nombreNuevoCliente = _infoItemResidente['resCliNombre'];
 _itemTipoPersona=_infoItemResidente['resTipoResidente'];

 _selectedTypeArrendatario =_infoItemResidente['resTipoDocu']??'';
 
 _idArendatario=int.parse(_infoItemResidente['resPerId'].toString());
 _cedulaNArrendatario=_infoItemResidente['resCedula'];
 _nombreNArrendatario=_infoItemResidente['resNombres'];
 _apellidoNArrendatario=_infoItemResidente['resApellidos'];
 _listaTelefonosArrendatarios=_infoItemResidente['resTelefono'];
 _listaCorreosArrendatarios=_infoItemResidente['resCorreo'];


 _selectedTypePropietario =_infoItemResidente['resTipoDocuPropietario']??'';
 
 _idPropietario=int.parse(_infoItemResidente['resPerIdPropietario'].toString());
 _cedulaNPropietario=_infoItemResidente['resCedulaPropietario'];
 _nombreNPropietario=_infoItemResidente['resNombrePropietario'];
 _apellidoNPropietario=_infoItemResidente['resApellidoPropietario'];
 _listaTelefonosPropietarios=_infoItemResidente['resTelefonoPropietario'];
 _listaCorreosPropietarios=_infoItemResidente['resCorreoPropietario'];

_listaPropiedad= _infoItemResidente['resDepartamento'];
_inputObservacionNResidente=_infoItemResidente['resObservacion'];

  

  notifyListeners();
}

//===============  CREA NUEVO RESIDENTE ===============//

Future editaNuevoResidente(
    BuildContext context,
  ) async {
    final serviceSocket = context.read<SocketService>();
    final infoUser = await Auth.instance.getSession();
    // final idTurno = await Auth.instance.getIdRegistro();

    final pyloadEditaResidente = {

       "resId": _idItemResidente, // default
  "resTipoResidente": _itemTipoPersona, // selected
  "resCliId": _idNuevoCliente, // tomar del endpoit consumido
  "resCliUbicacion": puestos['ubicacion'], // selected
  "resCliPuesto": puestos['puesto'],
  "resObservacion": _inputObservacionNResidente, // input
  "resCliDocumento": '', // vacio
  "resCliNombre": '', // vacio

  // "resPerId": _idArendatario, // tomar del endpoit consumido
  // "resTipoDocu": _selectedTypeArrendatario, // radio button
  // "resCedula": _cedulaNArrendatario, // input
  // "resNombres": _nombreNArrendatario, // input
  // "resApellidos": _apellidoNArrendatario, // input
  // "resTelefono": _listaTelefonosArrendatarios, // input
  // "resCorreo": _listaCorreosArrendatarios, // input

  "resPerId":_itemTipoPersona== "ARRENDATARIO" ? _idArendatario:0, // 0 porque es "resTipoResidente": "PROPIETARIO",
  "resTipoDocu": _itemTipoPersona== "ARRENDATARIO" ? _selectedTypeArrendatario:null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resCedula": _itemTipoPersona== "ARRENDATARIO" ? _cedulaNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resNombres":  _itemTipoPersona== "ARRENDATARIO" ? _nombreNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resApellidos":  _itemTipoPersona== "ARRENDATARIO" ? _apellidoNArrendatario: null, // null porque es "resTipoResidente": "PROPIETARIO",
  "resTelefono":  _itemTipoPersona== "ARRENDATARIO" ? _listaTelefonosArrendatarios: [], // vacio porque es "resTipoResidente": "PROPIETARIO",
  "resCorreo":  _itemTipoPersona== "ARRENDATARIO" ? _listaCorreosArrendatarios: [], 



  "resEstado": null, // default
 
  "resPerIdPropietario":_idPropietario, // tomar del endpoit consumido
  "resTipoDocuPropietario": _selectedTypePropietario, // radio button
  "resCedulaPropietario": _cedulaNPropietario, // input
  "resNombrePropietario": _nombreNPropietario, // input
  "resApellidoPropietario": _apellidoNPropietario, // input
  "resTelefonoPropietario": _listaTelefonosPropietarios, // input
  "resCorreoPropietario": _listaCorreosPropietarios, // input
  "resDepartamento": _listaPropiedad, // input

 "tabla": "residente", // defecto
  "rucempresa": infoUser!.rucempresa, //login
  "rol": infoUser.rol, // login
  "resUser":  infoUser.usuario, // login
  "resEmpresa":  infoUser.rucempresa, // login
   
};
serviceSocket.socket!.emit('client:actualizarData', pyloadEditaResidente);
  
    print('estae es el JSON : $pyloadEditaResidente');


  }




}
