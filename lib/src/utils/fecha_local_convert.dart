import 'package:intl/intl.dart';

class DateUtility {
  static String fechaLocalConvert(String fecha) {
    if (fecha.isNotEmpty) {
      DateTime utcDateTime = DateTime.parse(fecha);
      DateTime localDateTime = utcDateTime.toLocal();
      String fechaLocal = DateFormat('yyyy-MM-dd HH:mm').format(localDateTime);
      return fechaLocal;
    } else {
      return '';
    }
  }
}
