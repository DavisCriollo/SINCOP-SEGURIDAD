bool isValidEmail(String value) {
  
    const emailRegex =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    return RegExp(emailRegex).hasMatch(value);
  }

  String removeNULCedula(String input) {
  if (input.contains("NUL")) {
    return input.replaceFirst("NUL", "");
  } else {
    return input;
  }
}
bool validarCorreoElectronico(String correo) {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return regex.hasMatch(correo);
  }