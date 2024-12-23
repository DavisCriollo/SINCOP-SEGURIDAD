import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ViewsPDFs extends StatelessWidget {
  final String infoPdf;
  final String labelPdf;

  const ViewsPDFs({super.key, required this.infoPdf, required this.labelPdf});

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final ctrlTheme = context.read<ThemeApp>();

    return SafeArea(
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
            'Vista PDF',
            // style: Theme.of(context).textTheme.headline2,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.download_outlined,
                size: size.iScreen(3.5),
                color: Colors.white,
              ),
              onPressed: () async {
                downloadAndOpenPDF(infoPdf);
              },
            ),
          ],
        ),
        body: Container(
          width: size.wScreen(100),
          height: size.hScreen(100),
          padding: EdgeInsets.symmetric(
              horizontal: size.iScreen(1.0), vertical: size.iScreen(1.0)),
          color: Colors.grey[300],
          child:
              // SfPdfViewer.network(
              //   infoPdf,
              //   canShowScrollHead: true,
              //   canShowScrollStatus: true
              // ),
              // TODO: FCODEV SE CAMBIO DE PAQUETE
              const PDF().cachedFromUrl(infoPdf),
        ),
      ),
    );
  }

  Future<void> downloadAndOpenPDF(String pdfUrl) async {
    // Obtiene el directorio temporal del dispositivo
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Verifica si se puede escribir en el directorio temporal
    bool canWrite = await Directory(tempPath).exists();
    if (!canWrite) {
      print('No se puede escribir en el directorio temporal.');
      return;
    }

    // Descarga el PDF
    String pdfFileName = pdfUrl.split('/').last;
    String pdfPath = '$tempPath/$pdfFileName';
    Dio dio = Dio();
    try {
      await dio.download(pdfUrl, pdfPath);
    } catch (e) {
      print('Error al descargar PDF: $e');
      return;
    }

    // Abre el PDF descargado
    try {
      await OpenFile.open(pdfPath);
    } catch (e) {
      print('Error al abrir PDF: $e');
    }
  }
}
