import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/api/authentication_client.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/login_controller.dart';
import 'package:nseguridad/src/pages/splash_screen.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
// import 'package:nseguridad/src/services/notifications_service.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/letras_mayusculas_minusculas.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:nseguridad/src/utils/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final controlador=LoginController();
  bool _obscureText = true;
  final TextEditingController _textEmpresa = TextEditingController();
  final TextEditingController _textUsuario = TextEditingController();
  final TextEditingController _textClave = TextEditingController();
  final logData = LoginController();
  final bool _isCheck = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    inicialData();
    super.initState();
  }

  void inicialData() async {
    final datosRecordarme = await Auth.instance.getDataRecordarme();
    if (datosRecordarme != null && datosRecordarme[0] == 'true') {
      _textEmpresa.text = '${datosRecordarme[1]}';
      _textUsuario.text = '${datosRecordarme[2]}';
      _textClave.text = '${datosRecordarme[3]}';

      logData.onRecuerdaCredenciales(true);

      logData.setLabelNombreEmpresa(datosRecordarme[1]);
      logData.onChangeUser(datosRecordarme[2]);
      logData.onChangeClave(datosRecordarme[3]);
    } else if (datosRecordarme == null || datosRecordarme[0] == 'false') {
      _textEmpresa.text = '';
      _textUsuario.text = '';
      _textClave.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ChangeNotifierProvider(
              create: (_) => LoginController(),
              builder: (context, __) {
                final controller = Provider.of<LoginController>(context);

                return Container(
                  // color:Colors.green,
                  width: size.iScreen(100.0),
                  height: size.iScreen(100.0),
                  margin: EdgeInsets.only(
                      bottom: size.iScreen(0.0), top: size.iScreen(0.0)),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.red,
                          margin: EdgeInsets.only(
                              bottom: size.iScreen(4.0),
                              top: size.iScreen(4.0)),
                          width: size.wScreen(35.0),
                          child: Image.asset(
                            'assets/imgs/Guardias.png',
                          ),
                        ),

                        Form(
                          key: controller.loginFormKey,
                          child: Container(
                            // color:Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(5.0)),
                            margin: EdgeInsets.only(bottom: size.iScreen(1.0)),
                            width: size.wScreen(100.0),

                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _textEmpresa,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Empresa',
                                    suffixIcon: Icon(Icons.factory_outlined),
                                  ),
                                  inputFormatters: [
                                    UpperCaseText(),
                                  ],
                                  textAlign: TextAlign.start,
                                  onChanged: (text) {
                                    controller.setLabelNombreEmpresa(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Ingrese nombre de Empresa';
                                    }
                                  },
                                  onSaved: (value) {
                                    // codigo = value;
                                    controller.setLabelNombreEmpresa(value!);
                                  },
                                ),

                                //***********************************************/
                                SizedBox(
                                  height: size.iScreen(2.0),
                                ),

                                //*****************************************/

                                TextFormField(
                                  controller: _textUsuario,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Usuario',
                                    suffixIcon:
                                        Icon(Icons.person_outline_outlined),
                                  ),
                                  textAlign: TextAlign.start,
                                  onChanged: (text) {
                                    controller.onChangeUser(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Usuario Inválido';
                                    }
                                  },
                                  onSaved: (value) {
                                    controller.onChangeUser(value!);
                                  },
                                ),

                                //***********************************************/
                                SizedBox(
                                  height: size.iScreen(2.0),
                                ),
                                //*****************************************/
                                TextFormField(
                                  controller: _textClave,
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: 'Clave',
                                    suffixIcon: IconButton(
                                        splashRadius: 5.0,
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: _obscureText
                                            ? const Icon(
                                                Icons.visibility_off_outlined)
                                            : const Icon(
                                                Icons.remove_red_eye_outlined)),
                                  ),
                                  obscureText: _obscureText,
                                  textAlign: TextAlign.start,
                                  onChanged: (text) {
                                    controller.onChangeClave(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Ingrese su Clave';
                                    }
                                  },
                                  onSaved: (value) {
                                    controller.onChangeClave(value!);
                                  },
                                ),

                                //***********************************************/
                              ],
                            ),
                          ),
                        ),
                        //===========================================//
                        Container(
                          // color: Colors.red,
                          width: size.wScreen(90.0),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.iScreen(2.0)),

                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // color: Colors.blue,
                                margin: EdgeInsets.only(
                                  top: size.iScreen(0.0),
                                  bottom: size.iScreen(.0),
                                  left: size.iScreen(0.0),
                                  right: size.iScreen(4.0),
                                ),
                                padding: EdgeInsets.only(
                                  top: size.iScreen(0.0),
                                  bottom: size.iScreen(0.0),
                                  left: size.iScreen(0.0),
                                  right: size.iScreen(0.0),
                                ),
                                //
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'password');
                                  },
                                  child: Text(
                                    '¿Olvidé mi Clave?',
                                    style: GoogleFonts.roboto(
                                        fontSize: size.iScreen(1.8),
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(
                                  top: size.iScreen(3.0),
                                  bottom: size.iScreen(3.0),
                                  left: size.iScreen(0.0),
                                  right: size.iScreen(1.0),
                                ),
                                child: Row(
                                  children: [
                                    Consumer<LoginController>(
                                      builder: (_, provider, __) {
                                        return Container(
                                          // color: Colors.red,
                                          child: Checkbox(
                                              focusColor: Colors.white,
                                              value: provider
                                                  .getRecuerdaCredenciales,
                                              onChanged: (value) {
                                                provider.onRecuerdaCredenciales(
                                                    value!);
                                                // print(value);
                                              }),
                                        );
                                      },
                                    ),
                                    Text(
                                      'Recordarme',
                                      style: GoogleFonts.roboto(
                                          fontSize: size.iScreen(1.8),
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
    

//========================================//
Consumer<LoginController>(
  builder: (context, controller, child) {
    return GestureDetector(
      onTap: () {
        if (!controller.isLoading) {
          _onSubmit(context, controller, size);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: controller.isLoading ? Colors.grey : primaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(5.0),
          vertical: size.iScreen(3.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: size.iScreen(3.0),
          vertical: size.iScreen(0.5),
        ),
        child: Container(
          alignment: Alignment.center,
          height: size.iScreen(3.5),
          width: size.iScreen(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isLoading) ...[
                SizedBox(
                  height: size.iScreen(2.5),
                  width: size.iScreen(2.5),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                ),
                SizedBox(width: size.iScreen(1.0)), // Espacio entre el indicador y el texto
              ],
              Text(
                controller.isLoading ? 'Espera...' : 'Entrar',
                style: GoogleFonts.roboto(
                  fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: controller.isLoading ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),
//===========================================//


                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //*******************************************************//
//   void _onSubmit(BuildContext contextResponsive,LoginController ctrllogin,size) async {
//     final ctrlHome=context.read<HomeController>();

//     final isValid = ctrllogin.validateForm();
//     ctrllogin.loginFormKey.currentState?.save();
//     if (!isValid) return;
//     if (isValid) {

//       //********************//
// final conexion = await Connectivity().checkConnectivity();
//       if (ctrllogin.getlNombreEmpresa == null) {
//         NotificatiosnService.showSnackBarError('Seleccione Empresa');
//       } else if (conexion == ConnectivityResult.none) {
//         NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
//       } else if (conexion == ConnectivityResult.wifi ||
//           conexion == ConnectivityResult.mobile) {

//         final status = await Permission.location.request();
//         if (status == PermissionStatus.granted) {
//           await ctrlHome.getCurrentPosition();
//           if (ctrlHome.getCoords != '') {
//             ProgressDialog.show(context);
//             final response = await ctrllogin.loginApp(context);
//             ProgressDialog.dissmiss(context);
//             if (response != null) {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute<void>(
//                       builder: (BuildContext context) => const SplashPage()));
//             }
//             else{
//               // NotificatiosnService.showSnackBarError('Error de conexión con el servidor');
//             }
//           }
//         } else {
//           // print('============== NOOOO TIENE PERMISOS');
//           Navigator.pushNamed(context, 'gps');
//         }
  // }

// void _onSubmit(BuildContext contextResponsive, LoginController ctrllogin, Responsive size) async {
//   final ctrlHome = context.read<HomeController>();
// ctrlHome.activateAlarm(false);
//   final isValid = ctrllogin.validateForm();
//   ctrllogin.loginFormKey.currentState?.save();
//   if (!isValid) return;

//   print('Formulario validado.');

//   if (isValid) {
//     final conexion = await Connectivity().checkConnectivity();
//     print('Estado de conectividad: $conexion');

//     if (ctrllogin.getlNombreEmpresa == null) {
//       NotificatiosnService.showSnackBarError('Seleccione Empresa');
//     } else if (conexion == ConnectivityResult.none) {
//       NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
//     } else if (conexion == ConnectivityResult.wifi || conexion == ConnectivityResult.mobile) {
//       final status = await Permission.location.request();
//       print('Permiso de ubicación: $status');

//       if (status == PermissionStatus.granted) {
//         await ctrlHome.getCurrentPosition();
//         // print('Posición actual obtenida: ${ctrlHome.getCoords}');

//         if (mounted && ctrlHome.getCoords != '') {
//           ProgressDialog.show(context);
//           print('Mostrando ProgressDialog.');

//           final response = await ctrllogin.loginApp(context);
//           // print('Respuesta del login: $response');

//           if (mounted) {
//             ProgressDialog.dissmiss(context);
//             print('Ocultando ProgressDialog.');

//             if (response != null) {
//               WidgetsBinding.instance?.addPostFrameCallback((_) {
//                 if (mounted) {
//                   // print('Navegando a SplashPage.');
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute<void>(
//                           builder: (BuildContext context) => const SplashPage()));
//                 }
//               });
//             } else {
//               // print('Error en la respuesta del servidor.');
//               // NotificatiosnService.showSnackBarError('Error de conexión con el servidor');
//             }
//           }
//         }
//       } else {
//         if (mounted) {
//           // print('Permiso de ubicación no concedido, navegando a gps.');
//           Navigator.pushNamed(context, 'gps');
//         }
//       }
//     }
//   }
// }

  // void _onSubmit(BuildContext contextResponsive, LoginController ctrllogin,
  //     Responsive size) async {
  //   final ctrlHome = context.read<HomeController>();

  //   // Desactiva la alarma antes de iniciar el proceso de inicio de sesión
  //   ctrlHome.activateAlarm(false);

  //   // Valida el formulario
  //   final isValid = ctrllogin.validateForm();
  //   ctrllogin.loginFormKey.currentState?.save();
  //   if (!isValid) return;

  //   print('Formulario validado.');

  //   // Verifica la conexión a Internet
  //   final conexion = await Connectivity().checkConnectivity();
  //   print('Estado de conectividad: $conexion');

  //   if (ctrllogin.getlNombreEmpresa == null) {
  //     NotificatiosnService.showSnackBarError('Seleccione Empresa');
  //     return;
  //   } else if (conexion == ConnectivityResult.none) {
  //     NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
  //     return;
  //   }

  //   // Solicita el permiso de ubicación
  //   final status = await Permission.location.request();
  //   print('Permiso de ubicación: $status');

  //   if (status == PermissionStatus.granted) {
  //     // Obtén la posición actual
  //     await ctrlHome.getCurrentPosition();

  //     // Asegúrate de que el widget sigue activo y de que se obtuvieron las coordenadas
  //     if (!mounted || ctrlHome.getCoords!.isEmpty) return;

  //     // Muestra un diálogo de progreso
  //     ProgressDialog.show(context);
  //     print('Mostrando ProgressDialog.');

  //     // Realiza el inicio de sesión
  //     final response = await ctrllogin.loginApp(context);

  //     if (mounted) {
  //       // Oculta el ProgressDialog
  //       ProgressDialog.dissmiss(context);
  //       print('Ocultando ProgressDialog.');

  //       if (response != null) {
  //         // Si la respuesta es válida, navega a la página SplashPage
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           if (mounted) {
  //             Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute<void>(
  //                     builder: (BuildContext context) => const SplashPage()));
  //           }
  //         });
  //       } else {
  //         // Muestra un error si no hay respuesta del servidor
  //         // NotificatiosnService.showSnackBarError(
  //         //     'Error de conexión con el servidor');
  //       }
  //     }
  //   } else {
  //     // Si no se concede el permiso de ubicación, navega a la página de activación de GPS
  //     if (mounted) {
  //       Navigator.pushNamed(context, 'gps');
  //     }
  //   }
  // }

void _onSubmit(BuildContext contextResponsive, LoginController ctrllogin,
    Responsive size) async {
  final ctrlHome = context.read<HomeController>();

  // Evita múltiples pulsaciones
  if (ctrllogin.isLoading) return;
  ctrllogin.isLoading = true;

  // Desactiva la alarma antes de iniciar el proceso de inicio de sesión
  ctrlHome.activateAlarm(false);

  // Valida el formulario
  final isValid = ctrllogin.validateForm();
  ctrllogin.loginFormKey.currentState?.save();
  if (!isValid) {
    ctrllogin.isLoading = false;
    return;
  }

  print('Formulario validado.');

  // Verifica la conexión a Internet
  final conexion = await Connectivity().checkConnectivity();
  print('Estado de conectividad: $conexion');

  if (ctrllogin.getlNombreEmpresa == null) {
    NotificatiosnService.showSnackBarError('Seleccione Empresa');
    ctrllogin.isLoading = false;
    return;
  } else if (conexion == ConnectivityResult.none) {
    NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
    ctrllogin.isLoading = false;
    return;
  }

  // Solicita el permiso de ubicación
  final status = await Permission.location.request();
  print('Permiso de ubicación: $status');

  if (status == PermissionStatus.granted) {
    // Obtén la posición actual
    await ctrlHome.getCurrentPosition();

    // Asegúrate de que el widget sigue activo y de que se obtuvieron las coordenadas
    if (!mounted || ctrlHome.getCoords!.isEmpty) {
      ctrllogin.isLoading = false;
      return;
    }

    // Muestra un diálogo de progreso
    ProgressDialog.show(context);
    print('Mostrando ProgressDialog.');

    // Realiza el inicio de sesión
    final response = await ctrllogin.loginApp(context);

    if (mounted) {
      // Oculta el ProgressDialog
      ProgressDialog.dissmiss(context);
      print('Ocultando ProgressDialog.');

      if (response != null) {
        // Si la respuesta es válida, navega a la página SplashPage
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SplashPage()));
          }
        });
      } else {
        NotificatiosnService.showSnackBarError(
            'Error de conexión con el servidor');
      }
    }
  } else {
    // Si no se concede el permiso de ubicación, navega a la página de activación de GPS
    if (mounted) {
      Navigator.pushNamed(context, 'gps');
    }
  }

  // Restablece el estado de isLoading
  ctrllogin.isLoading = false;
}



}
