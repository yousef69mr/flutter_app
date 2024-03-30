import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/utilities/constants/options.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/email_input.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/name_input.dart';
import 'package:flutter_application_1/widgets/forms/inputs/text_input.dart';
import 'package:flutter_application_1/widgets/forms/password_confirmation_form.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/utilities/services/auth.dart';
import '../../utilities/validations/forms/inputs/index.dart';
import 'inputs/radio_input.dart';
import 'inputs/select_input.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  //used to free memory taken like destructor
  @override
  void dispose() async {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _genderController.dispose();
    _levelController.dispose();
    _studentIdController.dispose();
  }

  void onSubmit() async {
    Map<String, dynamic> userData = {
      "email": _emailController.text,
      "name": _nameController.text,
      "password": _passwordController.text,
      "studentId": _studentIdController.text,
      "level": int.parse(_levelController.text),
      "gender": _genderController.text,
      "device_name": "mobile",
    };
    if (_formKey.currentState?.validate() == true) {
      Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.register(userData: userData);

      if (auth.user != null) {
        Fluttertoast.showToast(
          msg: 'user created successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
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
              fieldController: _nameController,
              fieldValidate: nameValidate,
              label: "Username",
              placeholder: "john doe",
              icon: Icons.person),
          const SizedBox(
            height: 10,
          ),
          textField(
              fieldController: _emailController,
              fieldValidate: (value) {
                return studentEmailValidate(value, _studentIdController.text);
              },
              label: "Email",
              placeholder: "studentID@stud.fci-cu.edu.eg",
              icon: Icons.email),
          const SizedBox(
            height: 10,
          ),
          textField(
              fieldController: _studentIdController,
              fieldValidate: (value) => minLengthValidate(value, 5),
              label: "Student Id",
              placeholder: "20190666",
              icon: Icons.assignment_ind),
          const SizedBox(
            height: 10,
          ),
          ConfirmPasswordForm(
            passwordController: _passwordController,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: RadioField(
                  label: "Gender",
                  radioController: _genderController,
                  radioOptions: genders,
                ),
              ),
              Expanded(
                flex: 1,
                child: SelectField<int>(
                  label: 'level',
                  placeholder: 'select level',
                  selectController: _levelController,
                  selectOptions: levels,
                  defaultValue: levels[0].value,
                  validator: requiredValidate,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                ),
                onPressed: onSubmit,
                child: const Text(
                  "register",
                  style: TextStyle(color:Colors.black,fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
