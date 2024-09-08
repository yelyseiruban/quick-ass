import 'dart:developer';

String? passwordController;
String? confirmPasswordController;

String? passwordValidator(value) {
  RegExp regex = RegExp(r'^.{8,}$');
  if (value!.isEmpty) {
    return ("Password is required for login");
  }
  if (!regex.hasMatch(value)) {
    return ("Enter Valid Password(Min. 8 Character)");
  }
  passwordController = value;
  if (confirmPasswordController != null) {
    confirmPasswordValidator(confirmPasswordController);
  }
  return null;
}

String? confirmPasswordValidator(value) {
  log("i am success $value $passwordController");
  confirmPasswordController = value;
  if (value != passwordController) {
    return "Password don't match $value $passwordController";
  }
  log("i am not success $value");

  return null;
}

String? ethereumAddress(String address) {
  String regexPattern = r'([a-zA-Z0-9_]+):?(0x[a-fA-F0-9]{40})';
  RegExp regex = RegExp(regexPattern);
  Match? match = regex.firstMatch(address);

  if (match != null) {
    String publicAddress = match.group(2)!;

    return publicAddress;
  } else {
    log('No Ethereum address found in the URI.');
    return null;
  }
}
