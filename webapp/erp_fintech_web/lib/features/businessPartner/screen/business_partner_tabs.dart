import 'package:fintech_new_web/features/businessPartner/screen/business_partner.dart';
import 'package:flutter/material.dart';

import '../../bpDocument/screen/bp_document.dart';
import '../../bpPayNTaxInfo/screen/bpTaxInfo.dart';
import '../../businessPartnerAddress/screen/business_partner_address.dart';
import '../../businessPartnerContact/screen/business_partner_contact.dart';
import '../../common/widgets/comman_appbar.dart';

class BusinessPartnerTabs extends StatefulWidget {
  static String routeName = "/businessPartnerTabs";
  const BusinessPartnerTabs({super.key});

  @override
  State<BusinessPartnerTabs> createState() => _BusinessPartnerTabsState();
}

class _BusinessPartnerTabsState extends State<BusinessPartnerTabs>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const CommonAppbar(title: 'Business Partner')),
      body: Column(
        children: [
          TabBar(
              controller: tabController,
              labelColor: Colors.lightBlue,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: 'Business Partner'),
                Tab(text: 'Pay & Tax Info'),
                Tab(text: 'Address'),
                Tab(text: 'Contact'),
                Tab(text: 'Document')
              ]),
          Expanded(
            child: TabBarView(controller: tabController, children: const [
              BusinessPartner(),
              BusinessPartnerTaxInfo(),
              BusinessPartnerAddress(),
              BusinessPartnerContact(),
              BusinessPartnerDocument()
            ]),
          )
        ],
      ),
    );
  }
}
