import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final String titleName;

  const Navbar({super.key, required this.titleName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.amberAccent,
        ),
      ),
      title: Text(
        titleName, // Removed `const` here
        style: const TextStyle(color: Colors.grey),
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[850],
      elevation: 0,
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
