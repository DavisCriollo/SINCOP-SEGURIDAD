import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:webview_flutter/webview_flutter.dart';

const url =
    "https://flutter.dev/?gclid=EAIaIQobChMIsqeSpbDz9gIV4oFbCh0EhwTZEAAYASAAEgKPXvD_BwE&gclsrc=aw.ds";

class ViewPDFPage extends StatefulWidget {
  // final dynamic pedido;
  const ViewPDFPage({
    super.key,
    // required this.pedido
  });

  @override
  State<ViewPDFPage> createState() => _ViewPDFPageState();
}

class _ViewPDFPageState extends State<ViewPDFPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        // backgroundColor: primaryColor,
        title: Text(
          'Reporte PDF',
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(2.45),
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0XFF153E76),
                Color(0XFF0076A7),

                // Color(0XFF005B97),
                // Color(0XFF0075BE),
                // Color(0XFF1E9CD7),
                // Color(0XFF3DA9F4),
              ],
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: size.wScreen(100.0),
        height: size.hScreen(100),
        // color:Colors.red,
        child: WebViewWidget(
          //  initialUrl: "https://backsigeop.neitor.com/api/reportes/pedido?disId=${widget.pedido['disId']}&rucempresa=${widget.pedido['disEmpresa']}",
          //  initialUrl: "https://backsigeop.neitor.com/api/reportes/carnet?perId=1042&rucempresa=PAZVISEG",

          controller: _webViewController,
          //  javascriptMode:JavascriptMode.unrestricted,
        ),
      ),
    );
  }

// Future<void> downloadAndOpenPDF(String pdfUrl) async {
//   // Obtiene el directorio temporal del dispositivo
//   Directory tempDir = await getTemporaryDirectory();
//   String tempPath = tempDir.path;

//   // Verifica si se puede escribir en el directorio temporal
//   bool canWrite = await Directory(tempPath).exists();
//   if (!canWrite) {
//     print('No se puede escribir en el directorio temporal.');
//     return;
//   }

//   // Descarga el PDF
//   String pdfFileName = pdfUrl.split('/').last;
//   String pdfPath = '$tempPath/$pdfFileName';
//   Dio dio = Dio();
//   try {
//     await dio.download(pdfUrl, pdfPath);
//   } catch (e) {
//     print('Error al descargar PDF: $e');
//     return;
//   }

//   // Abre el PDF descargado
//   try {
//     await OpenFile.open(pdfPath);
//   } catch (e) {
//     print('Error al abrir PDF: $e');
//   }
// }
}
