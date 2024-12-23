import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/capacitaciones_controller.dart';
import 'package:nseguridad/src/controllers/evaluaciones_controller.dart';
import 'package:nseguridad/src/models/session_response.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/dialogs.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class CreaEvaluacion extends StatefulWidget {
  final Session? usuario;
  final String? action;
  final String? menu;
  const CreaEvaluacion({
    super.key,
    this.action,
    this.usuario,
    this.menu,
  });

  @override
  State<CreaEvaluacion> createState() => _CreaEvaluacionState();
}

class _CreaEvaluacionState extends State<CreaEvaluacion> {
  final List<TextEditingController> _controllersText = <TextEditingController>[];

  @override
  void initState() {
    final list =
        context.read<EvaluacionesController>().getListaPreguntasEvaluacion;

    for (var i = 0; i < list.length; i++) {
      _controllersText.add(TextEditingController());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final action = widget.action;
    final controller = context.read<EvaluacionesController>();
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
            title: const Text(
              'Realizar Evaluación',
              // style: Theme.of(context).textTheme.headline2,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: size.iScreen(1.5)),
                child: IconButton(
                    splashRadius: 28,
                    onPressed: () {
                      _onSubmit(size, context, controller, action.toString(),
                          widget.usuario);
                    },
                    icon: Icon(
                      Icons.save_outlined,
                      size: size.iScreen(4.0),
                    )),
              )
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
                key: controller.evaluacionesFormKey,
                child: Column(
                  children: [
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //***********************************************/
                    SizedBox(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Tema:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: size.iScreen(0.0)),
                      width: size.wScreen(100.0),
                      child: Text(
                        // 'item Novedad: ${controllerActividades.getItemMulta}',
                        '"${controller.getInfoEvaluacion!['docTitulo']}"',
                        textAlign: TextAlign.center,
                        //
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.3),
                            // color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.5),
                    ),
                    //***********************************************/
                    Container(
                      width: size.wScreen(100.0),
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Text('BANCO DE PREGUNTAS',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/

                    SizedBox(
                      height: size.hScreen(75),
                      child: ListView.builder(
                        // itemCount: _controller.getListaPreguntasEvaluacion.length,
                        itemCount: _controllersText.length,
                        itemBuilder: (BuildContext context, int index) {
                          final elemento =
                              controller.getListaPreguntasEvaluacion[index];
                          return elemento['tipoCampo'] == 'TEXTO'
                              ? _textItem(context, size, controller, elemento,
                                  _controllersText, index)
                              : elemento['tipoCampo'] == 'MULTIPLE LISTA'
                                  ? _multiSelectItem(context, size, controller,
                                      elemento, _controllersText, index)
                                  : elemento['tipoCampo'] == 'LISTA'
                                      ? _selectItem(context, size, controller,
                                          elemento, _controllersText, index)
                                      : elemento['tipoCampo'] == 'NUMERICO'
                                          ? _textItemNumerico(
                                              context,
                                              size,
                                              controller,
                                              elemento,
                                              _controllersText,
                                              index)
                                          : elemento['tipoCampo'] ==
                                                  'AREA TEXTO'
                                              ? _textAreaItem(
                                                  context,
                                                  size,
                                                  controller,
                                                  elemento,
                                                  _controllersText,
                                                  index)
                                              : elemento['tipoCampo'] ==
                                                      'PUNTAJE'
                                                  ? _selectItemPuntaje(
                                                      context,
                                                      size,
                                                      controller,
                                                      elemento,
                                                      _controllersText,
                                                      index)
                                                  : Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _textItem(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          child: Text('${elemento['pregunta']}:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        TextFormField(
          controller: control[index],
          decoration: const InputDecoration(
            isDense: true,
          ),
          textAlign: TextAlign.start,
          style: const TextStyle(),
          onChanged: (text) {},
          validator: (text) {
            if (text!.trim().isNotEmpty) {
              return null;
            } else {
              return 'Campo Obligatorio';
            }
          },
        ),
      ],
    );
  }

  Column _textItemNumerico(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        TextFormField(
          controller: control[index],
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: const InputDecoration(
            // suffixIcon: Icon(Icons.beenhere_outlined)
            isDense: true,
          ),
          textAlign: TextAlign.start,
          style: const TextStyle(),
          onChanged: (text) {},
          validator: (text) {
            if (text!.trim().isNotEmpty) {
              return null;
            } else {
              return 'Campo Obligatorio';
            }
          },
        ),
      ],
    );
  }

  Column _textAreaItem(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        TextFormField(
          controller: control[index],
          decoration: const InputDecoration(
            // suffixIcon: Icon(Icons.beenhere_outlined)
            isDense: true,
          ),
          textAlign: TextAlign.start,
          minLines: 1,
          maxLines: 2,
          style: const TextStyle(),
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(
                RegExp("[a-zA-Z0-9@#-+,.{" "}\\s]")),
          ],
          onChanged: (text) {
            // ausenciaController.onDetalleChange(text);
          },
          validator: (text) {
            if (text!.trim().isNotEmpty) {
              return null;
            } else {
              return 'Campo Obligatorio';
            }
          },
        ),
      ],
    );
  }

  Column _multiSelectItem(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        Row(
          children: [
            SizedBox(
              width: size.wScreen(80.0),
              // color: Colors.blue,
              child: TextFormField(
                controller: control[index],
                decoration: const InputDecoration(
                    // suffixIcon: Icon(Icons.beenhere_outlined)
                    ),
                textAlign: TextAlign.start,
                readOnly: true,
                style: const TextStyle(),
                onChanged: (text) {},
                validator: (text) {
                  if (text!.trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Campo Obligatorio';
                  }
                },
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(onTap: () {
                final data = elemento['opcionesLista'];
                _modalSeleccionaMultiselect(
                    context, size, data, index, control);
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
      ],
    );
  }

  Column _multiSelectOk(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    List<String> opciones = ['Opción 1', 'Opción 2', 'Opción 3'];
    List<String> seleccionados = [];
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}: ',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        Row(
          children: [
            SizedBox(
                width: size.wScreen(80.0),
                // color: Colors.blue,
                child: DropdownButtonFormField(
                  value: seleccionados,
                  items: opciones.map((opcion) {
                    return DropdownMenuItem(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      seleccionados.add(value.toString());
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Selecciona una o varias opciones',
                    border: OutlineInputBorder(),
                  ),
                )),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(onTap: () {
                final data = elemento['opcionesLista'];
                _modalSeleccionaMultiselect(
                    context, size, data, index, control);
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
      ],
    );
  }

  Column _selectItem(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        Row(
          children: [
            SizedBox(
              width: size.wScreen(80.0),
              // color: Colors.blue,
              child: TextFormField(
                controller: control[index],
                decoration: const InputDecoration(
                  // suffixIcon: Icon(Icons.beenhere_outlined)
                  isDense: true,
                  //  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: size.iScreen(1.0)),
                ),
                readOnly: true,
                textAlign: TextAlign.start,
                style: const TextStyle(),
                onChanged: (text) {},
                validator: (text) {
                  if (text!.trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Campo Obligatorio';
                  }
                },
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(onTap: () {
                final data = elemento['opcionesLista'];
                _modalSeleccionaLista(context, size, data, index, control);
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
      ],
    );
  }

  Column _selectItemPuntaje(
      BuildContext context,
      Responsive size,
      EvaluacionesController controller,
      dynamic elemento,
      List<TextEditingController> control,
      int index) {
    return Column(
      children: [
        //***********************************************/
        SizedBox(
          height: size.iScreen(1.0),
        ),
        //*****************************************/
        SizedBox(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('${elemento['pregunta']}: ',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        Row(
          children: [
            SizedBox(
              width: size.wScreen(80.0),
              // color: Colors.blue,
              child: TextFormField(
                controller: control[index],
                decoration: const InputDecoration(
                  isDense: true,
                ),
                readOnly: true,
                textAlign: TextAlign.start,
                style: const TextStyle(),
                onChanged: (text) {},
                validator: (text) {
                  if (text!.trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Campo Obligatorio';
                  }
                },
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(onTap: () {
                final data = elemento['opcionesLista'];
                _modalSeleccionaSelectPuntaje(
                    context, size, data, index, control);
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
      ],
    );
  }

  void _showAlertGuardaEvaluacion(Responsive size,
      EvaluacionesController controller, Map<String, dynamic> dataSend) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text('¿Desea enviar la Evaluación?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.lexendDeca(
                      fontSize: size.iScreen(1.8),
                      // color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    ProgressDialog.show(context);

                    await controller.guardaEvaluacion(controller, dataSend);
                    ProgressDialog.dissmiss(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    widget.menu == 'NO'
                        ? Navigator.pop(context)
                        : const SizedBox();
                    context
                        .read<CapacitacionesController>()
                        .buscaListaCapacitaciones('');
                    widget.menu == 'SI'
                        ? controller.buscaEvaluaciones('', 'false')
                        : const SizedBox();
                  },
                  child: Text(
                    'Aceptar',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        // color: Colors.white,
                        fontWeight: FontWeight.normal),
                  )),
            ],
          );
        });
  }

  void _onSubmit(
      Responsive size,
      BuildContext context,
      EvaluacionesController controller,
      String? action,
      Session? user) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      final List listaPreguntasValue = [];

      for (var i = 0; i < controller.getListaPreguntasEvaluacion.length; i++) {
        listaPreguntasValue.addAll([
          {
            "pregunta": controller.getListaPreguntasEvaluacion[i]['pregunta'],
            "propiedad": controller.getListaPreguntasEvaluacion[i]['propiedad'],
            "tipoCampo": controller.getListaPreguntasEvaluacion[i]['tipoCampo'],
            "opcionesLista": controller.getListaPreguntasEvaluacion[i]
                ['opcionesLista'],
            "respuestas": controller.getListaPreguntasEvaluacion[i]
                ['respuestas'],
            "value": controller.getListaPreguntasEvaluacion[i]['tipoCampo'] ==
                    'MULTIPLE LISTA'
                ? _controllersText[i].text.split(',')
                : _controllersText[i].text,
            "orden": 0,
            "error": false
          }
        ]);
      }
      final dataSend = {
        "encId": controller.getInfoEvaluacion!['encId'],
        "encPerId": controller.getInfoEvaluacion!['encPerId'],
        "encDocId": controller.getInfoEvaluacion!['encDocId'],
        "encOption": controller.getInfoEvaluacion!['encOption'],
        "encEstado": controller.getInfoEvaluacion!['encEstado'],
        "encFecReg": controller.getInfoEvaluacion!['encFecReg'],
        "docTipo": controller.getInfoEvaluacion!['docTipo'],
        "docDestinatario": controller.getInfoEvaluacion!['docDestinatario'],
        "docTitulo": controller.getInfoEvaluacion!['docTitulo'],
        "docFechaEmision": controller.getInfoEvaluacion!['docFechaEmision'],
        "docFechaFinalizacion":
            controller.getInfoEvaluacion!['docFechaFinalizacion'],
        "docObligatorio": controller.getInfoEvaluacion!['docObligatorio'],
        "docEstado": "PROCESADO",
        "docPreguntas": listaPreguntasValue,
        "docEmpresa": controller.getInfoEvaluacion['docEmpresa'],
        "docUser": user!.usuario,
      };
    }
    _showAlertGuardaEvaluacion(size, controller, {});
  }

// ==============MODAL PARA MOSTRAL LOS MULTISELECT  ===========//

// ==============MODAL PARA MOSTRAL LOS MULTISELECT  ===========//
  void _modalSeleccionaMultiselect(BuildContext context, Responsive size,
      List data, int index, List<TextEditingController> controls) {
    final control = context.read<EvaluacionesController>();
    List<String> listTem = [];
    bool isSelect = false;
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
                      Text('SELECCIONAR ',
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          children: data
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      listTem.removeWhere((x) => x == e);
                                      listTem.add(e);
                                      controls[index].text =
                                          listTem.join(',');
                                    },
                                    child: Container(
                                      color: isSelect == true
                                          ? Colors.green
                                          : Colors.grey[200],
                                      width: size.wScreen(100),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(0.5)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(1.0)),
                                      child: Text(
                                        '$e',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // actions: [

              // ],
            ),
          );
        });
  }

  void _modalSeleccionaLista(BuildContext context, Responsive size, List data,
      int index, List<TextEditingController> controls) {
    final control = context.read<EvaluacionesController>();
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
                      Text('SELECCIONAR ',
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          children: data
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        controls[index].text = e;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.grey[200],
                                      width: size.wScreen(100),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(0.5)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(1.0)),
                                      child: Text(
                                        '$e',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // actions: [

              // ],
            ),
          );
        });
  }

  void _modalSeleccionaSelectPuntaje(BuildContext context, Responsive size,
      List data, int index, List<TextEditingController> controls) {
    final control = context.read<EvaluacionesController>();
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
                      Text('SELECCIONAR ',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          children: data
                              .map((x) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        controls[index].text = x;
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.grey[200],
                                      width: size.wScreen(100),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(0.5)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(1.0),
                                          vertical: size.iScreen(1.0)),
                                      child: Text(
                                        '$x',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // actions: [

              // ],
            ),
          );
        });
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
