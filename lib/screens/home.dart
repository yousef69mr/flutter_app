import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/utilities/formatter.dart';
import '/utilities/services/api_config.dart';
import '/utilities/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        title: const Text(
          'User Home',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: const SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Text(
                'home page',
                style: TextStyle(color: Colors.grey),
              ))),
      drawer: Drawer(
          backgroundColor: Colors.grey[900],
          child: Consumer<Auth>(
            builder: (context, auth, child) {
              if (!auth.authenticated) {
                return ListView(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("/stores");
                      },
                      leading: const Icon(
                        Icons.store,
                        color: Colors.amberAccent,
                      ),
                      title: const Text(
                        "stores",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      leading: const Icon(
                        Icons.login,
                        color: Colors.amberAccent,
                      ),
                      title: const Text(
                        "login",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                );
              }

              String? profileImage = auth.user!.avatar != null
                  ? '${ApiConfig.baseUrl}${auth.user!.avatar}'
                  : null;

              return ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/user_profile");
                    },
                    child: DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                profileImage != null && profileImage.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            profileImage.toString()),
                                        radius: 40,
                                      )
                                    : genderImageWidget(auth.user?.gender,
                                        radius: 40),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    auth.user!.name,
                                    style: const TextStyle(
                                        color: Colors.amberAccent),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(auth.user!.studentId,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.grade,
                                        color: Colors.amberAccent,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${auth.user!.level}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed("/stores");
                    },
                    leading: const Icon(
                      Icons.store,
                      color: Colors.amberAccent,
                    ),
                    title: const Text(
                      "stores",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      try {
                        auth.logout();

                        if (mounted) {
                          Navigator.pushReplacementNamed(context, "/login");
                        }
                      } catch (e) {
                        if (mounted) {
                          Fluttertoast.showToast(
                            msg: '$e',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "logout",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
