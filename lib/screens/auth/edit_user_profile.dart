import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utilities/services/auth.dart';
import '/widgets/forms/edit_profile_form.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.amberAccent,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (auth.user != null) {
              return Center(
                child: ListView(
                  children: <Widget>[
                    EditUserProfileForm(
                      user: auth.user!,
                    ),
                  ],
                ),
              );
            }
            return const Center(
                child: Text(
              "No user found",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ));
          },
        ),
      ),
    );
  }
}
