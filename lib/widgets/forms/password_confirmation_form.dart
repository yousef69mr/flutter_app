import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/password_input.dart';
import 'package:flutter_application_1/widgets/forms/inputs/password_input.dart';

class ConfirmPasswordForm extends StatefulWidget {
  final TextEditingController passwordController;
  final bool enabled;

  const ConfirmPasswordForm({
    super.key,
    required this.passwordController,
    required this.enabled,
  });

  @override
  State<ConfirmPasswordForm> createState() => _ConfirmPasswordFormState();
}

class _ConfirmPasswordFormState extends State<ConfirmPasswordForm> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // String? _password;
  // String? _confirmPassword;

  @override
  void initState() {
    super.initState();
    // widget.passwordController.addListener(_validatePassword);
    // _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // void _validatePassword() {
  //   setState(() {
  //     _password = widget.passwordController.text;
  //     _confirmPassword = _confirmPasswordController.text;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PasswordField(
          controller: widget.passwordController,
          validator: passwordValidate,
          label: "Password",
          enabled: widget.enabled,
        ),
        const SizedBox(height: 10),
        PasswordField(
          controller: _confirmPasswordController,
          validator: (value) {
            String? message = passwordValidate(value);
            if (message == null) {
              if (value != widget.passwordController.text) {
                return "Passwords do not match!";
              }
            }
            return message;
          },
          enabled: widget.enabled,
          label: "Confirm password",
        ),
        const SizedBox(
          height: 5,
        ),
        // if (_confirmPassword != null && _password != null)
        //   _password == _confirmPassword && _password!.isNotEmpty
        //       ? const Text(
        //           'Passwords match!',
        //           style: TextStyle(color: Colors.green),
        //         )
        //       : const Text(
        //           'Passwords do not match!',
        //           style: TextStyle(color: Colors.red),
        //         ),
      ],
    );
  }
}
