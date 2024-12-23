import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nseguridad/src/controllers/ausencias_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/multas_controller.dart';
import 'package:nseguridad/src/controllers/turno_extra_controller.dart';
import 'package:nseguridad/src/models/lista_allNovedades_guardia.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/detalle_falta_injustificada.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/fecha_local_convert.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaFaltasInjustificadas extends StatefulWidget {
  final Session? user;
  const ListaFaltasInjustificadas({super.key, this.user});

  @override
  State<ListaFaltasInjustificadas> createState() =>
      _ListaFaltasInjustificadasState();
}

class _ListaFaltasInjustificadasState extends State<ListaFaltasInjustificadas> {
  final TextEditingController _textSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final loadInfo =
        Provider.of<MultasGuardiasContrtoller>(context, listen: false);
    // loadInfo.getTodasLasMultasGuardia('', 'false');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket?.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'respuestaInforme') {
        loadInfo.getTodasLasMultasGuardia('', 'false');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket?.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'respuestaInforme') {
        loadInfo.getTodasLasMultasGuardia('', 'false');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final multasControler = Provider.of<MultasGuardiasContrtoller>(context);
    final user = context.read<HomeController>().getUsuarioInfo;
    final ctrlTheme = context.read<ThemeApp>();

    return SafeArea(
      child: Scaffold(
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
          title: Consumer<MultasGuardiasContrtoller>(
            builder: (_, providerSearch, __) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                      child: (providerSearch.btnSearch)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      // margin: EdgeInsets.symmetric(
                                      //     horizontal: size.iScreen(0.0)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.5)),
                                      color: Colors.white,
                                      height: size.iScreen(4.0),
                                      child: TextField(
                                        controller: _textSearchController,
                                        autofocus: true,
                                        onChanged: (text) {
                                          // multasControler.onSearchText(text);
                                          multasControler.filtrarfaltas(text);
                                          
                                          // setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          // icon: Icon(Icons.search),
                                          border: InputBorder.none,
                                          hintText: 'Buscar...',
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        border:
                                            // Border.all(
                                            //     color: Colors.white)
                                            Border(
                                          left: BorderSide(
                                              width: 0.0, color: Colors.grey),
                                        ),
                                      ),
                                      height: size.iScreen(4.0),
                                      width: size.iScreen(3.0),
                                      child: const Icon(Icons.search,
                                          color: Colors.white),
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              width: size.wScreen(90.0),
                              child: const Text(
                                'Faltas Injustificadas',
                                // style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                    ),
                  ),
                  IconButton(
                      splashRadius: 2.0,
                      icon: (!providerSearch.btnSearch)
                          ? Icon(
                              Icons.search,
                              size: size.iScreen(3.5),
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.clear,
                              size: size.iScreen(3.5),
                              color: Colors.white,
                            ),
                      onPressed: () {
                        providerSearch.setBtnSearch(!providerSearch.btnSearch);
                        _textSearchController.text = "";
                        providerSearch.getTodasLasMultasGuardia('', 'false');
                      }),
                ],
              );
            },
          ),
          //       actions: [
          //   Container(
          //     margin: EdgeInsets.only(right: size.iScreen(1.5)),
          //     child: IconButton(
          //         splashRadius: 28,
          //         onPressed: () {
          //           final _control =
          //               context.read<MultasGuardiasContrtoller>();

          //           _control.resetValuesMulta();

          //           _control.getTodasLasMultasGuardia('', 'false');
          //         },
          //         icon: Icon(
          //           Icons.refresh_outlined,
          //           size: size.iScreen(3.0),
          //         )),
          //     //  IconButton(
          //     //             icon: Icon(Icons.check),
          //     //             onPressed: () {
          //     //               final selectedItems = dataProvider.getSelectedItems();
          //     //               if (selectedItems.isNotEmpty) {
          //     //                 // Realizar acción con los elementos seleccionados
          //     //                 print('Elementos seleccionados: $selectedItems');
          //     //               }
          //     //             },
          //     //           ),
          //   )
          // ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.0),
          ),
          padding: EdgeInsets.only(
            top: size.iScreen(2.0),
            left: size.iScreen(0.0),
            right: size.iScreen(0.0),
          ),
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),
          child: Column(
            children: [
              Container(
                  width: size.wScreen(100.0),
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${widget.user!.rucempresa!}  ',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.5),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold)),
                      Text('-',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.5),
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      Text('  ${widget.user!.usuario!} ',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.5),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.5),
              ),
              //*****************************************/
              Row(
                children: [
                  SizedBox(
                    width: size.wScreen(35.0),

                    // color: Colors.blue,
                    child: Text('Mostrar Turnos:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.7),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  SizedBox(
                    width: size.wScreen(30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(
                              top: size.iScreen(0.5),
                              right: size.iScreen(0.5),
                            ),
                            child: Consumer<MultasGuardiasContrtoller>(
                              builder: (_, tipo, __) {
                                return (tipo.labelFaltas == '' ||
                                        tipo.labelFaltas == null)
                                    ? Text(
                                        'Seleccione',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    : Text(
                                        '${tipo.labelFaltas} ',
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                            _modalSeleccionaTipo(
                                context, size, multasControler);
                          }, child: Consumer<ThemeApp>(
                            builder: (_, valueTheme, __) {
                              return Container(
                                alignment: Alignment.center,
                                color: valueTheme.primaryColor,
                                width: size.iScreen(4.0),
                                //  height: size.iScreen(3.0),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.0),
                                  bottom: size.iScreen(0.0),
                                  left: size.iScreen(0),
                                  right: size.iScreen(0.0),
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(3.0),
                                ),
                              );
                            },
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              Container(
                color: Colors.grey.shade200,
                height: size.iScreen(0.3),
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(0.5),
              ),
              //*****************************************/
              Expanded(
                child: Consumer<MultasGuardiasContrtoller>(
                  builder: (_, providers, __) {
                
                    if (providers.faltasFiltrados == null) {
                      return Center(
                        // child: CircularProgressIndicator(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Cargando Datos...',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            //***********************************************/
                            SizedBox(
                              height: size.iScreen(1.0),
                            ),
                            //*****************************************/
                            const CircularProgressIndicator(),
                          ],
                        ),
                      );
                    } else if (providers.getErrorFaltasInjustificadas ==
                        false) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                    } else if (providers.faltasFiltrados.isEmpty) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                    } else if (providers.faltasFiltrados.isEmpty) {
                      return Center(
                        // child: CircularProgressIndicator(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Cargando Datos...',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            //***********************************************/
                            SizedBox(
                              height: size.iScreen(1.0),
                            ),
                            //*****************************************/
                            const CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }

                    return
                        //  //***********************************************/
                        Consumer<SocketService>(
                      builder: (_, valueEstadoInter, __) {
                        return valueEstadoInter.serverStatus ==
                                ServerStatus.Online
                            ? ListView.builder(
                                itemCount: multasControler
                                    .faltasFiltrados.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final multas = multasControler
                                      .faltasFiltrados[index];

                                  String fechaLocal =
                                      DateUtility.fechaLocalConvert(
                                          multas['nomFecha']!.toString());
                                  //============FECHA UTC=================//

                                  DateTime dateTime =
                                      DateTime.parse(fechaLocal);

                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(dateTime);

                                  // print(formattedDate); // Output: 2024-01-23

                                  //======================================//

                                  return Slidable(
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        // multas['nomEstado'] == 'EN PROCESO' &&
                                        //         multas['nomUser'] ==
                                        //             widget.user!.usuario
                                        //     ? SlidableAction(
                                        //         backgroundColor: Colors.purple,
                                        //         foregroundColor: Colors.white,
                                        //         icon: Icons.edit,
                                        //         label: 'Editar',
                                        //         onPressed: (context) {
                                        //           multasControler
                                        //               .resetValuesMulta();
                                        //           multasControler
                                        //               .getInfomacionMulta(multas);

                                        //           // ===================================================//
                                        //           showDialog(
                                        //               context: context,
                                        //               barrierDismissible: true,
                                        //               builder:
                                        //                   (BuildContext context) {
                                        //                 return Dialog(
                                        //                   shape:
                                        //                       RoundedRectangleBorder(
                                        //                           borderRadius:
                                        //                               BorderRadius
                                        //                                   .circular(
                                        //                                       20.0)),
                                        //                   child: Container(
                                        //                     constraints:
                                        //                         BoxConstraints(
                                        //                             maxHeight: size
                                        //                                 .wScreen(
                                        //                                     60.0)),
                                        //                     child: Padding(
                                        //                       padding:
                                        //                           EdgeInsets.all(
                                        //                               size.iScreen(
                                        //                                   3.0)),
                                        //                       child: Column(
                                        //                         mainAxisSize:
                                        //                             MainAxisSize
                                        //                                 .min,
                                        //                         crossAxisAlignment:
                                        //                             CrossAxisAlignment
                                        //                                 .start,
                                        //                         children: [
                                        //                           Text(
                                        //                               '¿Desea anular Multa?',
                                        //                               style: GoogleFonts
                                        //                                   .lexendDeca(
                                        //                                 fontSize: size
                                        //                                     .iScreen(
                                        //                                         2.0),
                                        //                                 fontWeight:
                                        //                                     FontWeight
                                        //                                         .bold,
                                        //                                 // color: Colors.white,
                                        //                               )),
                                        //                           SizedBox(
                                        //                             height: size
                                        //                                 .iScreen(
                                        //                                     2.0),
                                        //                           ),
                                        //                           ListTile(
                                        //                             tileColor:
                                        //                                 Colors.grey[
                                        //                                     200],
                                        //                             leading: const Icon(
                                        //                                 Icons
                                        //                                     .do_disturb_alt_outlined,
                                        //                                 color: Colors
                                        //                                     .red),
                                        //                             title: Text(
                                        //                               "ANULAR",
                                        //                               style: GoogleFonts
                                        //                                   .lexendDeca(
                                        //                                 fontSize: size
                                        //                                     .iScreen(
                                        //                                         2.0),
                                        //                                 fontWeight:
                                        //                                     FontWeight
                                        //                                         .bold,
                                        //                                 // color: Colors.white,
                                        //                               ),
                                        //                             ),
                                        //                             // trailing: const Icon(Icons.chevron_right_outlined),
                                        //                             onTap:
                                        //                                 () async {
                                        //                               providers
                                        //                                   .setLabelNombreEstadoMulta(
                                        //                                       'ANULADA');
                                        //                               providers
                                        //                                   .editarMultaGuardia(
                                        //                                       context);
                                        //                               Navigator.pop(
                                        //                                   context);
                                        //                               // _modalTerminosCondiciones(size, homeController);
                                        //                             },
                                        //                           )
                                        //                         ],
                                        //                       ),
                                        //                     ),
                                        //                   ),
                                        //                 );
                                        //               });

                                        //           //===================================================//
                                        //         },
                                        //       )
                                        //     : Container(),
                                        multas['nomEstado'] == 'EN PROCESO' &&
                                                multas['nomPorcentaje']
                                                        .toString() ==
                                                    '10' &&
                                                multas['idTurno'].toString() ==
                                                    ''
                                            ? SlidableAction(
                                                backgroundColor: tercearyColor,
                                                foregroundColor: Colors.white,
                                                icon: Icons.add,
                                                label: 'Turno',
                                                onPressed: multas[
                                                                'nomDetalle'] ==
                                                            'ABANDONO DE PUESTO' ||
                                                        multas['nomDetalle'] ==
                                                            'ESTADO ETILICO O ALIENTO A LICOR' ||
                                                        multas['nomDetalle'] ==
                                                            'FALTA INJUSTIFICADA'
                                                    ? (context) async {
                                                        // ===================================================//
                                                        final control =
                                                            context.read<
                                                                TurnoExtraController>();
                                                        final controlFecha =
                                                            context.read<
                                                                AusenciasController>();
                                                        control
                                                            .resetValuesTurnoExtra();
                                                        control.setIdMulta(
                                                            multas['nomId']
                                                                .toString());
                                                        // ===================================================//

                                                        await control
                                                            .buscaIdPersona(
                                                                multas['nomIdPer']
                                                                    .toString());
                                                        final fechaDeMulta =
                                                            multas['nomFecha']
                                                                .toString()
                                                                .substring(
                                                                    0, 10);
                                                        print(
                                                            'LA _fechaDeMulta :$fechaDeMulta');
                                                        Map<String, dynamic>
                                                            fecha = {};
                                                        Map<String, dynamic>
                                                            itemTurnoPuesto =
                                                            {};
                                                        if (control
                                                            .getListaIdPersona
                                                            .isNotEmpty) {
                                                          bool isFecha = false;
                                                          String labelFecha =
                                                              '';
                                                          fecha = {};
                                                          itemTurnoPuesto = {};
                                                          for (var itemTurno
                                                              in control
                                                                      .getListaIdPersona[
                                                                  'perTurno']) {
                                                            // print('LA DATA ITEM :$itemTurno');
                                                            for (var item
                                                                in itemTurno[
                                                                    'fechasConsultaDB']) {
                                                              //  print(' $_fechaDeMulta ==> DESDE :${item['desde']} - HASTA :${item['hasta']}');
                                                              if (item['desde']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10) ==
                                                                  fechaDeMulta) {
                                                                labelFecha =
                                                                    item[
                                                                        'desde'];
                                                                isFecha = true;
                                                                print(
                                                                    ' $fechaDeMulta ==> DESDE :${item['desde'].toString().substring(0, 10)} - HASTA :${item['hasta'].toString().substring(0, 10)}');
                                                                fecha = {};
                                                                fecha = {
                                                                  "desde":
                                                                      "${item['desde']}",
                                                                  "hasta":
                                                                      "${item['hasta']}",
                                                                  // "id": "${item['id']}",
                                                                  // "isSelect":false
                                                                };

                                                                itemTurnoPuesto =
                                                                    {
                                                                  "id": itemTurno[
                                                                          'id']
                                                                      .toString(),
                                                                  "idCliente":
                                                                      itemTurno[
                                                                          'idClienteIngreso'],
                                                                  "ruccliente":
                                                                      itemTurno[
                                                                          'docClienteIngreso'],
                                                                  "razonsocial":
                                                                      itemTurno[
                                                                          'clienteIngreso'],
                                                                  "ubicacion":
                                                                      itemTurno[
                                                                          'clienteUbicacionIngreso'],
                                                                  "puesto":
                                                                      itemTurno[
                                                                          'puestoIngreso']
                                                                };
                                                                // //                         "nomIdPer": 1029,
                                                                // "nomDocuPer": "2300246820",
                                                                // "nomNombrePer": "ZAMBRANO MACAS MARIA CRISTINA",

                                                                // final _infoGuardia={

                                                                //       	"turIdPersona": multas['nomIdPer'],
                                                                // "turDocuPersona": multas['nomDocuPer'],
                                                                // "turNomPersona": multas['nomNombrePer'],

                                                                // };

                                                                //  _control.setInfoGuardiaVerificaTurno(_infoGuardia);

                                                                // ====== TOMO LOS DATOS DEL GUARDIA MULTADO =======//
                                                                // _control. setIdGuardia( multas['nomIdPer']) ;
                                                                // _control. setDocuGuardia(multas['nomDocuPer']) ;
                                                                //        _control. setNombreGuardia(multas['nomNombrePer']) ;

                                                                // =================================================//

                                                                break;
                                                              }
                                                              //     else{
                                                              //       _isFecha=false;
                                                              //         _labelFecha=_fechaDeMulta;
                                                              //     //  print('NO EXISTE FECHA: $_labelFecha');

                                                              //  }
                                                            }
                                                          }
                                                          if (isFecha == true) {
                                                            print(
                                                                'DATA $itemTurnoPuesto ');
                                                            controlFecha
                                                                .setFechaValida(
                                                                    fecha);
                                                            // ===================================================//

                                                            //  _control.resetValuesTurnoExtra();
                                                            control
                                                                .buscaLstaDataJefeOperaciones(
                                                                    '');

                                                            control.setIdCliente(int.parse(
                                                                itemTurnoPuesto[
                                                                        'idCliente']
                                                                    .toString()));
                                                            control.setCedulaCliente(
                                                                itemTurnoPuesto[
                                                                    'ruccliente']);
                                                            control.setNombreCliente(
                                                                itemTurnoPuesto[
                                                                    'razonsocial']);
                                                            control.setLabelINuevoPuesto(
                                                                itemTurnoPuesto[
                                                                    'puesto']);
                                                            control.setLabelMotivoTurnoExtra(
                                                                multas[
                                                                    'nomDetalle']);
                                                            control.setListTurPuesto(
                                                                itemTurnoPuesto);
                                                            control
                                                                .onNumeroDiasChange(
                                                                    '1');

                                                            //===================================================//
                                                            // NotificatiosnService.showSnackBarDanger('SI EXISTE FECHA $_labelFecha');
                                                            // Navigator.pushNamed( context, 'creaTurnoExtra',arguments: 'EXTRA');
                                                            // _isFecha==false;
                                                            // ===================================================//

                                                            _modalCrearTurno(
                                                                size);

                                                            // ===================================================//
                                                          } else {
                                                            // NotificatiosnService.showSnackBarError('NO PUEDE CREAR TURNO PARA ESTA FECHA $_fechaDeMulta');
                                                            NotificatiosnService
                                                                .showSnackBarError(
                                                                    'NO PUEDE CREAR TURNO EL DIA DE HOY');
                                                          }
                                                        }

                                                        //===================================================//
                                                      }
                                                    : null,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        final control = context
                                            .read<MultasGuardiasContrtoller>();
                                        final controll =
                                            context.read<AusenciasController>();

                                        control.setInfoFalta(multas);
                                        // _control.buscaListaGuardiasReemplazo([multas['idTurno'].toString()]);
                                        controll.resetValuesAusencias();
                                        controll.buscaListaGuardiasReemplazo(
                                            [multas['idTurno'].toString()]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    DetalleFaltaInjustificada(
                                                      user: user,
                                                    ))));
                                      },
                                      child: ClipRRect(
                                        child: Card(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: size.iScreen(0.5)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.iScreen(1.0),
                                                vertical: size.iScreen(0.5)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: const <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.black54,
                                                    blurRadius: 1.0,
                                                    offset: Offset(0.0, 1.0))
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        // color: Colors.red,
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        width:
                                                            size.wScreen(100.0),
                                                        child: Text(
                                                          '${multas['nomNombrePer']}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.8),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              'Motivo:',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            // color: Colors.red,
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            width: size
                                                                .wScreen(50.0),
                                                            child: Text(
                                                              '${multas['nomDetalle']}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              'Multa: ',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              '${multas['nomPorcentaje']} %',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              'Asignado por: ',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              ' ${multas['nomUser'].toString().toUpperCase()}',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              'Fecha: ',
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            // width: size.wScreen(100.0),
                                                            child: Text(
                                                              //   multas['nomFecReg']!
                                                              //       // .toLocal()
                                                              //       .toString()
                                                              //       .replaceAll(
                                                              //           ".000Z", "")
                                                              //       .replaceAll(
                                                              //           ".000", "")
                                                              //       .replaceAll(
                                                              //           "T", " "),
                                                              // // child: Text(
                                                              // //   _fechaUTC,
                                                              formattedDate,
                                                              style: GoogleFonts.lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Estado',
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.6),
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    Text(
                                                      '${multas['nomEstado']}',
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.6),
                                                              color: multas[
                                                                          'nomEstado'] ==
                                                                      'APELACION'
                                                                  ? secondaryColor
                                                                  : multas['nomEstado'] ==
                                                                          'EN PROCESO'
                                                                      ? tercearyColor
                                                                      : multas['nomEstado'] ==
                                                                              'ANULADA'
                                                                          ? Colors
                                                                              .red
                                                                          : multas['nomEstado'] ==
                                                                                  'ASIGNADA'
                                                                              ? primaryColor
                                                                              : Colors
                                                                                  .grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                  //   },
                                  // );
                                })
                            : const NoData(label: 'Sin conexión a internet');
                      },
                    );
                    //  //***********************************************/
                  },
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton:
        //     //  //***********************************************/
        //     Consumer<SocketService>(
        //   builder: (_, valueEstadoInter, __) {
        //     return valueEstadoInter.serverStatus == ServerStatus.Online
        //         ? widget.user!.rol!.contains('SUPERVISOR')
        //             ? FloatingActionButton(
        //                 // backgroundColor: primaryColor,
        //                 child: const Icon(Icons.add),
        //                 onPressed: () {
        //                   multasControler.getTodoosLosTiposDeMultasGuardia();
        //                   // Navigator.pushNamed(context, 'tipoMultasGuardias');
        //                   Navigator.pushNamed(context, 'multas',
        //                       arguments: 'NUEVO',);
        //                 },
        //               )
        //             : Container()
        //         : Container();
        //   },
        // ),
        //  //***********************************************/
      ),
    );
  }

  //======================= ACTUALIZA LA PANTALLA============================//
  Future onRefresh(BuildContext context) async {
    final controls = context.read<MultasGuardiasContrtoller>();
    controls.getTodasLasFaltasInjustificadas('');
  }
  //===================================================//

  //====== MUESTRA MODAL DE MOTIVO =======//
  void _modalSeleccionaTipo(
      BuildContext context, size, MultasGuardiasContrtoller actividades) {
    final data = [
      'Diurno',
      'Nocturno',
    ];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('MOSTRAR FALTAS POR TURNO',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            )),
                      ),
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
                  SizedBox(
                    width: size.wScreen(100.0),
                    height: size.hScreen(15.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            actividades.setLabelFaltas(data[index]);
                            onRefresh(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.grey[100],
                            margin: EdgeInsets.symmetric(
                                vertical: size.iScreen(0.3)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(1.0),
                                vertical: size.iScreen(1.0)),
                            child: Text(
                              data[index],
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  //======================= ACTUALIZA LA PANTALLA============================//
  // Future<void> _onRefresLista() async {
  //   final controllerMulta =
  //       Provider.of<MultasGuardiasContrtoller>(context, listen: false);
  //   controllerMulta.getTodasLasMultasGuardia('', '');
  // }
  //===================================================//

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalEstadoMulta(
      Responsive size,
      MultasGuardiasContrtoller multasControler,
      Result? multa,
      String? estado) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aviso',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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
                  Text('Seguro de cambiar el estado de esta multa ?',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        // color: Colors.white,
                      )),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Ingrese motivo de anulación:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(),
                    onChanged: (text) {
                      multasControler.onInputAnulacionDeMultaChange(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese motivo de desacitvación';
                      }
                    },
                    onSaved: (value) {},
                  ),
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(1.0), bottom: size.iScreen(2.0)),
                    height: size.iScreen(3.5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color(0xFF0A4280),
                        ),
                      ),
                      onPressed: () async {
                        ProgressDialog.show(context);
                        await multasControler.actualizaEstadoMulta(
                            context, multa!);

                        ProgressDialog.dissmiss(context);
                        Navigator.pop(context);
                      },
                      child: Text('Si',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//========ALERTA ESTADO  CAMBIO DE PUESTO========//
  void _showAlertEditarEstadoMulta(
      Responsive size, MultasGuardiasContrtoller controller) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return CupertinoAlertDialog(
            title: const Text("Estado del Pedido"),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //*****************************************/

                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //==========================================//
                  GestureDetector(
                    child: Container(
                      width: size.wScreen(100.0),
                      padding:
                          EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                      color: Colors.grey.shade400,
                      child: Text(
                        "ANULAR",
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () async {
                      controller.setLabelNombreEstadoMulta('ANULADO');
                      Navigator.pop(context);
                    },
                  ),
                  //*****************************************/

                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  SizedBox(
                    height: size.iScreen(2.0),
                  )
                ],
              ),
            ),
          );
        });
  }

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalCrearTurno(
    Responsive size,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
                content: Consumer<TurnoExtraController>(
                  builder: (_, valueGuardia, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text('',
                            //     style: GoogleFonts.lexendDeca(
                            //       fontSize: size.iScreen(2.0),
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.red,
                            //     )),

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
                        valueGuardia.getListaIdPersona.isEmpty
                            ? Text('Cargando Información ....',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.7),
                                  fontWeight: FontWeight.normal,
                                  // color: Colors.white,
                                ))
                            : Column(
                                children: [
                                  Text('Desea crear turno ?',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.7),
                                        fontWeight: FontWeight.normal,
                                        // color: Colors.white,
                                      )),
                                  //*****************************************/
                                  SizedBox(
                                    height: size.iScreen(1.0),
                                  ),

                                  //*****************************************/

                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.iScreen(1.0),
                                        bottom: size.iScreen(2.0)),
                                    height: size.iScreen(3.5),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          const Color(0xFF0A4280),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // ProgressDialog.show(context);
                                        // await multasControler.actualizaEstadoMulta(
                                        //     context, multa!);

                                        // ProgressDialog.dissmiss(context);
                                        //  print('la data es:${valueGuardia.getListaIdPersona}');
                                        Navigator.pop(context);

                                        Navigator.pushNamed(
                                            context, 'creaTurnoExtra',
                                            arguments: 'FALTAS');

// valueGuardia.resetInfoGuardiaturno();
                                      },
                                      child: Text('Si',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.8),
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    );
                    // :Navigator.pop(context);
                  },
                )),
          );
        });
  }
}
