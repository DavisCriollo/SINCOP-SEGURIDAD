import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/aviso_salida_controller.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class DropMenuAvisoSalida extends StatelessWidget {
  final List data;
  final String? hinText;

  const DropMenuAvisoSalida({super.key, required this.data, this.hinText});

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final estadoCompra =
        Provider.of<AvisoSalidaController>(context, listen: true);
    List<DropdownMenuItem<String>> getOptions() {
      List<DropdownMenuItem<String>> menu = [];
      for (var item in data) {
        menu.add(DropdownMenuItem(
          value: item,
          child: Center(child: Text(item, textAlign: TextAlign.center)),
          //item,
        ));
      }
      return menu;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.iScreen(2.0), vertical: size.iScreen(0)),
      width: size.wScreen(100),
      child: Container(
        alignment: Alignment.centerLeft,
        child: DropdownButton(
          isExpanded: true,
          hint: Text(hinText!,
              // estadoCompra.tipoDoc.toString(),
              style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(1.8),
                // fontWeight: FontWeight.w500,
                color: Colors.black45,
              )),
          value: estadoCompra.labelAvisoSalida,
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(1.7),
              color: Colors.black87,
              fontWeight: FontWeight.normal),
          items: getOptions(),
          onChanged: (value) {
            //final labeltipoDocumento =
            Provider.of<AvisoSalidaController>(context, listen: false)
                .setLabelAvisoSalida(value.toString());
            // print(labeltipoDocumento);
          },
        ),
      ),
    );
  }
}
