import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/forms/login_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../utilities/services/auth.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (BuildContext context, auth, Widget? child) {
      // Using FutureBuilder to handle asynchronous operations
      return FutureBuilder(
          future: auth.initial(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Auth initialization is complete
              if (auth.authenticated) {
                // If user is already logged in, navigate to home screen
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/home');
                });
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });

            } else {
              // Show a loading indicator while initializing
              return Scaffold(
                backgroundColor: Colors.grey[900],
                body: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitSpinningLines(
                          color: Colors.amberAccent,
                          size: 120.0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Loading...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            auth.initial();
            if (auth.authenticated) {
              // If user is already logged in, navigate to home screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/home');
              });
            }
            return Scaffold(
              backgroundColor: Colors.grey[900],
              body: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitSpinningLines(
                        color: Colors.amberAccent,
                        size: 120.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Loading...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
      //
    });
  }
}
