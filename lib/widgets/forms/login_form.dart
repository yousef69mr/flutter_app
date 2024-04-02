import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/email_input.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/password_input.dart';

import 'package:flutter_application_1/widgets/forms/inputs/text_input.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/utilities/services/auth.dart';

import 'inputs/password_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  late FToast _fToast;

  @override
  void initState() {
    super.initState();

    _fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    _fToast.init(context);
  }

  //used to free memory taken like destructor
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    Map<String, dynamic> credentials = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "device_name": "mobile",
    };

    // print(credentials);

    if (_formKey.currentState?.validate() == true) {
      try {
        setState(() {
          _isSubmitting = true;
        });
        Auth auth = Provider.of<Auth>(context, listen: false);
        await auth.login(credentials: credentials);

        // if (auth.user != null) {
          Fluttertoast.showToast(
            msg: 'logged successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (mounted) {
            Navigator.popAndPushNamed(context, '/home');
          }
        // }
      } catch (e) {
        // Request failed due to an error
        Fluttertoast.showToast(
          msg: '$e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          textField(
            fieldController: _emailController,
            fieldValidate: emailValidate,
            icon: Icons.email,
            label: "Email",
            placeholder: "studentID@stud.fci-cu.edu.eg",
            enabled: !_isSubmitting,
          ),
          const SizedBox(
            height: 10,
          ),
          PasswordField(
            controller: _passwordController,
            validator: passwordValidate,
            label: "Password",
            enabled: !_isSubmitting,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: !_isSubmitting
                  ? TextButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                    )
                  : TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
              onPressed: _isSubmitting ? null : onSubmit,
              child: !_isSubmitting
                  ? const Text(
                      "login",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "loading...",
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SpinKitDoubleBounce(
                          color: Colors.amberAccent,
                          size: 30.0,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
