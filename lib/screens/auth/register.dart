import 'package:flutter/material.dart';

import 'package:flutter_application_1/widgets/forms/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(

          children: <Widget>[
            const Text(
              "Empowerment Begins Here",
              textAlign:TextAlign.center,
              style: TextStyle(color: Colors.amberAccent, fontSize: 28 ),
            ),
            const Text(
              "Join Us and Register to Unleash Your Potential",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 18,),
            ),
            const SizedBox(
              height: 20,
            ),
            const RegisterForm(),
            const Divider(
              height: 40,
              color: Colors.amberAccent,
            ),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account ?",
                  textAlign:TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
}
