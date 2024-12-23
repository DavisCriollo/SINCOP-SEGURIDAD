import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/cambio_puesto_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/residentes_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/pages/buscar_clientes.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/correos.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/letras_mayusculas_minusculas.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';


class CreaNuevoResidente extends StatefulWidget {

 final String? action;
  final Session? user;

  const CreaNuevoResidente({super.key, this.action, this.user});
  @override
  State<CreaNuevoResidente> createState() => _CreaNuevoResidenteState();
}

class _CreaNuevoResidenteState extends State<CreaNuevoResidente> {
  final _controlCorreo = TextEditingController();
  final _controlTelefono = TextEditingController();
  final _controlPersona = TextEditingController();

    final _controlCorreoPropietario = TextEditingController();
  final _controlTelefonoPropietario = TextEditingController();

   final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  

     final _cedulaPropietarioController = TextEditingController();
  final _nombrePropietarioController = TextEditingController();
  final _apellidoPropietarioController = TextEditingController();


      final _casaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ubicacionController = TextEditingController();
  

  @override
  void initState() {
    
final _crtl= context.read<ResidentesController>();
          _nombreController.text = _crtl.getNombreNArrendatario??'';
      _apellidoController.text = _crtl.getApellidoNArrendatario??'';

            _nombrePropietarioController.text = _crtl.getNombreNPropietario??'';
      _apellidoPropietarioController.text = _crtl.getApellidoNPropietario??'';

    super.initState();
  }


  @override
  void dispose() {
    _controlCorreo.dispose();
    _controlTelefono.dispose();
    _controlPersona.dispose();

       _cedulaController.dispose();
      _nombreController.dispose();
  _apellidoController.dispose();

 _controlCorreoPropietario.dispose();
    _controlTelefonoPropietario.dispose();


   _cedulaPropietarioController.dispose();
      _nombrePropietarioController.dispose();
  _apellidoPropietarioController.dispose();

  _casaController .dispose();
  _numeroController .dispose();
  _ubicacionController .dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      final Responsive size = Responsive.of(context);
    final user = context.read<HomeController>();
    final residenteController = context.read<ResidentesController>();
    final ctrlTheme = context.read<ThemeApp>();

    final action = widget.action;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            // backgroundColor: primaryColor,
            // title:  Text('Registrar Bitácora',style:  Theme.of(context).textTheme.headline2,),

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
            title: action == 'CREATE'
                ? const Text(
                    'Crear Residente',
                    // style: Theme.of(context).textTheme.headline2,
                  )
                : const Text(
                    'Editar Residente',
                    // style: Theme.of(context).textTheme.headline2,
                  ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: size.iScreen(1.5)),
                child: IconButton(
                    splashRadius: 28,
                    onPressed: () {
                      _onSubmit(context, residenteController, action!);
                    },
                    icon: Icon(
                      Icons.save_outlined,
                      size: size.iScreen(4.0),
                    )),
              ),
            ],
          ),
        body: Container(
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
              child: Column(
                children: [
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

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                     SizedBox(
                                width: size.wScreen(100.0),

                                // color: Colors.blue,
                                child: Row(
                                  children: [
                                    Text('Cliente:',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey)),
                                            SizedBox(width: size.iScreen(1.0),),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: GestureDetector(onTap: () {
                                              
                          
                           Provider.of<CambioDePuestoController>(context,
                                  listen: false)
                              .getTodosLosClientes('');
                    
                          Navigator.pushNamed(context, 'buscaClientes',
                              arguments: 'nuevoResidente');


                                              }, child: Consumer<ThemeApp>(
                                                builder: (_, valueTheme, __) {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    color:
                                                        valueTheme.primaryColor,
                                                    width: size.iScreen(3.5),
                                                    padding: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom: size.iScreen(0.5),
                                                      left: size.iScreen(0.5),
                                                      right: size.iScreen(0.5),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: valueTheme
                                                          .secondaryColor,
                                                      size: size.iScreen(2.0),
                                                    ),
                                                  );
                                                },
                                              )),
                                            )
                                  ],
                                ),
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
                          child: Consumer<ResidentesController>(
                            builder: (_, persona, __) {
                              return (persona.nombreNuevoCliente.isEmpty)
                                  ? Text(
                                      'No hay cliente designado',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.7),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    )
                                  : Text(
                                      '${persona.nombreNuevoCliente} ',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.7),
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
                              SizedBox(
                                height: size.iScreen(0.0),
                              ),
                              //***********************************************//
                              //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                     SizedBox(
                                width: size.wScreen(100.0),

                                // color: Colors.blue,
                                child: Row(
                                  children: [
                                    Text('Puesto:',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey)),
                                            SizedBox(width: size.iScreen(1.0),),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: GestureDetector(onTap: () {
                                                    
                                                  _modalSeleccionaPuesto(size);

                                              }, child: Consumer<ThemeApp>(
                                                builder: (_, valueTheme, __) {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    color:
                                                        valueTheme.primaryColor,
                                                    width: size.iScreen(3.5),
                                                    padding: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom: size.iScreen(0.5),
                                                      left: size.iScreen(0.5),
                                                      right: size.iScreen(0.5),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: valueTheme
                                                          .secondaryColor,
                                                      size: size.iScreen(2.0),
                                                    ),
                                                  );
                                                },
                                              )),
                                            )
                                  ],
                                ),
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
                          child: Consumer<ResidentesController>(
                            builder: (_, puesto, __) {
                              return (puesto.puestos.isEmpty)
                                  ? Text(
                                      'No hay puesto seleccionado',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.7),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    )
                                  : Text(
                                      '${puesto.puestos['ubicacion']} - ${puesto.puestos['puesto']}',
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.7),
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
                   //***********************************************/
                    SizedBox(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Tipo Persona:',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(0.0),
                    ),
                    //***********************************************/
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(
                              // top: size.iScreen(1.0),
                              // right: size.iScreen(0.5),
                            ),
                            child: Consumer<ResidentesController>(
                              builder: (_, personal, __) {
                                return (personal.getItemTipoPersonal == '' ||
                                        personal.getItemTipoPersonal == null)
                                    ? Text(
                                        'Seleccione tipo de Residente',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                      )
                                    : Text(
                                        '${personal.getItemTipoPersonal}',
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
                            _modalSeleccionaTipoPersona(
                                size, residenteController);
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.0),
                                ),
                              );
                            },
                          )),
                        ),
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //=================ARRENDATARIO=======================//
                 Consumer<ResidentesController>(
          builder: (context, documentTypeProvider, child) {
            return 
            documentTypeProvider.getItemTipoPersonal=='ARRENDATARIO'
            ?Column(
              children: [
                Text(
                                        '------------ ARRENDATARIO -----------',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Cédula'),
                        leading: Radio<String>(
                          value: 'CEDULA',
                          groupValue: documentTypeProvider.selectedTypeArrendatario,
                          onChanged: (value) {
                            documentTypeProvider.setSelectedTypeArrendatario(value!);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Pasaporte'),
                        leading: Radio<String>(
                          value: 'PASAPORTE',
                          groupValue: documentTypeProvider.selectedTypeArrendatario,
                          onChanged: (value) {
                            documentTypeProvider.setSelectedTypeArrendatario(value!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                 Column(
           mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    // controller: _cedulaController,
                    initialValue: valueArendatario.getCedulaNArrendatario,
                    decoration: InputDecoration(labelText: '${valueArendatario.selectedTypeArrendatario}'),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                            valueArendatario.setCedulaNArrendatario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Nombres';
                            }
                          },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                           
                            _searchClient(context,valueArendatario.selectedTypeArrendatario,'RESIDENTE',valueArendatario.getCedulaNArrendatario);
                          }, child: Consumer<ThemeApp>(
                            builder: (_, valueTheme, __) {
                              return Container(
                                alignment: Alignment.center,
                                color: valueTheme.primaryColor,
                                width: size.iScreen(4.0),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.5),
                                  left: size.iScreen(0.5),
                                  right: size.iScreen(0.5),
                                ),
                                child: Icon(
                                  Icons.search_outlined,
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(3.0),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          
           
           
            Consumer<ResidentesController>(
              builder: (context, personaProvider, child) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                  
                          decoration: const InputDecoration(labelText: 'Nombres'),
                          textAlign: TextAlign.start,
                          style: const TextStyle(),
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                // RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                                RegExp(r'^[^\n"]*$')),
                            UpperCaseText(),
                          ],
                          onChanged: (text) {
                            personaProvider.setNombreNArrendatario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Nombres';
                            }
                          },
                        ),
                  
                    TextFormField(
                      controller: _apellidoController,     
                          decoration: const InputDecoration(
                            labelText: 'Apellidos'
                          ),
                          textAlign: TextAlign.start,
                          
                          style: const TextStyle(

                          ),
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                // RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                                RegExp(r'^[^\n"]*$')),
                            UpperCaseText(),
                          ],
                          onChanged: (text) {
                            personaProvider.setApellidoNArrendatario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Apellidos';
                            }
                          },
                        ),
                  
                   
                  ],
                );
              },
            ),
            //=============TELEFONOS =================//
                      Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    controller: _controlTelefono,
                    decoration: InputDecoration(labelText: 'Ingrese Teléfono'),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onChanged: (text) {
                            // valueArendatario.setCedulaNArrendatario(text);
                          },
                          // validator: (text) {
                          //   if (text!.trim().isNotEmpty) {
                          //     return null;
                          //   } else {
                          //     return 'Ingrese Nombres';
                          //   }
                          // },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                                if (_controlTelefono.text.length==10) {
                                  _telefonos(_controlTelefono.text,'RESIDENTE');
                                } else {
                                  NotificatiosnService.showSnackBarDanger("Agregue Teléfono");
                                }
                          
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.5),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          

                 //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                
                 //***********************************************/

                  Consumer<ResidentesController>(builder: (_, value, __) { 
                    return Wrap(
                      children:(value.getListaTelefonosArrendatarios).map((e)=>
                      GestureDetector(
                        onTap: () {
                          value.deleteTelefonoArrendatario(e);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                             color:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(1.0)),
                          margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(0.5)),
                         
                          child: Text('$e',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),),
                      )).toList() ,
                    );
                   },),


            //=========================================//

//============= CORREOS =================//
                      Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    controller: _controlCorreo,
                    decoration: InputDecoration(labelText: 'Ingrese Correo'),
                    keyboardType: TextInputType.emailAddress,
                   
                    onChanged: (text) {
                            // valueArendatario.setCedulaNArrendatario(text);
                          },
                          // validator: (text) {
                          //   if (text!.trim().isNotEmpty) {
                          //     return null;
                          //   } else {
                          //     return 'Ingrese Correo';
                          //   }
                          // },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                          verificarCorreo('RESIDENTE',_controlCorreo.text);
                                
                          
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.5),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          

                 //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                
                 //***********************************************/

                  Consumer<ResidentesController>(builder: (_, value, __) { 
                    return Wrap(
                      children:(value.getListaCorreosArrendatarios).map((e)=>
                      GestureDetector(
                        onTap: () {
                          value.deleteCorreoArrendatario(e);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                             color:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(1.0)),
                          margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(0.5)),
                         
                          child: Text('$e',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),),
                      )).toList() ,
                    );
                   },)


            //=========================================//






          ],
        ),
      
              ],
            ):Container();
          },
        ),
       
      //============  PROPIETARIO  ====================////***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                 Consumer<ResidentesController>(
          builder: (context, documentTypeProvider, child) {
            return Column(
              children: [
                 Text(
                                        '------------ PROPIETARIO -----------',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Cédula'),
                        leading: Radio<String>(
                          value: 'CEDULA',
                          groupValue: documentTypeProvider.selectedTypePropietario,
                          onChanged: (value) {
                            documentTypeProvider.setSelectedTypePropietario(value!);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Pasaporte'),
                        leading: Radio<String>(
                          value: 'PASAPORTE',
                          groupValue: documentTypeProvider.selectedTypePropietario,
                          onChanged: (value) {
                            documentTypeProvider.setSelectedTypePropietario(value!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        Column(
           mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<ResidentesController>(builder: (_, valuePropietario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    controller: _cedulaPropietarioController,
                    decoration: InputDecoration(labelText: '${valuePropietario.selectedTypePropietario}'),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                            valuePropietario.setCedulaNPropietario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Nombres';
                            }
                          },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                           
                            _searchClient(context,valuePropietario.selectedTypePropietario,'PROPIETARIO',valuePropietario.getCedulaNPropietario);
                          }, child: Consumer<ThemeApp>(
                            builder: (_, valueTheme, __) {
                              return Container(
                                alignment: Alignment.center,
                                color: valueTheme.primaryColor,
                                width: size.iScreen(4.0),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.5),
                                  left: size.iScreen(0.5),
                                  right: size.iScreen(0.5),
                                ),
                                child: Icon(
                                  Icons.search_outlined,
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(3.0),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          
           
           
            Consumer<ResidentesController>(
              builder: (context, personaProvider, child) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _nombrePropietarioController,
                  
                          decoration: const InputDecoration(labelText: 'Nombres'),
                          textAlign: TextAlign.start,
                          style: const TextStyle(),
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                // RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                                RegExp(r'^[^\n"]*$')),
                            UpperCaseText(),
                          ],
                          onChanged: (text) {
                            personaProvider.setNombreNPropietario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Nombres';
                            }
                          },
                        ),
                  
                    TextFormField(
                      controller: _apellidoPropietarioController,     
                          decoration: const InputDecoration(
                            labelText: 'Apellidos'
                          ),
                          textAlign: TextAlign.start,
                          
                          style: const TextStyle(

                          ),
                          textInputAction: TextInputAction.done,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                // RegExp("[a-zA-Z0-9@#-+.,{" "}\\s]")),
                                RegExp(r'^[^\n"]*$')),
                            UpperCaseText(),
                          ],
                          onChanged: (text) {
                            personaProvider.setApellidoNPropietario(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese Apellidos';
                            }
                          },
                        ),
                  
                   
                  ],
                );
              },
            ),
             //=============TELEFONOS =================//
                      Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    controller: _controlTelefonoPropietario,
                    decoration: InputDecoration(labelText: 'Ingrese Teléfono'),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onChanged: (text) {
                            // valueArendatario.setCedulaNArrendatario(text);
                          },
                          // validator: (text) {
                          //   if (text!.trim().isNotEmpty) {
                          //     return null;
                          //   } else {
                          //     return 'Ingrese Nombres';
                          //   }
                          // },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                                if (_controlTelefonoPropietario.text.length==10) {
                                  _telefonos(_controlTelefonoPropietario.text,'PROPIETARIO');
                                } else {
                                  NotificatiosnService.showSnackBarDanger("Agregue Teléfono");
                                }
                          
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.5),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          

                 //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                
                 //***********************************************/

                  Consumer<ResidentesController>(builder: (_, value, __) { 
                    return Wrap(
                      children:(value.getListaTelefonosPropietarios).map((e)=>
                      GestureDetector(
                        onTap: () {
                          value.deleteTelefonoPropietario(e);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                             color:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(1.0)),
                          margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(0.5)),
                         
                          child: Text('$e',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),),
                      )).toList() ,
                    );
                   },),


            //=========================================//

//=============TELEFONOS =================//
                      Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(50.0),
                  child: TextFormField(
                    controller: _controlCorreoPropietario,
                    decoration: InputDecoration(labelText: 'Ingrese Correo'),
                    keyboardType: TextInputType.emailAddress,
                   
                    onChanged: (text) {
                            // valueArendatario.setCedulaNArrendatario(text);
                          },
                          // validator: (text) {
                          //   if (text!.trim().isNotEmpty) {
                          //     return null;
                          //   } else {
                          //     return 'Ingrese Correo';
                          //   }
                          // },
                  ),
                ),
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                          verificarCorreo('PROPIETARIO',_controlCorreoPropietario.text);
                                
                          
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.5),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          

                 //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                
                 //***********************************************/

                  Consumer<ResidentesController>(builder: (_, value, __) { 
                    return Wrap(
                      children:(value.getListaCorreosPropietarios).map((e)=>
                      GestureDetector(
                        onTap: () {
                          value.deleteCorreoPropietario(e);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                             color:Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(1.0)),
                          margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5),horizontal: size.iScreen(0.5)),
                         
                          child: Text('$e',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),),
                      )).toList() ,
                    );
                   },)


            //=========================================//

          ],
        ),
      //=============TELEFONOS =================//
                      Consumer<ResidentesController>(builder: (_, valueArendatario, __) { 
              return Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: size.wScreen(30.0),
                  child: Text('Propiedad:',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),),
                
               
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(onTap: () {
                             _casaController.text='';
  _numeroController.text='';
  _ubicacionController.text='';
                          _modalAgregaPropiedad(size,residenteController);
                                
                          
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
                                  color: valueTheme.secondaryColor,
                                  size: size.iScreen(2.5),
                                ),
                              );
                            },
                          )),
                        ),
              ],
            );
           
             },),
          

                 //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                
                 //***********************************************/

                 Consumer<ResidentesController>(builder: (_, value, __) {
  return Wrap(
    children: value.getListaPropiedad.map((e) => GestureDetector(
      onTap: () {
        value.deletePropiedad(e);
      },
      child: Container(
        width: size.wScreen(100.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: size.iScreen(0.5), horizontal: size.iScreen(1.0)),
        margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5), horizontal: size.iScreen(0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
          children: [
            // Fila para "Casa/Departamento"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre el título y el valor
              children: [
                Text('Casa/Departamento: ',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
                Expanded(
                  child: Text(' ${e['nombre_dpt']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: size.iScreen(0.5)), // Espacio entre filas
            // Fila para "Número"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Número: ',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
                Expanded(
                  child: Text('${e['numero']}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: size.iScreen(0.5)), // Espacio entre filas
            // Fila para "Ubicación"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ubicación: ',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
                Expanded(
                  child: Text(' ${e['ubicacion']} ',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    )).toList(),
  );
}),

            //=========================================//
              //***********************************************/
                SizedBox(
                  height: size.iScreen(1.0),
                ),
                //*****************************************/
                Container(
                  width: size.wScreen(100.0),

                  child: Text('Observación:',
                      style: GoogleFonts.lexendDeca(
                         fontSize: size.iScreen(1.8),
                         fontWeight: FontWeight.normal,
                          color: Colors.grey)),
                ),
                TextFormField(
                  initialValue: widget.action == 'CREATE'
                        ? ''
                        : residenteController.getInputObservacionNResidente,
                  decoration: const InputDecoration(
                     ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(

                      ),
                  textInputAction: TextInputAction.done,
                         inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@#-+.,{""}\\s]"),),UpperCaseText(),],
                      
                  onChanged: (text) {
                    residenteController.onObservacionChange(text);
                  },
                  validator: (text) {
                    if (text!.trim().isNotEmpty) {
                      return null;
                    } else {
                      return 'Ingrese observación';
                    }
                  },
                  minLines: 1,
                  maxLines: 5,
                ),
      //***********************************************/
                               SizedBox(
                                height: size.iScreen(0.0),
                              ),
     //***********************************************/
                           
                ],
              ),
            ),
          )
          ),
         ),
    );
  }
  // Función para manejar el botón de validación
void verificarCorreo( String tipo ,String correo) {
  if (validarCorreoElectronico(correo)) {
    // Llama a la función `_correos` si el correo es válido
        _correos(correo, tipo);
  } else {
    // Muestra un mensaje de error si el correo no es válido
    NotificatiosnService.showSnackBarDanger("Agregue un correo válido");
  }
}
void _onSubmit(BuildContext context, ResidentesController ctrl, String action) {
  // Validaciones de campos
  if (ctrl.nombreNuevoCliente.isEmpty) {
    NotificatiosnService.showSnackBarDanger('Debe seleccionar Cliente');
    return; // Salir después de mostrar el mensaje
  } else if (ctrl.puestos.isEmpty) {
    NotificatiosnService.showSnackBarDanger('Debe seleccionar puesto');
    return;
  } else if (ctrl.getItemTipoPersonal!.isEmpty) {
    NotificatiosnService.showSnackBarDanger('Debe seleccionar tipo de personal');
    return;
  } 

  // Si la acción es CREATE
  if (action == 'CREATE') {
    // Enviar imágenes al servidor si existen
    ctrl.crearNuevoResidente(context);
    ctrl.getTodosLosResidentesGuardia('', 'false');
    Navigator.pop(context);
  }

  // Si la acción es EDIT
  if (action == 'EDIT') {
    // Enviar imágenes al servidor si existen
    ctrl.editaNuevoResidente(context);
    ctrl.getTodosLosResidentesGuardia('', 'false');
    Navigator.pop(context);
  }
}







  


//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaPuesto( Responsive size) {
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
                      Text('SELECCIONAR PUESTO',
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
                  SizedBox(
                    width: size.wScreen(100),
                    height: size.hScreen(26),
                    child: 
                    Consumer<ResidentesController>(builder: (_, value, __) {  
                      return  ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: value.cliDatosOperativos.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data=value.cliDatosOperativos[index];

                        return GestureDetector(
                          onTap: () {
                            value.setPuestos(data);
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
                              '${data['ubicacion']} - ${data['puesto']}',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                 
                    },)
                   
                 
                  ),
                ],
              ),
            ),
          );
        });
  }



  //====== MUESTRA MODAL DE TIPO DE PERSONA =======//
  void _modalSeleccionaTipoPersona(
      Responsive size, ResidentesController control,) {
    final data = [
      'PROPIETARIO',
      'ARRENDATARIO'
    ];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: SizedBox(
                //        // Ajusta la altura según el tamaño de la pantalla
                // height: screenSize.width>600? size.iScreen(60) : size.iScreen(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' TIPO DE PERSONA',
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
                    SizedBox(
                      width: size.wScreen(100),
                      height: size.hScreen(24),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              control.setItemTipoPersona(data[index]);
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
            ),
          );
        });
  }
   //====== MUESTRA MODAL DE TIPO DE PERSONA =======//
 void _modalAgregaPropiedad(
    Responsive size, ResidentesController control) {
  
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
            content: SizedBox(
              child: Form(
                key: control.propiedadFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('INGRESE INFORMACIÓN DE PROPIEDAD',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.bold,
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
                      width: size.wScreen(100),
                      height: size.hScreen(24),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          TextFormField(
                            controller: _casaController,
                            decoration: const InputDecoration(labelText: 'Nombre Casa/Departamento'),
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.next,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^[^\n"]*$')),
                              UpperCaseText(),
                            ],
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese Nombre Casa Departamente';
                              }
                            },
                          ),
                          SizedBox(height: size.hScreen(1)),
                          TextFormField(
                            controller: _numeroController,
                            decoration: const InputDecoration(labelText: 'Número'),
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.next,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^[^\n"]*$')),
                              UpperCaseText(),
                            ],
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese Número';
                              }
                            },
                          ),
                          SizedBox(height: size.hScreen(1)),
                          TextFormField(
                            controller: _ubicacionController,
                            decoration: const InputDecoration(labelText: 'Ubicación'),
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.next,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^[^\n"]*$')),
                              UpperCaseText(),
                            ],
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese Ubicación';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.hScreen(1)),
                    ElevatedButton(
                      onPressed: () {
                        // Validar el formulario aquí si es necesario
                        final isValid = control.validateFormPropiedad();
    if (!isValid) return;
    if (isValid) {
                        
                          // Aquí puedes realizar las acciones que necesites con los datos
                          String casa = _casaController.text;
                          String numero = _numeroController.text;
                          String ubicacion = _ubicacionController.text;
                          print('casa: $casa, numero: $numero, ubicacion: $ubicacion');
                         Map<String,dynamic> _propiedad={};
                         _propiedad={
      "nombre_dpt": casa,
      "numero": numero,
      "ubicacion": ubicacion
    };

                          control.setListaPropiedad(_propiedad);
                          Navigator.pop(context);
                        
    }
                      },
                      child: Text('Agregar Propiedad'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

// Método para validar el correo electrónico
bool _validarCorreo(String correo) {
  final RegExp regex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  return regex.hasMatch(correo);
}

// Asegúrate de definir un GlobalKey para el formulario
// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

void _searchClient(BuildContext context, String tipo, String perfil, String cedula) async {
  final crtl = context.read<ResidentesController>();
  ProgressDialog.show(context);

  final response = await crtl.buscaPersona(cedula, tipo, perfil);
  ProgressDialog.dissmiss(context);
  if (response != null) {
   
    if (perfil == 'RESIDENTE') {
      _nombreController.text = crtl.dataPersona['perNombres'] ?? '';
      _apellidoController.text = crtl.dataPersona['perApellidos'] ?? '';
      crtl.setNombreNArrendatario(crtl.dataPersona['perNombres'] ?? '');
      crtl.setApellidoNArrendatario(crtl.dataPersona['perApellidos'] ?? '');

      for (var e in crtl.dataPersona['perTelefono']) {
        crtl.setListaTelefonosArrendatarios(e);
      }
      for (var e in crtl.dataPersona['perEmail']) {
        crtl.setListaCorreosArrendatarios(e);
      }
    
    } else if (perfil == 'PROPIETARIO') {
      _nombrePropietarioController.text = crtl.dataPersonaPropietario['perNombres'] ?? '';
      _apellidoPropietarioController.text = crtl.dataPersonaPropietario['perApellidos'] ?? '';
      
      crtl.setNombreNPropietario(crtl.dataPersonaPropietario['perNombres'] ?? '');
      crtl.setApellidoNPropietario(crtl.dataPersonaPropietario['perApellidos'] ?? '');
    

     for (var e in crtl.dataPersonaPropietario['perTelefono']) {
        crtl.setListaTelefonosPropietarios(e);
      }
      for (var e in crtl.dataPersonaPropietario['perEmail']) {
        crtl.setListaCorreosPropietarios(e);
      }
    }
  } else {

    if (perfil == 'RESIDENTE') {
      _nombreController.clear();
      _apellidoController.clear();
    } else if (perfil == 'PROPIETARIO') {
      _nombrePropietarioController.clear();
      _apellidoPropietarioController.clear();
    }
  }
}

  void _telefonos(String item,String perfil) {
 final crtl = context.read<ResidentesController>();

        if (perfil=='RESIDENTE') {
           crtl.setListaTelefonosArrendatarios(item);
           _controlTelefono.text='';
        } if (perfil=='PROPIETARIO') {
           crtl.setListaTelefonosPropietarios(item);
           _controlTelefonoPropietario.text='';
        }
     

  }

  void _correos(String item,String perfil) {
 final crtl = context.read<ResidentesController>();

        if (perfil=='RESIDENTE') {
           crtl.setListaCorreosArrendatarios(item);
           _controlCorreo.text='';
        } if (perfil=='PROPIETARIO') {
           crtl.setListaCorreosPropietarios(item);
           _controlCorreoPropietario.text='';
        }
     

  }





}