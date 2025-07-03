import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/edit_user_profile.dart';
import 'package:flutter_application_1/screens/auth/login.dart';
import 'package:flutter_application_1/screens/auth/register.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/loading/initial_start.dart';
import 'package:flutter_application_1/screens/maps/store_map.dart';
import 'package:flutter_application_1/screens/stores/all_stores.dart';
import 'package:flutter_application_1/screens/stores/favorite_stores.dart';
import 'package:flutter_application_1/screens/user_profile.dart';
import 'package:flutter_application_1/utilities/services/auth.dart';
import 'package:flutter_application_1/utilities/services/stores.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(
            create: (context) => StoreProvider(Provider.of<Auth>(context,listen: false)))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
        // brightness: Brightness.dark,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const InitialLoadingScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/home": (context) => const HomeScreen(),
        "/stores": (context) => const StoresScreen(),
        "/stores_map": (context) => const StoresMapScreen(stores: [],),
        "/favorite_stores": (context) => const FavoriteStoresScreen(),
        "/user_profile": (context) => const UserProfileScreen(),
        "/edit_user_profile": (context) => const EditUserProfileScreen(),
      },
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
    );
  }
}
