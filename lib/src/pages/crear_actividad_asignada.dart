import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/actividades_asignadas_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/dataTable/lista_inventario_armas_datasource.dart';
import 'package:nseguridad/src/dataTable/lista_inventario_municiones_datasource.dart';
import 'package:nseguridad/src/dataTable/lista_inventario_vestimenta_interno_datasource.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class CrearActividadDesignada extends StatefulWidget {
  final Map<String, dynamic> requeridos;
  const CrearActividadDesignada({super.key, required this.requeridos});

  @override
  State<CrearActividadDesignada> createState() =>
      _CrearActividadDesignadaState();
}

class _CrearActividadDesignadaState extends State<CrearActividadDesignada> {
  @override
  void initState() {
    super.initState();
    _inicio();
  }

  void _inicio() {
    final datos =
        Provider.of<ActividadesAsignadasController>(context, listen: false);

    datos.geLisItems(datos.getInfoActividad['act_asigVestimentas']);
    datos.geLisItemsArmas(datos.getInfoActividad['act_asigArmas']);
    datos.geLisItemsMuniciones(datos.getInfoActividad['act_asigMuniciones']);

// _datos.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<HomeController>();
    final controller = context.read<ActividadesAsignadasController>();
    final Responsive size = Responsive.of(context);
    // print('EL MAPA: ${widget.requeridos}');
    final ctrlTheme = context.read<ThemeApp>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
          title: const Text(
            ' Inventario',
            // style: Theme.of(context).textTheme.headline2,
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: size.iScreen(1.5)),
              child: IconButton(
                  splashRadius: 28,
                  onPressed: () {
                    // SelectedItemsButto();

                    _onSubmit(context, controller, '');

                    //    final _controller=context.read<ActividadesAsignadasController>();
                    //  List<DataRow> selectedRows =_controller.getSelectedRows;
                    //                 List<int> selectedIndices = selectedRows
                    //                     .map((row) => selectedRows.indexOf(row))
                    //                     .toList();
                    //                 // Aquí puedes hacer lo que quieras con los elementos seleccionados
                    //                 // Por ejemplo, imprimir los índices seleccionados:
                    //                 print(selectedIndices);

                    //  final selectedItems = _controller.getSelectedItems();
                    //             if (selectedItems.isNotEmpty) {
                    //               // Realizar acción con los elementos seleccionados
                    //               print('Elementos seleccionados: $selectedItems');
                    //             }
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    size: size.iScreen(4.0),
                  )),
              //  IconButton(
              //             icon: Icon(Icons.check),
              //             onPressed: () {
              //               final selectedItems = dataProvider.getSelectedItems();
              //               if (selectedItems.isNotEmpty) {
              //                 // Realizar acción con los elementos seleccionados
              //                 print('Elementos seleccionados: $selectedItems');
              //               }
              //             },
              //           ),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: size.iScreen(0.0)),
          padding: EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
          width: size.wScreen(100.0),
          height: size.hScreen(100),
          child: Form(
            key: controller.actividadesAsignadasFormKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //*****************************************/

                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //                     //==========================================//
                  Container(
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
                  //                     //*****************************************/

                  SizedBox(
                    height: size.iScreen(0.5),
                  ),

                  //                     //==========================================//
                  //                   //***********************************************/

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Detalle de actividad:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      isDense: true,
                    ),
                    textAlign: TextAlign.start,
                    minLines: 1,
                    maxLines: 3,
                    style: const TextStyle(),
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          // RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                          RegExp(r'^[^\n"]*$')),
                    ],
                    onChanged: (text) {
                      controller.setInputTitulo(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese Título de actividad';
                      }
                    },
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //                               //*****************************************/
                  Container(
                    width: size.wScreen(100.0),
                    padding: EdgeInsets.all(size.iScreen(0.5)),
                    color: Colors.grey.shade200,
                    child: Text('Lista de Vestimenta:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),

                  controller.getDataRows.isNotEmpty
                      ? Consumer<ActividadesAsignadasController>(
                          builder: (_, valueDS, __) {
                            return PaginatedDataTable(
                              // header: Text('Items'),
                              // rowsPerPage: valueDS.rowsPerPage,
                              // onRowsPerPageChanged: (value) {
                              //   valueDS.updateRowsPerPage(value!);
                              // },
                              // sortColumnIndex: dataProvider.sortColumnIndex,
                              // sortAscending: dataProvider.sortAscending,
                              rowsPerPage: valueDS.getDataRows.length,
                              columns: [
                                // DataColumn(
                                //   label: Text('Item'),
                                //   // onSort: (columnIndex, sortAscending) {
                                //   //   // valueDS.sortDataRows(columnIndex, sortAscending);
                                //   // },
                                // ),
                                // DataColumn(
                                //   label: Text('Description'),
                                // ),
                                // DataColumn(
                                //   label: Text('Select'),
                                // ),
                                DataColumn(
                                    label: Text('Nombre',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    numeric: true,
                                    label: Text('Cantidad',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Serie',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Valor',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                                DataColumn(
                                    label: Text('Estado',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Marca',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Modelo',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Talla',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Color',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Stock',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                              ],

                              source:
                                  ListaInventarioInternoDTS(valueDS, 'NUEVO'),
                            );
                          },
                        )
                      : const NoData(label: 'No hay registros '),

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //                               //*****************************************/
                  Container(
                    width: size.wScreen(100.0),
                    padding: EdgeInsets.all(size.iScreen(0.5)),
                    color: Colors.grey.shade200,
                    child: Text('Lista de Armas:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  controller.getDataRowsArmas.isNotEmpty
                      ? Consumer<ActividadesAsignadasController>(
                          builder: (_, valueArmasDS, __) {
                            return PaginatedDataTable(
                              // header: Text('Items'),
                              // rowsPerPage: valueDS.rowsPerPage,
                              // onRowsPerPageChanged: (value) {
                              //   valueDS.updateRowsPerPage(value!);
                              // },
                              // sortColumnIndex: dataProvider.sortColumnIndex,
                              // sortAscending: dataProvider.sortAscending,
                              rowsPerPage: valueArmasDS.getDataRowsArmas.length,
                              columns: [
                                DataColumn(
                                    label: Text('Nombre',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    numeric: true,
                                    label: Text('Cantidad',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Serie',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Valor',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                                DataColumn(
                                    label: Text('Estado',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Marca',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Modelo',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Tipo Arma',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Calibre',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Color',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Stock',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Foto',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                              ],

                              source: ListaInventarioInternoArmasDTS(
                                  valueArmasDS, 'NUEVO'),
                            );
                          },
                        )
                      : const NoData(label: 'No hay registros '),

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  //                               //*****************************************/
                  Container(
                    width: size.wScreen(100.0),
                    padding: EdgeInsets.all(size.iScreen(0.5)),
                    color: Colors.grey.shade200,
                    child: Text('Lista de Municiones:',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  controller.getDataRowsMuniciones.isNotEmpty
                      ? Consumer<ActividadesAsignadasController>(
                          builder: (_, valueMunicionesDS, __) {
                            return PaginatedDataTable(
                              // header: Text('Items'),
                              // rowsPerPage: valueDS.rowsPerPage,
                              // onRowsPerPageChanged: (value) {
                              //   valueDS.updateRowsPerPage(value!);
                              // },
                              // sortColumnIndex: dataProvider.sortColumnIndex,s
                              // sortAscending: dataProvider.sortAscending,
                              rowsPerPage: valueMunicionesDS
                                  .getDataRowsMuniciones.length,
                              columns: [
                                DataColumn(
                                    label: Text('Materias',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    numeric: true,
                                    label: Text('Cantidad',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Serie',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Valor',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                                DataColumn(
                                    label: Text('Estado',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Marca',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Modelo',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Tipo Arma',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Calibre',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Color',
                                        style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Stock',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                                // DataColumn(
                                //     label: Text('Foto',
                                //         style: GoogleFonts.lexendDeca(
                                //             fontWeight: FontWeight.normal,
                                //             color: Colors.grey))),
                              ],

                              source: ListaInventarioInternoMunicionesDTS(
                                  valueMunicionesDS, 'NUEVO'),
                            );
                          },
                        )
                      : const NoData(label: 'No hay registros '),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context,
      ActividadesAsignadasController actividadController, String estado) async {
    final selectedItems = actividadController.getSelectedItems();
    final unselectedItems = actividadController.getUnselectedItems();
    final combinedList = [...selectedItems, ...unselectedItems];
    actividadController.setUnificaListas(combinedList);

    final selectedItemsArmas = actividadController.getSelectedItemsArmas();
    final unselectedItemsArmas = actividadController.getUnselectedItemsArmas();
    final combinedListArmas = [...selectedItemsArmas, ...unselectedItemsArmas];
    actividadController.setUnificaListasArmas(combinedListArmas);

    final selectedItemsMuniciones =
        actividadController.getSelectedItemsMuniciones();
    final unselectedItemsMuniciones =
        actividadController.getUnselectedItemsMuniciones();
    final combinedListMuniciones = [
      ...selectedItemsMuniciones,
      ...unselectedItemsMuniciones
    ];
    actividadController.setUnificaListasMuniciones(combinedListMuniciones);

    final isValid = actividadController.validateForm();
    if (!isValid) return;
    if (isValid) {
      actividadController.guardaInventarioInterno(context);

      final conexion = await Connectivity().checkConnectivity();
      if (actividadController.getInputTitulo == null ||
          actividadController.getInputTitulo == '') {
        NotificatiosnService.showSnackBarError(
            'Debe agregar Título de actividad');
      } else if (conexion == ConnectivityResult.none) {
        NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
      } else if (conexion == ConnectivityResult.wifi ||
          conexion == ConnectivityResult.mobile) {
        ProgressDialog.show(context);
        final response =
            await actividadController.guardaInventarioInterno(context);
        ProgressDialog.dissmiss(context);
        if (response != null) {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute<void>(
          //         builder: (BuildContext context) => const SplashPage()));
          Navigator.pop(context);
          Navigator.pop(context);

          // _actividadController.resetValuesActividades();
          actividadController.borrarDatos();
          actividadController.agruparProductos();

          actividadController.getActividadesAsignadas('', 'false');
        } else {
          NotificatiosnService.showSnackBarError(
              'Problemas al guardar registro');
        }
      }
    }

    // if (_actividadController.getTextDirigido!.isEmpty) {
    //   NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
    // } else if (_actividadController.getTextDirigido == null) {
    //   NotificatiosnService.showSnackBarDanger('Debe elegir a persona');
    // } else {
    //   await _actividadController.crearInforme(context);
    //   Navigator.pop(context);
    // }
  }
}

// class _DataSource extends DataTableSource {
//   final ActividadesAsignadasController dataProvider;

//   _DataSource(this.dataProvider);

//   @override
//   DataRow? getRow(int index) {
//     if (index >= dataProvider.dataRows.length) return null;
//     final row = dataProvider.dataRows[index];
//     return DataRow(
//       cells: [
//         DataCell(Text(row['item'])),
//         DataCell(Text(row['description'])),
//         DataCell(
//           Checkbox(
//             value: row['isChecked'],
//             onChanged: (value) {

//               dataProvider.updateCheckedStatus(index,value!);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => dataProvider.dataRows.length;

//   @override
//   int get selectedRowCount => 0;
// }

// class DataProvider with ChangeNotifier {
//   int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
//   int _sortColumnIndex = 0;
//   bool _sortAscending = true;
//   List<Map<String, dynamic>> _dataRows = List<Map<String, dynamic>>.generate(
//     50,
//     (index) => {
//       'isChecked': false,
//       'item': 'Item ${index + 1}',
//       'description': 'Description ${index + 1}',
//     },
//   );

//   int get rowsPerPage => _rowsPerPage;
//   int get sortColumnIndex => _sortColumnIndex;
//   bool get sortAscending => _sortAscending;
//   List<Map<String, dynamic>> get dataRows => _dataRows;

//   void updateRowsPerPage(int value) {
//     _rowsPerPage = value;
//     notifyListeners();
//   }

//   void sortDataRows(int columnIndex, bool sortAscending) {
//     _sortColumnIndex = columnIndex;
//     _sortAscending = sortAscending;
//     _dataRows.sort((a, b) {
//       final aValue = a['item'];
//       final bValue = b['item'];
//       return sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
//     });
//     notifyListeners();
//   }

//   void updateCheckedStatus(int index, bool value) {
//     _dataRows[index]['isChecked'] = value;
//     notifyListeners();
//   }

//    List<Map<String, dynamic>> getSelectedItems() {
//     return _dataRows.where((row) => row['isChecked']).toList();
//   }
//  }

class SelectedItemsButton extends StatelessWidget {
  const SelectedItemsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<ActividadesAsignadasController>(context);
    final selectedItems = dataProvider.getSelectedItems();

    return ElevatedButton(
      onPressed: selectedItems.isNotEmpty
          ? () {
              // Acción a realizar con los elementos seleccionados
              print('Elementos seleccionados: $selectedItems');
            }
          : null,
      child: const Text('Seleccionar elementos'),
    );
  }
}
