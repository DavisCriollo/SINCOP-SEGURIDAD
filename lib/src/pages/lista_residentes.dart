import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/residentes_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/crea_nuevo_residente.dart';
import 'package:nseguridad/src/pages/crea_residente.dart';
// import 'package:nseguridad/src/pages/crea_residente.dart';
import 'package:nseguridad/src/pages/detalle_residente.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaResidentes extends StatefulWidget {
  final Session? user;
  const ListaResidentes({super.key, this.user});

  @override
  State<ListaResidentes> createState() => _ListaResidentesState();
}

class _ListaResidentesState extends State<ListaResidentes> {
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
    final loadInfo = Provider.of<ResidentesController>(context, listen: false);
    // if (widget.user!.rol!.contains('CLIENTE')) {
    //   loadInfo.getTodosLosResidentes('', 'false');
    // }
    // if (widget.user!.rol!.contains('GUARDIA')) {
    //   loadInfo.getTodosLosResidentesGuardia('', 'false');
    // }

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'residente') {
        if (widget.user!.rol!.contains('CLIENTE')) {
          loadInfo.getTodosLosResidentes('', 'false');
        }
        if (widget.user!.rol!.contains('GUARDIA')) {
          loadInfo.getTodosLosResidentesGuardia('', 'false');
        }
      }
    });
    // serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
    //   if (data['tabla'] == 'residente') {
    //     if (widget.user!.rol!.contains('CLIENTE')) {
    //       loadInfo.getTodosLosResidentes('', 'false');
    //     }
    //     if (widget.user!.rol!.contains('GUARDIA')) {
    //       loadInfo.getTodosLosResidentesGuardia('', 'false');
    //     }

    //     NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });
    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'residente') {
    //     if (widget.user!.rol!.contains('CLIENTE')) {
    //       loadInfo.getTodosLosResidentes('', 'false');
    //     }
    //     if (widget.user!.rol!.contains('GUARDIA')) {
    //       loadInfo.getTodosLosResidentesGuardia('', 'false');
    //     }

    //     NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //   }
    // });



  void initData() async {
    final loadInfo =
        Provider.of<ResidentesController>(context, listen: false);
    // loadInfo.getTodasLasMultasGuardia('', 'false');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket?.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'bitacora') {

        // loadInfo.getTodasLasMultasGuardia('', 'false');
          loadInfo.getTodosLosResidentesGuardia('', 'false');
                       loadInfo.setListFilter(loadInfo.getListaTodosLosResidentes);
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket?.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'bitacora') {
        // loadInfo.getTodasLasMultasGuardia('', 'false');
         loadInfo.getTodosLosResidentesGuardia('', 'false');
                       loadInfo.setListFilter(loadInfo.getListaTodosLosResidentes);
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
  }


  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final user = context.read<HomeController>();
    final ctrlTheme = context.read<ThemeApp>();
    return Scaffold(
      // backgroundColor: const Color(0xffF2F2F2),
      backgroundColor: Colors.grey.shade200,
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
        // title: Text(
        //   'Residentes',
        //   // style: Theme.of(context).textTheme.headline2,
        // ),
        title: Consumer<ResidentesController>(
          builder: (_, provider, __) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                    child: (provider.btnSearch)
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
                                        // _controller.onSearchText(text);
                                        provider.search(text);
    
                                        //  provider.search(text);
                                        // setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        // icon: Icon(Icons.search),
                                        border: InputBorder.none,
                                        hintText: 'Buscar persona',
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
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
                                        color: primaryColor),
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
                              'Lista Residentes',
                              // style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                  ),
                ),
                IconButton(
                    splashRadius: 2.0,
                    icon: (!provider.btnSearch)
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
                      provider.setBtnSearch(!provider.btnSearch);
                      _textSearchController.text = "";
                      // provider.getTodosLosComunicadosClientes('');
                    }),
              ],
            );
          },
        ),
        actions: const [],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.iScreen(0.5),
            ),
            padding: EdgeInsets.only(
              top: size.iScreen(2.0),
              left: size.iScreen(0.0),
              right: size.iScreen(0.0),
            ),
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            child:
            
             Consumer<ResidentesController>(
              builder: (_, provider, __) {
                if (provider.getErrorTodosLosResidentes == null) {
                  return Center(
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
                } else if (provider.filteredList.isEmpty) {
                  return const NoData(
                    label: 'No existen datos para mostar',
                  );
                }
    
                return Consumer<ResidentesController>(
                  builder: (_, valueResidente, __) {
                    return 
                     (valueResidente.filteredList.isEmpty)
                                        ? const Center(
                                            child: Column(
                                            children: [
                                              CircularProgressIndicator(),
                                              Text('No hay resultados ....')
                                            ],
                                          ))
                                        : (valueResidente.filteredList.isNotEmpty)
                                            ?
                                            RefreshIndicator(
                                              onRefresh: _onRefresh,
                                              child: ListView.builder(
                                                itemCount: valueResidente.filteredList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                   final residente=valueResidente.filteredList[index];
                                                  return  
                                                  
                                                 
                                                  itemResidente(provider, residente, context, size);
                                                },
                                              ),
                                            ):const NoData(
                                                label: 'No existe el Cliente',
                                              );
                        
                        
                  },
                );
                //  //***********************************************/
              },
            ),
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
          ),
        ],
      ),
      // floatingActionButton:
      //     //  //***********************************************/
      //     Consumer<SocketService>(
      //   builder: (_, valueEstadoInter, __) {
      //     return valueEstadoInter.serverStatus == ServerStatus.Online
      //         ? FloatingActionButton(
      //             backgroundColor:  ctrlTheme.primaryColor,
      //             child: const Icon(Icons.add),
      //             onPressed: () {
      //               final _controller = context.read<ResidentesController>();
      //               _controller.resetValuesResidentes();
    
      //               if(widget.user!.rol!.contains('CLIENTE')){
      //                    _controller.getInfoClientePorId();
      //               }
    
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       // builder: ((context) => const RegitroBiracora(
      //                       builder: ((context) => CrearResidente(
      //                             user: widget.user,
      //                             action: 'CREATE',
      //                           ))));
      //             },
      //           )
      //         : Container();
      //   },
      // ),
      // floatingActionButton:
      // FloatingActionButton(
      //             backgroundColor:  ctrlTheme.primaryColor,
      //             child: const Icon(Icons.add),
      //             onPressed: () {
    
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       // builder: ((context) => const RegitroBiracora(
      //                       builder: ((context) => CrearBitaora(
      //                             user: widget.user,
      //                             action: 'CREATE',
      //                           ))));
      //             },
      //           )




 
 
//  FloatingActionButton(
//               backgroundColor: ctrlTheme.primaryColor,
//               // backgroundColor: primaryColor,
//               child: const Icon(Icons.add),
//               onPressed: () {
//                 // informeController.resetValuesInformes();

//                 // final user = context.read<HomeController>();

//                 // // informeController.setUsuario(widget.usuario!);
//                 // informeController.setUsuario(user.getUsuarioInfo);
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: ((context) => const CrearInformeGuardiaPage(
//                 //             // usuario: widget.usuario!
//                 //             ))));
//               },
//             )
   floatingActionButton:
          //  //***********************************************/
        FloatingActionButton(
                  backgroundColor:  ctrlTheme.primaryColor,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    final _controller = context.read<ResidentesController>();
                    _controller.resetValuesResidentes();
    
                    if(widget.user!.rol!.contains('CLIENTE')){
                         _controller.getInfoClientePorId();
                    }
    
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         // builder: ((context) => const RegitroBiracora(
                    //         builder: ((context) => CrearResidente(
                    //               user: widget.user,
                    //               action: 'CREATE',
                    //             ))));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: ((context) => const RegitroBiracora(
                            builder: ((context) => CreaNuevoResidente(
                                  user: widget.user,
                                  action: 'CREATE',
                                ))));
                  },
                )
             
      

    );
  }

  GestureDetector itemResidente(ResidentesController provider, residente, BuildContext context, Responsive size) {
    return 
    GestureDetector(
                                onTap: () {
                                  provider.setInfoResidente(residente);
                                  provider.getTodasLasVisitasDelResidente();

                                  // context.read<BitacoraController>().getAllVisitasBitacoras('', 'false','INGRESO'); 

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          // builder: ((context) => const RegitroBiracora(
                                          builder: ((context) =>
                                              DetalleResidente(
                                                user: widget.user,
                                              ))));

                                  //********************************//
                                },
                                child: 
                                Slidable(
                                startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                children: [
                                  widget.user!.usuario == residente['resUser']
                                      ? SlidableAction(
                                          backgroundColor: Colors.purple,
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          // label: 'Editar',
                                          onPressed: (context) {
                                            // loadData;
                                            // provider.resetValuesInformes();
                                            // // provider.getDataInformeGuardia(informe);
                                            // provider.getDataInformes(informe);
                                            // provider.setUsuario(widget.usuario);

                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: ((context) =>
                                            //             EditaInformeGuardiaPage(
                                            //                 usuario:
                                            //                     widget.usuario!,
                                            //                 informe: provider
                                            //                             .getListaInformesInforme[
                                            //                         index]
                                            //                     ['infGuardias'],
                                            //                 fecha: informe[
                                            //                     'infFechaSuceso']))));

                                             final _controller = context.read<ResidentesController>();
                    _controller.resetValuesResidentes();
    
                    if(widget.user!.rol!.contains('CLIENTE')){
                         _controller.getInfoClientePorId();
                    }
                                _controller.getDataInfoResidente(residente);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         // builder: ((context) => const RegitroBiracora(
                    //         builder: ((context) => CrearResidente(
                    //               user: widget.user,
                    //               action: 'CREATE',
                    //             ))));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: ((context) => const RegitroBiracora(
                            builder: ((context) => CreaNuevoResidente(
                                  user: widget.user,
                                  action: 'EDIT',
                                ))));
                                          },
                                        )
                                      : const SizedBox(),
                                  // SlidableAction(
                                  //   onPressed: (context) async {
                                  //     await provider.eliminaInformeGuardia(
                                  //         context, informe['infId']);
                                  //   },
                                  //   backgroundColor: Colors.red.shade700,
                                  //   foregroundColor: Colors.white,
                                  //   icon: Icons.delete_forever_outlined,
                                  //   // label: 'Eliminar',
                                  // ),
                                ],
                              ),


                                  child:
                                   ClipRRect(
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
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                        vertical:
                                                            size.iScreen(0.5),
                                                        horizontal:
                                                            size.iScreen(0.5),
                                                      ),
                                                      color: Colors
                                                          .grey.shade100,
                                                      width:
                                                          size.wScreen(100.0),
                                                      child: Text(
                                                        'PROPIETARIO ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
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
                                                            'Documento:',
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
                                                        Expanded(
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            child: Text(
                                                              residente['resCedulaPropietario'] !=
                                                                      null
                                                                  ? ' ${residente['resCedulaPropietario']}'
                                                                  : 
                                                                  ' --- --- --- --- ---',
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
                                                            'Nombre:',
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
                                                        Expanded(
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            child: Text(
                                                               residente['resApellidoPropietario'] != null ? ' ${residente['resApellidoPropietario']}' : residente['resNombrePropietario'] !=
                                                                      null ? ' ${residente['resNombrePropietario']}' : ' --- --- --- --- ---',
                                                                
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
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                //****************//
                                                SizedBox(
                                                  height: size.iScreen(0.5),
                                                ),
                                                //***************//
                                                Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                        vertical:
                                                            size.iScreen(0.5),
                                                        horizontal:
                                                            size.iScreen(0.5),
                                                      ),
                                                      color: Colors
                                                          .grey.shade100,
                                                      width:
                                                          size.wScreen(100.0),
                                                      child: Text(
                                                        'ARRENDATARIO ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
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
                                                            'Documento:',
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
                                                        Expanded(
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            child: Text( 
                                                            residente['resTipoResidente'] ==
                                                                      'ARRENDATARIO'
                                                                  ? ' ${residente['resCedula']}'
                                                                  : ' --- --- --- --- ---',
                                                              // residente['resCedula'] !=
                                                              //         null
                                                              //     ? ' ${residente['resCedula']}'
                                                              //     : 
                                                              //     ' --- --- --- --- ---',
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
                                                            'Nombre:',
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
                                                        Expanded(
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),
                                                            child: Text(
                                                                         residente['resTipoResidente'] ==
                                                                      'ARRENDATARIO'
                                                                  ? ' ${residente['resApellidos']} ${residente['resNombres']}'
                                                                  : ' --- --- --- --- ---',

                                                              //  residente['resApellidos'] != null ? ' ${residente['resApellidos']}' : residente['resNombres'] !=
                                                              //         null ? ' ${residente['resNombres']}' : ' --- --- --- --- ---',
                                                              
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
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                //****************//
                                                SizedBox(
                                                  height: size.iScreen(0.5),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          size.wScreen(100.0),
                                                      height:
                                                          size.iScreen(0.5),
                                                      color: Colors
                                                          .grey.shade100,
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
                                                            'Departamento : ',
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
                                                        Expanded(
                                                          child: Container(
                                                            // width: size.iScreen(28.0),
                                                            // color: Colors.red,
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),

                                                            child: Text(
                                                            
                                                             residente['resDepartamento'].isNotEmpty?' ${residente['resDepartamento'][0]['nombre_dpt']}':'--- --- --- ',
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
                                                            'Número : ',
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
                                                        Expanded(
                                                          child: Container(
                                                            // width: size.iScreen(28.0),
                                                            // color: Colors.red,
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),

                                                            child: Text(
                                                             
                                                              residente['resDepartamento'].isNotEmpty?' ${residente['resDepartamento'][0]['numero']}':'--- --- --- ',
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
                                                            'Ubicación : ',
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
                                                        Expanded(
                                                          child: Container(
                                                            // width: size.iScreen(28.0),
                                                            // color: Colors.red,
                                                            margin: EdgeInsets.only(
                                                                top: size
                                                                    .iScreen(
                                                                        0.5),
                                                                bottom: size
                                                                    .iScreen(
                                                                        0.0)),

                                                            child: Text(
                                                             
                                                              residente['resDepartamento'].isNotEmpty?' ${residente['resDepartamento'][0]['ubicacion']}':'--- --- --- ',
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
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: size.iScreen(0.5),
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Container(
                                                //       margin: EdgeInsets.only(
                                                //           top: size
                                                //               .iScreen(0.5),
                                                //           bottom: size
                                                //               .iScreen(0.0)),
                                                //       // width: size.wScreen(100.0),
                                                //       child: Text(
                                                //         'Departamento: ',
                                                //         style: GoogleFonts
                                                //             .lexendDeca(
                                                //                 fontSize: size
                                                //                     .iScreen(
                                                //                         1.5),
                                                //                 color: Colors
                                                //                     .black87,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .normal),
                                                //       ),
                                                //     ),
                                                //     Container(
                                                //       // width: size.iScreen(28.0),
                                                //       // color: Colors.red,
                                                //       margin: EdgeInsets.only(
                                                //           top: size
                                                //               .iScreen(0.5),
                                                //           bottom: size
                                                //               .iScreen(0.0)),

                                                //       child: Text(
                                                //         '${residente['resDepartamento']}',
                                                //         overflow: TextOverflow
                                                //             .ellipsis,
                                                //         style: GoogleFonts
                                                //             .lexendDeca(
                                                //                 fontSize: size
                                                //                     .iScreen(
                                                //                         1.5),
                                                //                 color: Colors
                                                //                     .black87,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .bold),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                          // Column(
                                          //   children: [
                                          //     Text(
                                          //       'Estado',
                                          //       style: GoogleFonts.lexendDeca(
                                          //           fontSize:
                                          //               size.iScreen(1.6),
                                          //           color: Colors.black87,
                                          //           fontWeight:
                                          //               FontWeight.normal),
                                          //     ),
                                          //     Text(
                                          //       '${residente['resEstado']}',
                                          //       style: GoogleFonts.lexendDeca(
                                          //           fontSize:
                                          //               size.iScreen(1.6),
                                          //           // color: _colorEstado,
                                          //           color: residente![
                                          //                       'resEstado'] ==
                                          //                   'ACTIVA'
                                          //               ? secondaryColor
                                          //               : Colors.red,
                                          //           fontWeight:
                                          //               FontWeight.bold),
                                          //     ),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            
                                  
                                   ),
                                
                                
                               
                            
                            
                              );
  
  
  }

   Future<void> _onRefresh() async {
  
   
             final controller = context.read<ResidentesController>();
                    controller.resetValuesResidentes();
                    if (widget.user!.rol!.contains('CLIENTE')) {
                      controller.getTodosLosResidentes('', 'false');
                    } else if (widget.user!.rol!.contains('GUARDIA')) {
                       controller.setListaTodosLosResidentes([]);
                      controller.getTodosLosResidentesGuardia('', 'false');
                       controller.setListFilter(controller.getListaTodosLosResidentes);
                    }
  }
 


}
