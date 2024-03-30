import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constants/options.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/email_input.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/name_input.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/password_input.dart';
import 'package:flutter_application_1/widgets/forms/inputs/password_input.dart';
import 'package:flutter_application_1/widgets/forms/inputs/text_input.dart';
import 'package:flutter_application_1/widgets/forms/password_confirmation_form.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/utilities/services/auth.dart';
import '/models/user.dart';
import '/utilities/validations/forms/inputs/index.dart';
import 'inputs/image_input.dart';
import 'inputs/radio_input.dart';
import 'inputs/select_input.dart';

class EditUserProfileForm extends StatefulWidget {
  final User user;

  const EditUserProfileForm({super.key, required this.user});

  @override
  State<EditUserProfileForm> createState() => _EditUserProfileFormState();
}

class _EditUserProfileFormState extends State<EditUserProfileForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  User get activeUser => widget.user;

  @override
  void initState() {
    _genderController.text = activeUser.gender ?? "";
    _levelController.text = activeUser.level.toString();
    _studentIdController.text = activeUser.studentId;
    _profileImageController.text = activeUser.avatar ?? "";
    _emailController.text = activeUser.email;
    _nameController.text = activeUser.name;

    super.initState();
  }

  //used to free memory taken like destructor
  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _genderController.dispose();
    _levelController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    Map<String, dynamic> userData = {
      "email": _emailController.text,
      "name": _nameController.text,
      "password": _passwordController.text,
      "studentId": _studentIdController.text,
      "level": int.parse(_levelController.text),
      "gender": _genderController.text,
      "device_name": "mobile",
    };

    // print(userData);
    try {
      if (_formKey.currentState?.validate() == true) {
        Auth auth = Provider.of<Auth>(context, listen: false);
        await auth.updateUser(userData: userData);

        if (auth.user != null) {
          Fluttertoast.showToast(
            msg: 'updated successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ImageField(
            imageUrl: _profileImageController.text,
          ),
          const SizedBox(
            height: 30,
          ),
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
              fieldValidate: (value) =>
                  studentEmailValidate(value, _studentIdController.text),
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

          ConfirmPasswordForm(passwordController: _passwordController),
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
                    defaultValue: _genderController.text),
              ),
              Expanded(
                flex: 1,
                child: SelectField<int>(
                  label: 'level',
                  placeholder: 'select level',
                  selectController: _levelController,
                  selectOptions: levels,
                  defaultValue: int.parse(_levelController.text),
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
                  "save",
                  style: TextStyle(color: Colors.black,fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
