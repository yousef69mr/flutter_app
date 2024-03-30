import 'index.dart';

String? studentEmailValidate(value, studentId) {
  String studentEmailDomain = "stud.fci-cu.edu.eg";
  String? message = requiredValidate(value);
  if (message != null) {
    return message;
  }
  final RegExp regex =
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  List<String> sections = value.toString().split('@');

  if (!(sections[1].toLowerCase() == studentEmailDomain)) {
    return "please enter valid student email format";
  }

  if (sections[0] != studentId) {
    return "student email must start with your ID";
  }

  return null;
}

String? emailValidate(value) {
  String? message = requiredValidate(value);
  if (message != null) {
    return message;
  }

  final RegExp regex =
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}
