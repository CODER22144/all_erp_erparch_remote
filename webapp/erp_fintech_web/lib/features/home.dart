import 'package:fintech_new_web/features/common/widgets/navbar.dart';
import 'package:flutter/material.dart';

import 'attendence/attendence.dart';
import 'common/widgets/comman_appbar.dart';

class HomePageScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedPage = 0;
  List<Function> attendanceProcess = [checkIn, checkOut];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        drawer: const SidebarNavigationMenu(),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Home')),
        body: SizedBox(
          child: Image.asset(
            'assets/erp.png',
            width: double.infinity,
          ),
        ),
      )),
    );
  }
}
