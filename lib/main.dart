import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nseguridad/firebase_options.dart';
import 'package:nseguridad/src/controllers/actividades_asignadas_controller.dart';
import 'package:nseguridad/src/controllers/activities_controller.dart';
import 'package:nseguridad/src/controllers/ausencias_controller.dart';
import 'package:nseguridad/src/controllers/aviso_salida_controller.dart';
import 'package:nseguridad/src/controllers/avisos_controller.dart';
import 'package:nseguridad/src/controllers/bitacora_controller.dart';
import 'package:nseguridad/src/controllers/botonTurno_controller.dart';
import 'package:nseguridad/src/controllers/cambio_puesto_controller.dart';
import 'package:nseguridad/src/controllers/capacitaciones_controller.dart';
import 'package:nseguridad/src/controllers/cierre_bitacora_controller.dart';
import 'package:nseguridad/src/controllers/consignas_clientes_controller.dart';
import 'package:nseguridad/src/controllers/consignas_controller.dart';
import 'package:nseguridad/src/controllers/encuastas_controller.dart';
import 'package:nseguridad/src/controllers/estado_cuenta_controller.dart';
import 'package:nseguridad/src/controllers/evaluaciones_controller.dart';
import 'package:nseguridad/src/controllers/gestion_documental_controller.dart';
import 'package:nseguridad/src/controllers/home_ctrl.dart';
import 'package:nseguridad/src/controllers/informes_controller.dart';
import 'package:nseguridad/src/controllers/logistica_controller.dart';
import 'package:nseguridad/src/controllers/multas_controller.dart';
import 'package:nseguridad/src/controllers/new_permisos_controller.dart';
import 'package:nseguridad/src/controllers/new_turno_extra_controller.dart';
import 'package:nseguridad/src/controllers/novedades_controller.dart';
import 'package:nseguridad/src/controllers/prueba_controller.dart';
import 'package:nseguridad/src/controllers/residentes_controller.dart';
import 'package:nseguridad/src/controllers/sugerencias_controller.dart';
import 'package:nseguridad/src/controllers/turno_extra_controller.dart';
import 'package:nseguridad/src/routes/routes.dart';
import 'package:nseguridad/src/service/notification_push.dart';
import 'package:nseguridad/src/service/notifications_service.dart';
import 'package:nseguridad/src/service/socket_service.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:provider/provider.dart' as prov;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final homeController = HomeController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        SystemChrome.setPreferredOrientations([
          // DeviceOrientation.portraitUp,
          // DeviceOrientation.portraitDown,
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return prov.MultiProvider(
        providers: [
          prov.ChangeNotifierProvider(create: (_) => BotonTurnoController()),

          prov.ChangeNotifierProvider(create: (_) => ThemeApp()),
          prov.ChangeNotifierProvider(create: (_) => PushNotificationService()),
          prov.ChangeNotifierProvider(create: (_) => ImagenCompress()),
          prov.ChangeNotifierProvider(create: (_) => SocketService()),
          prov.ChangeNotifierProvider(create: (_) => HomeController()),
          prov.ChangeNotifierProvider(create: (_) => ActividadesController()),
          prov.ChangeNotifierProvider(create: (_) => AvisosController()),
          prov.ChangeNotifierProvider(
              create: (_) => ConsignasClientesController()),
          prov.ChangeNotifierProvider(create: (_) => ConsignasController()),
          prov.ChangeNotifierProvider(create: (_) => EstadoCuentaController()),
          prov.ChangeNotifierProvider(
              create: (_) => MultasGuardiasContrtoller()),
          prov.ChangeNotifierProvider(create: (_) => InformeController()),
          prov.ChangeNotifierProvider(create: (_) => LogisticaController()),
          prov.ChangeNotifierProvider(create: (_) => AvisoSalidaController()),
          prov.ChangeNotifierProvider(
              create: (_) => CambioDePuestoController()),
          prov.ChangeNotifierProvider(create: (_) => AusenciasController()),
          prov.ChangeNotifierProvider(create: (_) => TurnoExtraController()),
          prov.ChangeNotifierProvider(create: (_) => ActivitiesController()),
          prov.ChangeNotifierProvider(create: (_) => EncuestasController()),
          prov.ChangeNotifierProvider(create: (_) => EvaluacionesController()),
          prov.ChangeNotifierProvider(
              create: (_) => CapacitacionesController()),
          prov.ChangeNotifierProvider(create: (_) => SugerenciasController()),
          prov.ChangeNotifierProvider(
              create: (_) => ActividadesAsignadasController()),
          prov.ChangeNotifierProvider(create: (_) => BitacoraController()),
          prov.ChangeNotifierProvider(create: (_) => ResidentesController()),
          prov.ChangeNotifierProvider(
              create: (_) => GestionDocumentalController()),

          //**********NUEVOS************//
          prov.ChangeNotifierProvider(create: (_) => NuevoPermisoController()),
          prov.ChangeNotifierProvider(
              create: (_) => NuevoTurnoExtraController()),

          prov.ChangeNotifierProvider(
              create: (_) => CierreBitacoraController()),
        ],
        child: prov.Consumer<ThemeApp>(
          builder: (_, valueTheme, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              //  CONFIGURACION PARA EL DATEPICKER
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'), // English, no country code
                Locale('es', 'ES'), // Hebrew, no country code
              ],
              // theme: ThemeData(
              //   brightness: Brightness.light,
              //   // primarySwatch: Color(00),
              //   primaryColor: _user.getUsuarioInfo!.colorPrimario!,
              //   // visualDensity: VisualDensity.adaptivePlatformDensity,
              // ),

              //==== AGREGO EL TEMA ====//
              theme: valueTheme.themeData,
//============================//
              // initialRoute: 'prueba',

              initialRoute: 'splash',

              routes: appRoutes,
              navigatorKey: homeController.navigatorKey,
              scaffoldMessengerKey: NotificatiosnService.messengerKey,
            );
          },
        ));
  }
}
