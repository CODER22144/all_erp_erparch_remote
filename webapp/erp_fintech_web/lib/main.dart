import 'package:fintech_new_web/features/JVoucher/provider/journal_voucher_provider.dart';
import 'package:fintech_new_web/features/acGroups/provider/account_group_provider.dart';
import 'package:fintech_new_web/features/additionalOrder/provider/additional_order_provider.dart';
import 'package:fintech_new_web/features/advanceRequirement/provider/advance_requirement_provider.dart';
import 'package:fintech_new_web/features/attendence/provider/attendance_provider.dart';
import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'dart:js' as js;
import 'package:fintech_new_web/features/auth/screen/login.dart';
import 'package:fintech_new_web/features/bankUpload/provider/bank_provider.dart';
import 'package:fintech_new_web/features/billPayable/provider/bill_payable_provider.dart';
import 'package:fintech_new_web/features/billReceipt/provider/bill_receipt_provider.dart';
import 'package:fintech_new_web/features/billReceivable/provider/bill_receivable_provider.dart';
import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:fintech_new_web/features/bpShipping/provider/bp_shipping_provider.dart';
import 'package:fintech_new_web/features/businessPartner/provider/business_partner_provider.dart';
import 'package:fintech_new_web/features/businessPartner/provider/business_partner_search_provider.dart';
import 'package:fintech_new_web/features/businessPartnerOnBoard/provider/business_partner_on_board_provider.dart';
import 'package:fintech_new_web/features/businessPartnerProcessing/provider/bp_processing_provider.dart';
import 'package:fintech_new_web/features/carrier/provider/carrier_provider.dart';
import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/costResource/provider/cost_resource_provider.dart';
import 'package:fintech_new_web/features/crNote/provider/cr_note_provider.dart';
import 'package:fintech_new_web/features/debitNoteAgainstCreditNote/provider/db_note_against_cr_note_provider.dart';
import 'package:fintech_new_web/features/debitNoteDispatch/provider/debit_note_dispatch_provider.dart';
import 'package:fintech_new_web/features/dlChallan/provider/dl_challan_provider.dart';
import 'package:fintech_new_web/features/evOrder/provider/ev_order_provider.dart';
import 'package:fintech_new_web/features/exportOrder/provider/export_order_provider.dart';
import 'package:fintech_new_web/features/financialCreditNote/provider/financial_crnote_provider.dart';
import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/grIqsRep/provider/gr_iqs_rep_provider.dart';
import 'package:fintech_new_web/features/grOtherCharges/provider/gr_other_charges_provider.dart';
import 'package:fintech_new_web/features/grQtyClear/provider/gr_qty_clear_provider.dart';
import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:fintech_new_web/features/invenReq/provider/inven_req_provider.dart';
import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:fintech_new_web/features/jobWorkOutChallanClear/provider/job_work_out_challan_clear_provider.dart';
import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:fintech_new_web/features/ledger/provider/ledger_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/lineRejection/provider/line_rejection_provider.dart';
import 'package:fintech_new_web/features/manufacturing/provider/manufacturing_provider.dart';
import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/material/provider/material_rep_provider.dart';
import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:fintech_new_web/features/materialAssemblyTechDetails/provider/material_assembly_tech_details_provider.dart';
import 'package:fintech_new_web/features/materialClassification/provider/material_classification_provider.dart';
import 'package:fintech_new_web/features/materialIQS/provider/material_iqs_provider.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:fintech_new_web/features/materialReturn/provider/material_return_provider.dart';
import 'package:fintech_new_web/features/materialSource/provider/material_source_provider.dart';
import 'package:fintech_new_web/features/materialTechDetails/provider/material_tech_details_provider.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:fintech_new_web/features/obMaterial/provider/ob_material_provider.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/orderApRequest/provider/order_ap_request_provider.dart';
import 'package:fintech_new_web/features/orderApproval/provider/order_approval_provider.dart';
import 'package:fintech_new_web/features/orderCancel/provider/order_cancel_provider.dart';
import 'package:fintech_new_web/features/orderDelivery/provider/order_delivery_provider.dart';
import 'package:fintech_new_web/features/orderGoodsDispatch/provider/order_goods_dispatch_provider.dart';
import 'package:fintech_new_web/features/orderPackaging/provider/order_packaging_provider.dart';
import 'package:fintech_new_web/features/orderPacked/provider/order_packed_provider.dart';
import 'package:fintech_new_web/features/orderTransport/provider/order_transport_provider.dart';
import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partSubAssembly/provider/part_sub_assembly_provider.dart';
import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/paymentClear/provider/payment_clear_provider.dart';
import 'package:fintech_new_web/features/paymentInward/provider/payment_inward_provider.dart';
import 'package:fintech_new_web/features/paymentInward/provider/unadjusted_payment_inward_provider.dart';
import 'package:fintech_new_web/features/paymentInwardClear/provider/payment_inward_clear_provider.dart';
import 'package:fintech_new_web/features/paymentVoucher/provider/payment_voucher_provider.dart';
import 'package:fintech_new_web/features/prTaxInvoice/provider/pr_tax_invoice_provider.dart';
import 'package:fintech_new_web/features/prTaxInvoiceDispatch/provider/pr_tax_invoice_dispatch_provider.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:fintech_new_web/features/productBreakup/screens/pb_costing_rate_details.dart';
import 'package:fintech_new_web/features/productBreakupTechDetails/provider/product_breakup_tech_details_provider.dart';
import 'package:fintech_new_web/features/productFinalStandard/provider/product_final_standard_provider.dart';
import 'package:fintech_new_web/features/productionPlan/provider/production_plan_provider.dart';
import 'package:fintech_new_web/features/purchaseTransfer/provider/purchase_transfer_provider.dart';
import 'package:fintech_new_web/features/reOrderBalanceMaterial/provider/re_order_balance_material_provider.dart';
import 'package:fintech_new_web/features/receiptVoucher/provider/receipt_voucher_provider.dart';
import 'package:fintech_new_web/features/reqIssue/provider/req_issue_provider.dart';
import 'package:fintech_new_web/features/reqPacked/provider/req_packed_provider.dart';
import 'package:fintech_new_web/features/reqPacking/provider/req_packing_provider.dart';
import 'package:fintech_new_web/features/reqProduction/provider/req_production_provider.dart';
import 'package:fintech_new_web/features/resources/provider/resource_provider.dart';
import 'package:fintech_new_web/features/reverseCharge/provider/reverse_charge_provider.dart';
import 'package:fintech_new_web/features/saleTransfer/provider/sale_transfer_provider.dart';
import 'package:fintech_new_web/features/salesDebitNote/provider/sales_debit_note_provider.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/salesOrderAdvance/provider/sales_order_advance_provider.dart';
import 'package:fintech_new_web/features/salesReport/provider/sales_report_provider.dart';
import 'package:fintech_new_web/features/taClaim/provider/ta_claim_provider.dart';
import 'package:fintech_new_web/features/tod/provider/tod_provider.dart';
import 'package:fintech_new_web/features/visitInfo/provider/visit_info_provider.dart';
import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/workProcess/provider/work_process_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/bpDocument/provider/bp_document_provider.dart';
import 'features/bpPayNTaxInfo/provider/bpTaxInfoProvider.dart';
import 'features/businessPartnerAddress/provider/business_partner_address_provider.dart';
import 'features/businessPartnerContact/provider/business_partner_contact_provider.dart';
import 'features/businessPartnerObMaterial/provider/bp_ob_material_provider.dart';
import 'features/company/provider/add_company_provider.dart';
import 'features/dbNote/provider/dbnote_provider.dart';
import 'features/home.dart';
import 'features/orderBilled/provider/order_billed_provider.dart';
import 'features/productionPlanA/provider/production_plan_A_provider.dart';
import 'features/purchaseOrder/provider/purchase_order_provider.dart';
import 'features/warehouse/provider/warehouse_provider.dart';
import 'go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {

  js.context['openFlutterScreen'] = (String argument) {
    _openScreen(argument);
  };

  runApp(const MyApp());
}

void _openScreen(String argument) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => PbCostingRateDetails(matno: argument),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => AuthProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AddCompanyProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BillReceiptProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => LedgerCodesProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialSourceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PurchaseOrderProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerTaxInfoProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerAddressProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerContactProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => WarehouseProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                BusinessPartnerDocumentProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerSearchProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialRepProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => GrProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AdditionalOrderProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => EvOrderProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialIQSProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OBalanceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BillPayableProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BillReceivableProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => InwardVoucherProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => VisitInfoProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => TaClaimProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AttendanceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => InwardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => FinancialCrnoteProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReceiptVoucherProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentVoucherProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DbnoteProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PrTaxInvoiceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => CrnoteProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SalesDebitNoteProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DebitNoteDispatchProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DbNoteAgainstCrNoteProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PrTaxInvoiceDispatchProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ResourceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BpShippingProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => CarrierProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SalesOrderProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => GrOtherChargesProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => GrQtyClearProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => GrIqsRepProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderApprovalProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderPackedProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderCancelProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderTransportProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderApRequestProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderDeliveryProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderGoodsDispatchProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderPackagingProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OrderBilledProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => WireSizeProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PartAssemblyProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PartSubAssemblyProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ProductBreakupProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                ProductBreakupTechDetailsProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ProductFinalStandardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => JournalVoucherProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => HsnProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentClearProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SaleTransferProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PurchaseTransferProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentInwardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => WorkProcessProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => CostResourceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                MaterialIncomingStandardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ManufacturingProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => JobWorkOutProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => InvenReqProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReqProductionProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReqPackingProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReqPackedProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReqIssueProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DlChallanProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => JobWorkOutChallanClearProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ProductionPlanProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ProductionPlanAProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => LineRejectionProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialReturnProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BankProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SalesOrderAdvanceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentInwardClearProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AdvanceRequirementProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReOrderBalanceMaterialProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => GstReturnProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReverseChargeProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => LedgerProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ObMaterialProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialAssemblyProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BusinessPartnerOnBoardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BpBreakupProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialAssemblyProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BpObMaterialProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                MaterialAssemblyTechDetailsProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => BpProcessingProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => TodProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                UnadjustedPaymentInwardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialTechDetailsProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ColorProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ExportOrderProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AccountGroupProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => JobWorkOutClearProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SalesReportProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => MaterialClassificationProvider()),
      ],
      child: MaterialApp.router(
        title: 'Open Office',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.robotoTextTheme(),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("HRMS"),
      // ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          color: HexColor("#FFD3AD"),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_tree_rounded,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  Text(
                    "Fintech",
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  "assets/home.png",
                  width: 300,
                  height: 306,
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  decoration: BoxDecoration(
                      color: HexColor("#F2994A"),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome!",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome to HRMS, your centralized hub for all employee management needs. Streamline HR processes, track employee performance, and foster a collaborative workplace environment effortlessly.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.10),
                        width: screenWidth,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            NetworkService networkService = NetworkService();
                            String? token = prefs.getString("auth_token");
                            bool tokenValidity =
                                await networkService.isTokenValid();
                            if (token != "" && token != null && tokenValidity) {
                              context.pushNamed(HomePageScreen.routeName);
                            } else {
                              context.pushNamed(LoginScreen.routeName);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
