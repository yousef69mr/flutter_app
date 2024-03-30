import 'index.dart';

String? nameValidate(value) {
  String? message = requiredValidate(value);
  if (message != null) {
    return message;
  }
  return null;
}
