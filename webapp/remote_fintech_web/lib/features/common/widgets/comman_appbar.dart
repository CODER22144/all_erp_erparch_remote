import 'package:fintech_new_web/features/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  const CommonAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return AppBar(
      title: Text(title),
      leading: (Navigator.canPop(context) && currentRoute != HomePageScreen.routeName)
          ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          })
          : null,
      backgroundColor: Colors.lightBlueAccent,
    );
  }
}
