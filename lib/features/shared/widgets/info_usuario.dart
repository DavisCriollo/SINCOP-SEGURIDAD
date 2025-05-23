import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/features/shared/provider/provider_initial.dart';
import 'package:nseguridad/features/shared/utils/responsive.dart';

class InfoUsuario extends ConsumerWidget {
  const InfoUsuario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoUser = ref.watch(userProvider);
    Responsive size = Responsive.of(context);
    return Container(
        width: size.wScreen(100.0),
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('${infoUser!.user.rucempresa!}  ',
                style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(1.5),
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold)),
            Text('-',
                style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(1.5),
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            Text('  ${infoUser!.user.usuario!} ',
                style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(1.5),
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold)),
          ],
        ));
  }
}
