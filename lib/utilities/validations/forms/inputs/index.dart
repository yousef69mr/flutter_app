String? requiredValidate(value) {
  if (value == null || value.isEmpty) {
    return "this field is required";
  }
  return null;
}

String? minLengthValidate(value, int min) {
  String? message = requiredValidate(value);
  if (message == null) {
    if (value.toString().length < min) {
      return "$min characters at least";
    }
  }
  return message;
}
