import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/ausencias_controller.dart';
import 'package:nseguridad/src/controllers/aviso_salida_controller.dart';
import 'package:nseguridad/src/controllers/cambio_puesto_controller.dart';
import 'package:nseguridad/src/controllers/multas_controller.dart';
import 'package:nseguridad/src/controllers/turno_extra_controller.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/widgets/dropdown_motivo_turno_extra.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class CreaTurnoEmergente extends StatefulWidget {
  final String? tipo;
  const CreaTurnoEmergente({super.key, this.tipo});

  @override
  State<CreaTurnoEmergente> createState() => _CreaTurnoEmergenteState();
}

class _CreaTurnoEmergenteState extends State<CreaTurnoEmergente> {
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinController = TextEditingController();

  late TimeOfDay timerInicio;
  late TimeOfDay timerFin;

  @override
  void initState() {
    initload();
    super.initState();
  }

  void initload() async {
    timerInicio = TimeOfDay.now();
    timerFin = TimeOfDay.now();
  }

  @override
  void dispose() {
    _fechaInicioController.clear();
    _fechaFinController.clear();
    _horaFinController.clear();
    _horaFinController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('EL TIPO ES: ${widget.tipo}');
    Responsive size = Responsive.of(context);
    final turnoExtraController = Provider.of<TurnoExtraController>(context);
    final ctrlTheme = context.read<ThemeApp>();

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              final controllerMulta = context.read<MultasGuardiasContrtoller>();
              return AlertDialog(
                title: const Text('Aviso'),
                content: const Text(
                    'Debe designar un guardia al puesto de trabajo para poder continuar con el proceso de multa'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        controllerMulta.resetValuesMulta();
                        controllerMulta.resetValuesTurnoEmergente();
                        controllerMulta.setTurnoEmergenteGuardado(false);
                        // controllerMulta.setCedTurnoMulta(null);
                        turnoExtraController.setNombreGuardia('');

                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            // color: Colors.white,
                            fontWeight: FontWeight.normal),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Aceprar',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              );
            });
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: const Color(0xFFEEEEEE),
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        ctrlTheme.primaryColor,
                        ctrlTheme.secondaryColor,
                      ],
                    ),
                  ),
                ),
                title: const Text(
                  'Crear Turno Emergente',
                  // style:  Theme.of(context).textTheme.headline2,
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: size.iScreen(1.5)),
                    child: IconButton(
                        splashRadius: 28,
                        onPressed: () {
                          _onSubmit(context, turnoExtraController);
                        },
                        icon: Icon(
                          Icons.save_outlined,
                          size: size.iScreen(4.0),
                        )),
                  )
                ],
              ),
              body: Container(
                  // color: Colors.red,
                  margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                  padding: EdgeInsets.only(
                    top: size.iScreen(0.5),
                    left: size.iScreen(0.5),
                    right: size.iScreen(0.5),
                    bottom: size.iScreen(0.5),
                  ),
                  width: size.wScreen(100.0),
                  height: size.hScreen(100),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: turnoExtraController.turnoExtraFormKey,
                      child: Column(
                        children: [
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/

                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Cliente :',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // color: Colors.red,
                                  padding: EdgeInsets.only(
                                    top: size.iScreen(1.0),
                                    right: size.iScreen(0.5),
                                  ),
                                  child: Consumer<MultasGuardiasContrtoller>(
                                    builder: (_, cliente, __) {
                                      return (cliente.getNomClienteMulta ==
                                                  '' ||
                                              cliente.getNomClienteMulta ==
                                                  null)
                                          ? Text(
                                              'No hay cliente seleccionado',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.8),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              '${cliente.getNomClienteMulta} ',
                                              style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.8),
                                                fontWeight: FontWeight.normal,
                                                // color: Colors.grey
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/
                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Puesto:',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),

                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.iScreen(2.0),
                                    vertical: size.iScreen(0)),
                                // width: size.wScreen(100),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Consumer<MultasGuardiasContrtoller>(
                                    builder: (_, puestos, __) {
                                      return (puestos.labelPuestosCliente ==
                                                  '' ||
                                              puestos.labelPuestosCliente ==
                                                  null)
                                          ? Text('Selecciones Puesto',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.8),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey))
                                          : SizedBox(
                                              // color:Colors.red,
                                              width: size.wScreen(80),
                                              child: Text(
                                                '${puestos.labelPuestosCliente}',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.8),
                                                  fontWeight: FontWeight.normal,
                                                  // color: Colors.grey
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ),
                              //***********************************************/
                              const Spacer(),
                              Consumer<MultasGuardiasContrtoller>(
                                builder: (_, valueProv, __) {
                                  return (valueProv.getNomClienteMulta == '' ||
                                          valueProv.getNomClienteMulta == null)
                                      ? Container()
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child:
                                              GestureDetector(onTap: () async {
                                            final controllerMulta = context.read<
                                                MultasGuardiasContrtoller>();
                                            controllerMulta
                                                .resetValuesTurnoEmergente();

                                            if (widget.tipo == 'MULTAS') {
                                              controllerMulta.setNomCliente(
                                                  controllerMulta
                                                      .getNomClienteMulta);
                                              await controllerMulta
                                                  .getTodosLosPuestosDelCliente(
                                                      controllerMulta
                                                          .getCedClienteMulta);
                                            } else if (widget.tipo ==
                                                'PERMISO') {
                                              final controllerAusencia = context
                                                  .read<AusenciasController>();
                                              controllerMulta.setNomCliente(
                                                  controllerAusencia
                                                      .nombreCliente);
                                              await controllerMulta
                                                  .getTodosLosPuestosDelCliente(
                                                      '2360006130001');
                                            }
                                            _modalPuestos(
                                                context, size, controllerMulta);
                                          }, child: Consumer<ThemeApp>(
                                            builder: (_, valueTheme, __) {
                                              return Container(
                                                alignment: Alignment.center,
                                                color: valueTheme.primaryColor,
                                                width: size.iScreen(3.5),
                                                padding: EdgeInsets.only(
                                                  top: size.iScreen(0.5),
                                                  bottom: size.iScreen(0.5),
                                                  left: size.iScreen(0.5),
                                                  right: size.iScreen(0.5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      valueTheme.secondaryColor,
                                                  size: size.iScreen(2.0),
                                                ),
                                              );
                                            },
                                          )),
                                        );
                                },
                              ),
                            ],
                          ),

                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/

                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Guardia :',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // color: Colors.red,
                                  padding: EdgeInsets.only(
                                    top: size.iScreen(1.0),
                                    right: size.iScreen(0.5),
                                  ),
                                  child: Consumer<TurnoExtraController>(
                                    builder: (_, persona, __) {
                                      return (persona.nombreGuardia == '' ||
                                              persona.nombreGuardia == null)
                                          ? Text(
                                              'No hay guardia designado',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.8),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              '${persona.nombreGuardia} ',
                                              style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.8),
                                                fontWeight: FontWeight.normal,
                                                // color: Colors.grey
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ),
                              Consumer<MultasGuardiasContrtoller>(
                                builder: (_, personaCliente, __) {
                                  return (personaCliente.getNomClienteMulta ==
                                              '' ||
                                          personaCliente.getNomClienteMulta ==
                                              null)
                                      ? Container()
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: GestureDetector(onTap: () {
                                            _modalSeleccionaGuardia(
                                                size, turnoExtraController);
                                          }, child: Consumer<ThemeApp>(
                                            builder: (_, valueTheme, __) {
                                              return Container(
                                                alignment: Alignment.center,
                                                color: valueTheme.primaryColor,
                                                width: size.iScreen(3.5),
                                                padding: EdgeInsets.only(
                                                  top: size.iScreen(0.5),
                                                  bottom: size.iScreen(0.5),
                                                  left: size.iScreen(0.5),
                                                  right: size.iScreen(0.5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      valueTheme.secondaryColor,
                                                  size: size.iScreen(2.0),
                                                ),
                                              );
                                            },
                                          )),
                                        );
                                },
                              ),
                            ],
                          ),

                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/
                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Fecha de turno extra :',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Desde:',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: size.wScreen(35),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.wScreen(3.5)),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      controller: _fechaInicioController,
                                      decoration: InputDecoration(
                                        hintText: 'yyyy-mm-dd',
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                        suffixIcon: IconButton(
                                          color: Colors.red,
                                          splashRadius: 20,
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            _selectFechaInicio(
                                                context, turnoExtraController);
                                          },
                                          icon: const Icon(
                                            Icons.date_range_outlined,
                                            // color: primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {},
                                      onSaved: (value) {},
                                      validator: (text) {
                                        if (text!.trim().isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Ingrese fecha de inicio';
                                        }
                                      },
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hora:',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: size.wScreen(35),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.wScreen(3.5)),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      controller: _horaInicioController,
                                      decoration: InputDecoration(
                                        hintText: '00:00',
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                        suffixIcon: IconButton(
                                          color: Colors.red,
                                          splashRadius: 20,
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            _seleccionaHoraInicio(
                                                context, turnoExtraController);
                                            // _selectFechaFin(
                                            //     context, consignaController);
                                          },
                                          icon: const Icon(
                                            Icons.access_time_outlined,
                                            // color: primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {},
                                      onSaved: (value) {},
                                      validator: (text) {
                                        if (text!.trim().isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Ingrese hora de inicio';
                                        }
                                      },
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //***********************************************/

                          SizedBox(
                            height: size.iScreen(2.0),
                          ),

                          //*******************FECHA HORA HASTA **********************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Hasta:',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: size.wScreen(35),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.wScreen(3.5)),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      controller: _fechaFinController,
                                      decoration: InputDecoration(
                                        hintText: 'yyyy-mm-dd',
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                        suffixIcon: IconButton(
                                          color: Colors.red,
                                          splashRadius: 20,
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            _selectFechaFin(
                                                context, turnoExtraController);
                                          },
                                          icon: const Icon(
                                            Icons.date_range_outlined,
                                            // color: primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {},
                                      onSaved: (value) {},
                                      validator: (text) {
                                        if (text!.trim().isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Ingrese fecha de límite';
                                        }
                                      },
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Hora:',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // InputTimePiker(label: 'Hora', size: size,),

                                  Container(
                                    width: size.wScreen(35),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.wScreen(3.5)),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      controller: _horaFinController,
                                      decoration: InputDecoration(
                                        hintText: '00:00',
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                        suffixIcon: IconButton(
                                          color: Colors.red,
                                          splashRadius: 20,
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            _seleccionaHoraFin(
                                                context, turnoExtraController);
                                            // _selectFechaFin(
                                            //     context, consignaController);
                                          },
                                          icon: const Icon(
                                            Icons.access_time_outlined,
                                            // color: primaryColor,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {},
                                      onSaved: (value) {},
                                      validator: (text) {
                                        if (text!.trim().isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Ingrese hora Límite';
                                        }
                                      },
                                      style: const TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          //*****************************************/

                          Row(
                            children: [
                              SizedBox(
                                width: size.wScreen(30.0),

                                // color: Colors.blue,
                                child: Text('Días de turno:',
                                    style: GoogleFonts.lexendDeca(
                                        // fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              SizedBox(
                                width: size.wScreen(20.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(),
                                  onChanged: (text) {
                                    turnoExtraController
                                        .onNumeroDiasChange(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Ingrese días';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/
                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Motivo:',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          const DropMenuMotivoTurnoExtra(
                            data: [
                              'FALTA INJUSTIFICADA',
                              'PERMISO MEDICO',
                              'ABANDONO DE PUESTO',
                              'EVENTO ESPECIAL',
                            ],
                            hinText: 'seleccione Motivo',
                          ),
                          //***********************************************/
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          //*****************************************/
                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Autorizado por:',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                // suffixIcon: Icon(Icons.beenhere_outlined)
                                ),
                            textAlign: TextAlign.start,
                            style: const TextStyle(),
                            onChanged: (text) {
                              turnoExtraController.onAutorizadoPorChange(text);
                            },
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese detalle del aviso';
                              }
                            },
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          //*****************************************/
                          SizedBox(
                            width: size.wScreen(100.0),

                            // color: Colors.blue,
                            child: Text('Detalle:',
                                style: GoogleFonts.lexendDeca(
                                    // fontSize: size.iScreen(2.0),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(),
                            onChanged: (text) {
                              turnoExtraController.onDetalleChange(text);
                            },
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese detalle del aviso';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ))),
        ),
      ),
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(BuildContext context, TurnoExtraController controller) async {
    final controllerMulta = context.read<MultasGuardiasContrtoller>();
    final controllerAusencia = context.read<AusenciasController>();
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      if (controller.nombreGuardia!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      } else if (controller.labelMotivoTurnoExtra!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Motivo');
      } else if (controllerMulta.labelPuestosCliente == null) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Puesto');
      } else {
        controller.getInfoClienteTurnoEmergente(
            controllerMulta.getDatosDelCliente[0]);
        controller.getTurnoEmergente();
// =================================================//
        final serviceSocket = context.read<SocketService>();
        serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
          if (data['tabla'] == 'turnoextra') {
            NotificatiosnService.showSnackBarSuccsses(data['msg']);
            controllerMulta.setTurnoEmergenteGuardado(true);
            if (widget.tipo == 'MULTAS') {
              controllerMulta.setDataTurnoEmergente(data);
              controllerMulta.setIdTurnoEmergente(data['turId'].toString());
              Navigator.of(context).pop(true);
            }
            if (widget.tipo == 'PERMISO') {
              controllerAusencia.setDataTurnoEmergente(data);
              controllerAusencia.setIdTurnoEmergente(data['turId'].toString());

              Navigator.of(context).pop(true);
            }
          }
        });
        serviceSocket.socket?.on('server:error', (data) {
          controllerMulta.setTurnoEmergenteGuardado(false);
          NotificatiosnService.showSnackBarError(data['msg']);
          Navigator.of(context).pop(false);
        });
      }
    }
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaGuardia(
      Responsive size, TurnoExtraController turnoExtraController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SELECCIONAR GUARDIA',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.qr_code_2, color: Colors.black),
                        title: Text(
                          "Código QR",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () async {
                          _validaScanQRGuardia(turnoExtraController);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Nómina de Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          Navigator.pop(context);
                          Provider.of<AvisoSalidaController>(context,
                                  listen: false)
                              .buscaInfoGuardias('');
                          Navigator.pushNamed(context, 'buscaGuardias',
                              arguments: 'turnoExtra');
                        },
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //====== MUESTRA MODAL  =======//
  void _modalSeleccionaCliente(
      Responsive size, TurnoExtraController turnoExtraController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SELECCIONAR CLIENTE',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.qr_code_2, color: Colors.black),
                        title: Text(
                          "Código QR",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () async {
                          _validaScanQRCliente(turnoExtraController);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Nómina de Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          Provider.of<CambioDePuestoController>(context,
                                  listen: false)
                              .getTodosLosClientes('');
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'buscaClientes',
                              arguments: 'turnoExtra');
                        },
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFechaInicio(
      BuildContext context, TurnoExtraController turnoExtraController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      String? anio, mes, dia;
      anio = '${picked.year}';
      mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
      dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

      final fechaInicio =
          '${anio.toString()}-${mes.toString()}-${dia.toString()}';
      _fechaInicioController.text = fechaInicio;
      turnoExtraController.onInputFechaInicioChange(fechaInicio);
    }
  }

  //================================================= SELECCIONA FECHA FIN ==================================================//
  _selectFechaFin(
      BuildContext context, TurnoExtraController turnoExtraController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      String? anio, mes, dia;
      anio = '${picked.year}';
      mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
      dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

      setState(() {
        final fechaFin =
            '${anio.toString()}-${mes.toString()}-${dia.toString()}';
        _fechaFinController.text = fechaFin;
        turnoExtraController.onInputFechaFinChange(fechaFin);
      });
    }
  }

  void _seleccionaHoraInicio(
      context, TurnoExtraController turnoExtraController) async {
    TimeOfDay? hora =
        await showTimePicker(context: context, initialTime: timerInicio);

    if (hora != null) {
      String? dateHora = (hora.hour < 10) ? '0${hora.hour}' : '${hora.hour}';
      String? dateMinutos =
          (hora.minute < 10) ? '0${hora.minute}' : '${hora.minute}';

      setState(() {
        timerInicio = hora;
        String horaInicio = '$dateHora:$dateMinutos';
        _horaInicioController.text = horaInicio;
        turnoExtraController.onInputHoraInicioChange(horaInicio);
      });
    }
  }

  void _seleccionaHoraFin(
      context, TurnoExtraController turnoExtraController) async {
    TimeOfDay? hora =
        await showTimePicker(context: context, initialTime: timerFin);
    if (hora != null) {
      String? dateHora = (hora.hour < 10) ? '0${hora.hour}' : '${hora.hour}';
      String? dateMinutos =
          (hora.minute < 10) ? '0${hora.minute}' : '${hora.minute}';

      setState(() {
        timerFin = hora;
        print(timerFin.format(context));
        String horaFin = '$dateHora:$dateMinutos';
        _horaFinController.text = horaFin;
        turnoExtraController.onInputHoraFinChange(horaFin);
        //  print('si: $horaFin');
      });
    }
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRGuardia(TurnoExtraController turnoExtraController) async {
    turnoExtraController.setInfoQRGuardia(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRCliente(TurnoExtraController turnoExtraController) async {
    turnoExtraController.setInfoQRCliente(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }

  //======================== MODAL PUESTOS =======================//

  Future<String?> _modalPuestos(BuildContext context, Responsive size,
      MultasGuardiasContrtoller controller) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Puestos')),
        content: SizedBox(
          height: size.hScreen(50.0),
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: controller.getListaTodosLosPuestosDelCliente.length,
            itemBuilder: (BuildContext context, int index) {
              if (controller.getListaTodosLosPuestosDelCliente.isEmpty) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
              }
              final puestos =
                  controller.getListaTodosLosPuestosDelCliente[index];

              return ListTile(
                onTap: () {
                  controller.setLabelPuestosCliente(puestos);

                  // controller.setTipoAlimento(e['nombre']);

                  Navigator.pop(context);
                },
                title: Text('$puestos'),
              );
            },
          ),
        ),
      ),
    );
  }
}
