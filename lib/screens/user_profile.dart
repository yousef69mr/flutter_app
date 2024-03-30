import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/formatter.dart';
import '../utilities/services/auth.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: UserProfileScreen(),
//   ));
// }

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.amberAccent,
          ),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Consumer<Auth>(builder: (context, auth, child) {
        if (!auth.authenticated) {
          return const Center(
            child: Text('No User Profile found'),
          );
        }
        String? image = auth.user!.avatar;
        String? gender = auth.user!.gender;
        // print(typeof image);
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: image != null && image.isEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(image.toString()),
                          radius: 50,
                        )
                      : const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile-default.jpg"),
                          radius: 50,
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    auth.user!.studentId,
                    style: const TextStyle(
                      letterSpacing: 1,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Divider(
                  height: 60.0,
                  color: Colors.grey,
                ),
                Text(
                  auth.user!.role,
                  style: const TextStyle(
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  auth.user!.name,
                  style: const TextStyle(
                      letterSpacing: 2,
                      color: Colors.amberAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.email,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      auth.user!.email,
                      style: const TextStyle(
                          letterSpacing: 1, fontSize: 18, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      auth.user!.level.toString(),
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                genderWidget(gender),
              ]),
        );
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: "edit profile",
        onPressed: () {
          Navigator.restorablePushNamed(context, "/edit_user_profile");
        },
        backgroundColor: Colors.amberAccent,
        child: const Icon(
          Icons.edit,
          size: 29,
          color: Colors.black,
        ),
      ),
    );
  }
}
