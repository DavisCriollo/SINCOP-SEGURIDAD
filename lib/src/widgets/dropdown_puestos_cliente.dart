import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/controllers/multas_controller.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class DropMenuPuestosClientes extends StatelessWidget {
  final List data;
  final String? hinText;

  const DropMenuPuestosClientes({super.key, required this.data, this.hinText});

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final puestosCliente =
        Provider.of<MultasGuardiasContrtoller>(context, listen: true);
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
          value: puestosCliente.labelPuestosCliente,
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(1.7),
              color: Colors.black87,
              fontWeight: FontWeight.normal),
          items: getOptions(),
          onChanged: (value) {
            //final labeltipoDocumento =
            Provider.of<MultasGuardiasContrtoller>(context, listen: false)
                .setLabelPuestosCliente(value.toString());
            // print(labeltipoDocumento);
          },
        ),
      ),
    );
  }
}
