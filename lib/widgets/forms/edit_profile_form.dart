import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constants/options.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/email_input.dart';
import 'package:flutter_application_1/utilities/validations/forms/inputs/name_input.dart';
import 'package:flutter_application_1/widgets/forms/inputs/text_input.dart';
import 'package:flutter_application_1/widgets/forms/password_confirmation_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/utilities/services/auth.dart';
import '/utilities/services/api_config.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  XFile? _profileImage;

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  User get activeUser => widget.user;

  String? _avatar;

  @override
  void initState() {
    _genderController.text = activeUser.gender ?? "";
    _levelController.text = activeUser.level.toString();
    _studentIdController.text = activeUser.studentId;
    _passwordController.text = activeUser.password;
    _emailController.text = activeUser.email;
    _nameController.text = activeUser.name;
    _avatar = activeUser.avatar != null
        ? '${ApiConfig.baseUrl}${activeUser.avatar}'
        : null;

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
    Map<String, String> userData = {
      "email": _emailController.text,
      "name": _nameController.text,
      "password": _passwordController.text,
      "studentId": _studentIdController.text,
      "level": _levelController.text,
      "gender": _genderController.text,
      "device_name": "mobile",
    };

    Map<String, List<XFile?>> userFiles = {
      "avatar": [_profileImage]
    };
    // print(userData);
    // print(_profileImage);
    try {
      if (_formKey.currentState?.validate() == true) {
        setState(() {
          _isSubmitting = true;
        });

        Auth auth = Provider.of<Auth>(context, listen: false);
        // await auth.updateUserProfileImage(image: _profileImage as File);
        await auth.updateUser(userData: userData, files: userFiles);

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
      // print(e);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
            defaultValue: _avatar,
            enabled: !_isSubmitting,
            onImageChanged: (XFile? newImage) {
              setState(() {
                _profileImage = newImage;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          textField(
            fieldController: _nameController,
            fieldValidate: nameValidate,
            label: "Username",
            placeholder: "john doe",
            icon: Icons.person,
            enabled: !_isSubmitting,
          ),
          const SizedBox(
            height: 10,
          ),
          textField(
            fieldController: _emailController,
            fieldValidate: (value) =>
                studentEmailValidate(value, _studentIdController.text),
            label: "Email",
            placeholder: "studentID@stud.fci-cu.edu.eg",
            icon: Icons.email,
            enabled: !_isSubmitting,
          ),
          const SizedBox(
            height: 10,
          ),
          textField(
            fieldController: _studentIdController,
            fieldValidate: (value) => minLengthValidate(value, 5),
            label: "Student Id",
            placeholder: "20190666",
            icon: Icons.assignment_ind,
            enabled: !_isSubmitting,
          ),
          const SizedBox(
            height: 10,
          ),
          ConfirmPasswordForm(
            passwordController: _passwordController,
            enabled: !_isSubmitting,
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
                  defaultValue: _genderController.text,
                  enabled: !_isSubmitting,
                ),
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
                  enabled: !_isSubmitting,
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
                      "save changes",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Saving...",
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SpinKitDoubleBounce(
                          color: Colors.amberAccent,
                          size: 30.0,
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
