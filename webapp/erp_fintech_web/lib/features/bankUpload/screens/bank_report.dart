import 'package:fintech_new_web/features/bankUpload/provider/bank_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/widgets/comman_appbar.dart';

class BankReport extends StatefulWidget {
  static String routeName = "BankReport";

  const BankReport({super.key});

  @override
  State<BankReport> createState() => _BankReportState();
}

class _BankReportState extends State<BankReport> {
  @override
  void initState() {
    super.initState();
    BankProvider provider =
    Provider.of<BankProvider>(context, listen: false);
    provider.getBankStatements(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BankProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Bank Statements')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Trans. ID")),
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("Trans. Date")),
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("Reference Number")),
                        DataColumn(label: Text("Value Date")),
                        DataColumn(label: Text("Withdrawal")),
                        DataColumn(label: Text("Deposit")),
                        DataColumn(label: Text("Bank Code")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Post Method")),
                        DataColumn(label: Text("Narration")),
                      ],
                      rows: provider.rows,
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
