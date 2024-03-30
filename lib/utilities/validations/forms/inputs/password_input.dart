import 'index.dart';

String? passwordValidate(value) {
  String? message = requiredValidate(value);
  if (message != null) {
    return message;
  }
  if (value.toString().length < 8) {
    return "Enter at least 8 characters ";
  }

  return null;
}
