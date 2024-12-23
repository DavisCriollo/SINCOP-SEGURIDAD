import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/new_permisos_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/crea_nuevo_permiso.dart';
import 'package:nseguridad/src/pages/detalle_nuevo_permiso.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaNuevosPermisos extends StatefulWidget {
  const ListaNuevosPermisos({super.key});

  @override
  State<ListaNuevosPermisos> createState() => _ListaNuevosPermisosState();
}

class _ListaNuevosPermisosState extends State<ListaNuevosPermisos> {
  final TextEditingController _textSearchController = TextEditingController();

  @override
  void dispose() {
    _textSearchController.clear();
    super.dispose();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadInfo =
        Provider.of<NuevoPermisoController>(context, listen: false);
    loadInfo.buscaNuevosPermisos('', 'false');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      // print('======================> data socket TURNO  :$data');
      if (data['tabla'] == 'permiso') {
        loadInfo.buscaNuevosPermisos('', 'false');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'permiso') {
        loadInfo.buscaNuevosPermisos('', 'false');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });

    serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'permiso') {
        loadInfo.buscaNuevosPermisos('', 'false');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final Session usuario =
        ModalRoute.of(context)!.settings.arguments as Session;
    final user = context.read<HomeController>();
    final ctrlTheme = context.read<ThemeApp>();

    return SafeArea(
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
              title: Consumer<NuevoPermisoController>(
                builder: (_, providerSearch, __) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.iScreen(0.1)),
                          child: (providerSearch.btnSearch)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.iScreen(1.5)),
                                          color: Colors.white,
                                          height: size.iScreen(4.0),
                                          child: TextField(
                                            controller: _textSearchController,
                                            autofocus: true,
                                            onChanged: (text) {
                                              providerSearch.onSearchText(text);
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
                                                  width: 0.0,
                                                  color: Colors.grey),
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
                                    'Permisos',
                                    // style:Theme.of(context).textTheme.headline2,
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
                            providerSearch
                                .setBtnSearch(!providerSearch.btnSearch);
                            _textSearchController.text = "";
                            providerSearch.buscaNuevosPermisos('', 'false');
                          }),
                    ],
                  );
                },
              ),
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: size.iScreen(2.0),
                    left: size.iScreen(0.0),
                    right: size.iScreen(0.0),
                  ),
                  width: size.wScreen(100.0),
                  height: size.hScreen(100.0),
                  child: Consumer<NuevoPermisoController>(
                      builder: (_, provider, __) {
                    if (provider.getErrorPermisos == null) {
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
                    } else if (provider.getErrorPermisos == false) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                    } else if (provider.getListaPermisos.isEmpty) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: onRefresh,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.getListaPermisos.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ausencia = provider.getListaPermisos[index];
                          // print('el usuario:${ausencia['ausUser']}');
                          return Slidable(
                            startActionPane: const ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                // _usuario!.usuario == ausencia['ausUser']
                                //     ? SlidableAction(
                                //         backgroundColor: Colors.purple,
                                //         foregroundColor: Colors.white,
                                //         icon: Icons.edit,
                                //         // label: 'Editar',
                                //         onPressed: (context) {
                                //          final List<String>_ids=[];
                                //          for (var item in  ausencia['idTurno']) {
                                //           _ids.addAll([item.toString()]);
                                //          }
                                //           provider.resetDropDown();
                                //           provider.resetValuesAusencias();
                                //           provider.buscaListaGuardiasReemplazo(_ids);

                                //           provider.getDataAusencia(ausencia);

                                //           Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                   builder: ((context) => CreaAusencia(
                                //                         usuario: _usuario,
                                //                         action: 'EDIT',
                                //                       ))));
                                //         },
                                //       )
                                //     : Container(),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                provider.resetVariablePermisos();
                                final List<String> ids = [];
                                for (var item
                                    in ausencia['permiIdsTurnoExtra']) {
                                  ids.addAll([item.toString()]);
                                }

                                provider.buscaListaGuardiasReemplazo(ids);
                                provider.getDataAusencia(ausencia);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const DetalleNuevoPermiso())));
                              },
                              child: ClipRRect(
                                child: Card(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: size.iScreen(0.5)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.iScreen(1.0),
                                        vertical: size.iScreen(0.5)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: size.iScreen(0.5),
                                                        bottom:
                                                            size.iScreen(0.0)),
                                                    // width: size.wScreen(100.0),
                                                    child: Text(
                                                      'Motivo: ',
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
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
                                                        top: size.iScreen(0.5),
                                                        bottom:
                                                            size.iScreen(0.0)),
                                                    width: size.wScreen(55.0),
                                                    child: Text(
                                                      '${ausencia['permiMotivo']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
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
                                                        top: size.iScreen(0.5),
                                                        bottom:
                                                            size.iScreen(0.0)),
                                                    // width: size.wScreen(100.0),
                                                    child: Text(
                                                      'Guardia: ',
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: size.iScreen(31.0),
                                                      // color: Colors.red,
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              size.iScreen(0.5),
                                                          bottom: size
                                                              .iScreen(0.0)),

                                                      child: Text(
                                                        ' ${ausencia['nombres']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts
                                                            .lexendDeca(
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
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           top: size.iScreen(0.5),
                                              //           bottom: size.iScreen(0.0)),
                                              //       // width: size.wScreen(100.0),
                                              //       child: Text(
                                              //         'Fecha desde: ',
                                              //         style: GoogleFonts.lexendDeca(
                                              //             fontSize: size.iScreen(1.5),
                                              //             color: Colors.black87,
                                              //             fontWeight:
                                              //                 FontWeight.normal),
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           top: size.iScreen(0.5),
                                              //           bottom: size.iScreen(0.0)),
                                              //       // width: size.wScreen(100.0),
                                              //       child: Text(
                                              //         ausencia['ausFechaDesde']
                                              //             .toString()
                                              //             .replaceAll("T", " "),
                                              //         style: GoogleFonts.lexendDeca(
                                              //             fontSize: size.iScreen(1.5),
                                              //             color: Colors.black87,
                                              //             fontWeight:
                                              //                 FontWeight.bold),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           top: size.iScreen(0.5),
                                              //           bottom: size.iScreen(0.0)),
                                              //       // width: size.wScreen(100.0),
                                              //       child: Text(
                                              //         'Fecha hasta: ',
                                              //         style: GoogleFonts.lexendDeca(
                                              //             fontSize: size.iScreen(1.5),
                                              //             color: Colors.black87,
                                              //             fontWeight:
                                              //                 FontWeight.normal),
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           top: size.iScreen(0.5),
                                              //           bottom: size.iScreen(0.0)),
                                              //       // width: size.wScreen(100.0),
                                              //       child: Text(
                                              //         ausencia['ausFechaHasta']
                                              //             .toString()
                                              //             .replaceAll("T", " "),
                                              //         style: GoogleFonts.lexendDeca(
                                              //             fontSize: size.iScreen(1.5),
                                              //             color: Colors.black87,
                                              //             fontWeight:
                                              //                 FontWeight.bold),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              Row(
                                                children: [
                                                  Container(
                                                    // width: size.iScreen(10.0),
                                                    margin: EdgeInsets.only(
                                                        top: size.iScreen(0.5),
                                                        bottom:
                                                            size.iScreen(0.0)),
                                                    // width: size.wScreen(100.0),
                                                    child: Text(
                                                      'Días de permiso: ',
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.5),
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: size.iScreen(10.0),
                                                    // color: Colors.red,
                                                    margin: EdgeInsets.only(
                                                        top: size.iScreen(0.5),
                                                        bottom:
                                                            size.iScreen(0.0)),

                                                    child: Text(
                                                      ' ${ausencia['dias'].length}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.6),
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.6),
                                                  color: Colors.black87,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              '${ausencia['permiEstado']}',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.6),
                                                  color:
                                                      tercearyColor, //_colorEstado,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                      width: size.wScreen(100.0),
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${user.getUsuarioInfo!.rucempresa!}  ',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold)),
                          Text('-',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Text('  ${user.getUsuarioInfo!.usuario!} ',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                )
              ],
            ),
            floatingActionButton: usuario.rol!.contains('SUPERVISOR') ||
                    usuario.rol!.contains('GUARDIA') ||
                    usuario.rol!.contains('ADMINISTRACION')
                ? FloatingActionButton(
                    // backgroundColor: primaryColor,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      final ausenciaController =
                          Provider.of<NuevoPermisoController>(context,
                              listen: false);
                      // final turnoExtraController =
                      //     Provider.of<TurnoExtraController>(context,
                      //             listen: false)
                      //         .resetValuesTurnoExtra();
                      // ausenciaController.resetValuesAusencias();
                      //  ausenciaController.onInputFechaInicioChange('');

                      ausenciaController.setUsuarioLogin(usuario);

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: ((context) => CreaAusencia(
                      //               usuario: _usuario,
                      //               action: 'CREATE',
                      //             ))));

                      // Navigator.pushNamed(context, 'creaAusencia',
                      //     arguments: 'CREATE');
                      ausenciaController.resetVariablePermisos();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CreaNuevoPermiso(
                                    usuario: usuario,
                                    action: 'CREATE',
                                  ))));
                    },
                  )
                : Container()),
      ),
    );
  }

  //======================= ACTUALIZA LA PANTALLA============================//
  Future<void> onRefresh() async {
    final loadInfo = context.read<NuevoPermisoController>();
    loadInfo.buscaNuevosPermisos('', 'false');
  }
  //===================================================//
}
