import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class GrReportScreen extends StatefulWidget {
  static String routeName = "GrReportScreen";

  const GrReportScreen({super.key});

  @override
  State<GrReportScreen> createState() =>
      _GrReportScreenState();
}

class _GrReportScreenState extends State<GrReportScreen> {
  @override
  void initState() {
    super.initState();
    GrProvider provider =
    Provider.of<GrProvider>(context, listen: false);
    provider.nestedTable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'GR Report')),
              body: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child:provider.table),
                ),
              ),
            )),
      );
    });
  }
}
