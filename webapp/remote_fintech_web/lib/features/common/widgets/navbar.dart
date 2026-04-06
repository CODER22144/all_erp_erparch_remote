import 'package:fintech_new_web/features/JVoucher/screens/add_journal_voucher.dart';
import 'package:fintech_new_web/features/JVoucher/screens/journal_voucher_report_form.dart';
import 'package:fintech_new_web/features/additionalOrder/screen/additional_order.dart';
import 'package:fintech_new_web/features/additionalOrder/screen/additional_purchase_order_report_form.dart';
import 'package:fintech_new_web/features/advanceRequirement/screens/add_advance_req.dart';
import 'package:fintech_new_web/features/attendence/screen/get_attendance_report.dart';
import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:fintech_new_web/features/auth/screen/add_company.dart';
import 'package:fintech_new_web/features/auth/screen/add_company_group.dart';
import 'package:fintech_new_web/features/auth/screen/login.dart';
import 'package:fintech_new_web/features/auth/screen/org_management.dart';
import 'package:fintech_new_web/features/auth/screen/update_user.dart';
import 'package:fintech_new_web/features/bankUpload/screens/bank_report_form.dart';
import 'package:fintech_new_web/features/bankUpload/screens/bank_report_form_sales.dart';
import 'package:fintech_new_web/features/bankUpload/screens/bank_upload.dart';
import 'package:fintech_new_web/features/bankUpload/screens/upload_hdfc.dart';
import 'package:fintech_new_web/features/bankUpload/screens/upload_kotak.dart';
import 'package:fintech_new_web/features/billPayable/screen/add_bill_payable.dart';
import 'package:fintech_new_web/features/billReceipt/screen/br_filter_form.dart';
import 'package:fintech_new_web/features/billReceipt/screen/br_report_form.dart';
import 'package:fintech_new_web/features/billReceipt/screen/create_bill_receipt.dart';
import 'package:fintech_new_web/features/billReceivable/screens/add_bill_receivable.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup_details.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup_processing.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup_report_form.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/delete_bp_breakup.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/delete_bp_breakup_details.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/delete_bp_breakup_processing.dart';
import 'package:fintech_new_web/features/bpBreakup/screens/get_bp_breakup.dart';
import 'package:fintech_new_web/features/bpPayNTaxInfo/screen/get_bp_tax_info.dart';
import 'package:fintech_new_web/features/bpShipping/screens/bp_shipping.dart';
import 'package:fintech_new_web/features/bpShipping/screens/get_bp_shipping.dart';
import 'package:fintech_new_web/features/bpShipping/screens/shipping_report_form.dart';
import 'package:fintech_new_web/features/businessPartner/screen/bp_payment_info_report.dart';
import 'package:fintech_new_web/features/businessPartner/screen/bp_report_form.dart';
import 'package:fintech_new_web/features/businessPartner/screen/business_partner_tabs.dart';
import 'package:fintech_new_web/features/businessPartnerObMaterial/screens/bp_ob_material.dart';
import 'package:fintech_new_web/features/businessPartnerObMaterial/screens/bp_ob_material_form.dart';
import 'package:fintech_new_web/features/businessPartnerObMaterial/screens/get_bp_ob_material.dart';
import 'package:fintech_new_web/features/businessPartnerOnBoard/provider/business_partner_on_board_provider.dart';
import 'package:fintech_new_web/features/businessPartnerOnBoard/screens/get_bp_on_board.dart';
import 'package:fintech_new_web/features/businessPartnerProcessing/screens/bp_processing.dart';
import 'package:fintech_new_web/features/businessPartnerProcessing/screens/get_bp_processing.dart';
import 'package:fintech_new_web/features/carrier/screens/carrier.dart';
import 'package:fintech_new_web/features/carrier/screens/carrier_report.dart';
import 'package:fintech_new_web/features/carrier/screens/get_carrier.dart';
import 'package:fintech_new_web/features/colorCode/screens/add_color.dart';
import 'package:fintech_new_web/features/colorCode/screens/color_report.dart';
import 'package:fintech_new_web/features/colorCode/screens/get_color.dart';
import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/company/screens/add_company_form.dart';
import 'package:fintech_new_web/features/costResource/screens/add_cost_resource.dart';
import 'package:fintech_new_web/features/costResource/screens/cost_resource_report.dart';
import 'package:fintech_new_web/features/costResource/screens/get_cost_resource.dart';
import 'package:fintech_new_web/features/crNote/screens/cr_note_details.dart';
import 'package:fintech_new_web/features/crNote/screens/cr_note_report_form.dart';
import 'package:fintech_new_web/features/crNote/screens/export_ecr_note.dart';
import 'package:fintech_new_web/features/crNote/screens/upload_cr_note_invoice.dart';
import 'package:fintech_new_web/features/dbNote/screens/db_note_details.dart';
import 'package:fintech_new_web/features/dbNote/screens/export_edb_note.dart';
import 'package:fintech_new_web/features/debitNoteAgainstCreditNote/screens/add_db_note_against_cr_note.dart';
import 'package:fintech_new_web/features/debitNoteDispatch/screens/add_debit_note_dispatch.dart';
import 'package:fintech_new_web/features/dlChallan/screens/add_dl_challan.dart';
import 'package:fintech_new_web/features/dlChallan/screens/dl_challan_report_form.dart';
import 'package:fintech_new_web/features/evOrder/screen/ev_order.dart';
import 'package:fintech_new_web/features/exportOrder/screens/add_export_order.dart';
import 'package:fintech_new_web/features/exportOrder/screens/export_order_report.dart';
import 'package:fintech_new_web/features/exportOrder/screens/get_export_order.dart';
import 'package:fintech_new_web/features/financialCreditNote/screens/create_financial_crnote.dart';
import 'package:fintech_new_web/features/gr/screen/gr_details_report_form.dart';
import 'package:fintech_new_web/features/gr/screen/gr_item_report_form.dart';
import 'package:fintech_new_web/features/gr/screen/gr_rate_approval_pending.dart';
import 'package:fintech_new_web/features/gr/screen/gr_rejection_pending.dart';
import 'package:fintech_new_web/features/gr/screen/gr_report_form.dart';
import 'package:fintech_new_web/features/gr/screen/gr_shortage_pending.dart';
import 'package:fintech_new_web/features/grIqsRep/screens/gr_iqs_pending.dart';
import 'package:fintech_new_web/features/grOtherCharges/screens/add_gr_charges.dart';
import 'package:fintech_new_web/features/grOtherCharges/screens/gr_other_charges_pending_form.dart';
import 'package:fintech_new_web/features/grQtyClear/screens/gr_qty_clear_pending.dart';
import 'package:fintech_new_web/features/gstReturn/screens/get_b2b_no_match.dart';
import 'package:fintech_new_web/features/gstReturn/screens/get_b2b_not_in.dart';
import 'package:fintech_new_web/features/gstReturn/screens/gst_hsn_report_form.dart';
import 'package:fintech_new_web/features/gstReturn/screens/post_b2b.dart';
import 'package:fintech_new_web/features/hsn/screens/add_hsn.dart';
import 'package:fintech_new_web/features/hsn/screens/get_hsn.dart';
import 'package:fintech_new_web/features/hsn/screens/hsn_report.dart';
import 'package:fintech_new_web/features/invenReq/screens/add_req_details.dart';
import 'package:fintech_new_web/features/inward/screens/inward_report_form.dart';
import 'package:fintech_new_web/features/inward/screens/tds_report_form.dart';
import 'package:fintech_new_web/features/inwardVoucher/screens/create_inward_voucher.dart';
import 'package:fintech_new_web/features/jobWorkOut/screens/add_job_work_out.dart';
import 'package:fintech_new_web/features/jobWorkOut/screens/add_job_work_out_details.dart';
import 'package:fintech_new_web/features/jobWorkOut/screens/job_workout_report_form.dart';
import 'package:fintech_new_web/features/jobWorkOutChallanClear/screens/add_job_work_out_challan_clear.dart';
import 'package:fintech_new_web/features/ledger/screens/ledger.dart';
import 'package:fintech_new_web/features/ledger/screens/trail.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/get_ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_code_report_form.dart';
import 'package:fintech_new_web/features/lineRejection/screens/get_line_rejection.dart';
import 'package:fintech_new_web/features/lineRejection/screens/line_rejection_pending.dart';
import 'package:fintech_new_web/features/manufacturing/screens/add_manufacturing.dart';
import 'package:fintech_new_web/features/manufacturing/screens/manufacturing_report_form.dart';
import 'package:fintech_new_web/features/material/screen/get_material.dart';
import 'package:fintech_new_web/features/material/screen/mat_stock_report_form.dart';
import 'package:fintech_new_web/features/material/screen/material_group_report.dart';
import 'package:fintech_new_web/features/material/screen/material_report_form.dart';
import 'package:fintech_new_web/features/material/screen/material_type_report.dart';
import 'package:fintech_new_web/features/material/screen/material_unit_report.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly_details.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly_processing.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/get_material_assembly.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_costing_report_form.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_details.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_processing.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_report_form.dart';
import 'package:fintech_new_web/features/materialAssemblyTechDetails/screens/get_mat_assembly_tech_details.dart';
import 'package:fintech_new_web/features/materialAssemblyTechDetails/screens/material_assembly_tech_details.dart';
import 'package:fintech_new_web/features/materialIQS/screens/create_material_iqs.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/add_material_incoming_standard.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/material_incoming_standard_report.dart';
import 'package:fintech_new_web/features/materialReturn/screens/add_material_return.dart';
import 'package:fintech_new_web/features/materialSource/screen/edit_material_source_bulk.dart';
import 'package:fintech_new_web/features/materialSource/screen/get_material_source.dart';
import 'package:fintech_new_web/features/materialSource/screen/material_source_report_form.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/add_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/delete_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/get_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/material_tech_detail_report_form.dart';
import 'package:fintech_new_web/features/obMaterial/screens/get_ob_material.dart';
import 'package:fintech_new_web/features/obMaterial/screens/ob_material_report_form.dart';
import 'package:fintech_new_web/features/obMaterial/screens/ob_material_screen.dart';
import 'package:fintech_new_web/features/obalance/screens/create-obalance.dart';
import 'package:fintech_new_web/features/obalance/screens/obalance_report_form.dart';
import 'package:fintech_new_web/features/orderApproval/screens/hold_denied_order_report.dart';
import 'package:fintech_new_web/features/orderBilled/screens/get_billed_order.dart';
import 'package:fintech_new_web/features/orderCancel/screens/add_order_cancel.dart';
import 'package:fintech_new_web/features/orderGoodsDispatch/screens/get_order_goods_dispatch_pending.dart';
import 'package:fintech_new_web/features/orderPackaging/screens/order_packaging_pending.dart';
import 'package:fintech_new_web/features/orderTransport/screens/get_order_transport_pending.dart';
import 'package:fintech_new_web/features/partAssembly/screens/get_part_assembly.dart';
import 'package:fintech_new_web/features/partAssembly/screens/not_in_bill_of_material.dart';
import 'package:fintech_new_web/features/partAssembly/screens/part_assembly_by_matno.dart';
import 'package:fintech_new_web/features/partAssembly/screens/part_assembly_report_form.dart';
import 'package:fintech_new_web/features/partAssembly/screens/part_search.dart';
import 'package:fintech_new_web/features/partAssembly/screens/work_in_progress_report.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/get_part_sub_assembly.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/part_sub_assembly_costing_report_form.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/part_sub_assembly_report_form.dart';
import 'package:fintech_new_web/features/payment/screens/payment_outward_report_form.dart';
import 'package:fintech_new_web/features/paymentClear/screens/unadjusted_payment_pending.dart';
import 'package:fintech_new_web/features/paymentInward/screens/add_payment_inward.dart';
import 'package:fintech_new_web/features/paymentInward/screens/payment_inward_post.dart';
import 'package:fintech_new_web/features/paymentInward/screens/unadjusted_payment_inward.dart';
import 'package:fintech_new_web/features/paymentVoucher/screens/create_payment_voucher.dart';
import 'package:fintech_new_web/features/payment/screens/bill_pending_report_form.dart';
import 'package:fintech_new_web/features/prTaxInvoice/screens/export_pr_tax_invoice.dart';
import 'package:fintech_new_web/features/prTaxInvoice/screens/pr_tax_invoice_details.dart';
import 'package:fintech_new_web/features/prTaxInvoice/screens/pr_tax_invoice_report_form.dart';
import 'package:fintech_new_web/features/productBreakup/screens/get_product_breakup.dart';
import 'package:fintech_new_web/features/productBreakup/screens/pb_costing_report_form.dart';
import 'package:fintech_new_web/features/productBreakup/screens/product_breakup_report_form.dart';
import 'package:fintech_new_web/features/productBreakupTechDetails/screens/add_product_breakup_tech_details.dart';
import 'package:fintech_new_web/features/productFinalStandard/screens/add_product_final_standard.dart';
import 'package:fintech_new_web/features/productionPlan/screens/add_production_plan.dart';
import 'package:fintech_new_web/features/productionPlan/screens/delete_production_plan.dart';
import 'package:fintech_new_web/features/productionPlan/screens/production_plan_report_form.dart';
import 'package:fintech_new_web/features/productionPlanA/screen/add_production_planA.dart';
import 'package:fintech_new_web/features/reOrderBalanceMaterial/screens/re_order_bal_mat_report_form.dart';
import 'package:fintech_new_web/features/receiptVoucher/screens/create_receipt_voucher.dart';
import 'package:fintech_new_web/features/reqIssue/screens/req_issue_pending_form.dart';
import 'package:fintech_new_web/features/reqIssue/screens/req_issue_summary.dart';
import 'package:fintech_new_web/features/reqPacked/screens/req_packed_pending.dart';
import 'package:fintech_new_web/features/reqPacking/screens/req_packing_pending.dart';
import 'package:fintech_new_web/features/reqProduction/screens/req_production_pending.dart';
import 'package:fintech_new_web/features/resources/screens/resource_report.dart';
import 'package:fintech_new_web/features/resources/screens/resources.dart';
import 'package:fintech_new_web/features/reverseCharge/screens/add_reverse_charge.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/payment_pending_report_form.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/sale_payment_pending_report_form.dart';
import 'package:fintech_new_web/features/salesDebitNote/screens/export_sales_edb_note.dart';
import 'package:fintech_new_web/features/salesDebitNote/screens/sale_debit_note_report_form.dart';
import 'package:fintech_new_web/features/salesOrder/screens/einvoice_pending.dart';
import 'package:fintech_new_web/features/salesOrder/screens/export_eway_bill_sale.dart';
import 'package:fintech_new_web/features/salesOrder/screens/gst_eway_auto.dart';
import 'package:fintech_new_web/features/salesOrder/screens/orderBalance/order_balance_report_form.dart';
import 'package:fintech_new_web/features/salesOrder/screens/order_report.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order_report_form.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order_short_qty.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_report_form.dart';
import 'package:fintech_new_web/features/salesOrder/screens/transport_slip.dart';
import 'package:fintech_new_web/features/salesOrderAdvance/screens/sales_order_advance.dart';
import 'package:fintech_new_web/features/taClaim/screens/add_ta_claim.dart';
import 'package:fintech_new_web/features/taClaim/screens/get_claim_report.dart';
import 'package:fintech_new_web/features/tod/screens/tod_report_form.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:fintech_new_web/features/visitInfo/screens/add_visit_info.dart';
import 'package:fintech_new_web/features/visitInfo/screens/get_visit_info_report.dart';
import 'package:fintech_new_web/features/warehouse/screen/warehouse.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_by_matno.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_report.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_report_form.dart';
import 'package:fintech_new_web/features/workProcess/screens/add_work_process.dart';
import 'package:fintech_new_web/features/workProcess/screens/get_work_process.dart';
import 'package:fintech_new_web/features/workProcess/screens/work_process_report.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../attendence/attendence.dart';
import '../../auth/screen/add_user.dart';
import '../../businessPartner/screen/bp_payment_info_report_form.dart';
import '../../businessPartner/screen/get-business-partner.dart';
import '../../businessPartnerOnBoard/screens/bp_on_board_report_form.dart';
import '../../businessPartnerOnBoard/screens/business_partner_on_board.dart';
import '../../dbNote/screens/db_note_report_form.dart';
import '../../gr/screen/gr_rate_difference_pending.dart';
import '../../gr/screen/pending_gr_report.dart';
import '../../gr/screen/sale_item_report_form.dart';
import '../../gstReturn/screens/b2b_report_form.dart';
import '../../gstReturn/screens/get_b2b_match.dart';
import '../../gstReturn/screens/gst_r2b_upload.dart';
import '../../hsn/screens/ac_groups_report.dart';
import '../../invenReq/screens/add_req.dart';
import '../../ledgerCodes/screen/ledger_codes.dart';
import '../../lineRejection/screens/add_line_rejection.dart';
import '../../material/screen/edit_material_bulk.dart';
import '../../material/screen/material_screen.dart';
import '../../materialAssembly/screens/material_assembly.dart';
import '../../materialSource/screen/material_source.dart';
import '../../orderApRequest/screens/get_pending_ap_request.dart';
import '../../orderApproval/screens/get_order_approval_pending.dart';
import '../../orderBilled/screens/get_order_billed_pending.dart';
import '../../partAssembly/screens/part_assembly_costing_report_form.dart';
import '../../partSubAssembly/screens/part_sub_assembly_by_matno.dart';
import '../../paymentInward/screens/payment_inward_report_form.dart';
import '../../prTaxInvoiceDispatch/screens/add_pr_tax_invoice_dispatch.dart';
import '../../productBreakup/screens/product_breakup_by_matno.dart';
import '../../purchaseOrder/screen/purchase_order.dart';
import '../../purchaseOrder/screen/purchase_order_item_report_form.dart';
import '../../purchaseOrder/screen/purchase_order_report_form.dart';
import '../../purchaseTransfer/screens/purchase_bill_pending_report_form.dart';
import '../../resources/screens/get_resources.dart';
import '../../reverseCharge/screens/reverse_charge_report_form.dart';
import '../../salesDebitNote/screens/sales_debit_note_details.dart';

class SidebarNavigationMenu extends StatefulWidget {
  const SidebarNavigationMenu({super.key});

  @override
  State<SidebarNavigationMenu> createState() => _SidebarNavigationMenuState();
}

class _SidebarNavigationMenuState extends State<SidebarNavigationMenu> {
  // List<String> roles = [];
  @override
  void initState() {
    super.initState();
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    provider.initUserInfo();
    provider.generateMenu(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                  "${provider.userInfo['first_name'] ?? ""} ${provider.userInfo['last_name'] ?? ""} | ${provider.userInfo['company_name'] ?? ""}"),
              accountEmail: Text("${provider.userInfo['email'] ?? ""}"),
              currentAccountPicture: SizedBox(
                child: checkForEmptyOrNullString(provider.userInfo['logo'])
                    ? Image.network(
                        'http://erpapiarch.rcinz.com${provider.userInfo['logo'] ?? ""}',
                        errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                            Icons.error); // or any fallback widget
                      })
                    : CircleAvatar(
                        child: ClipOval(
                          child: Image.asset("assets/avatar.jpeg",
                              width: 200, height: 200),
                        ),
                      ),
              ),
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
            ),
            ListView.builder(
              itemCount: provider.mainMenu.length,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return provider.mainMenu[index];
              },
            ),
            Visibility(
              visible: provider.userInfo['roles']
                  .toString()
                  .split(",")
                  .contains('AD'),
              child: ExpansionTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text("Manage Organisation"),
                children: [
                  ListTile(
                    // leading: const Icon(Icons.logout_outlined),
                    title: const Text("Add User"),
                    onTap: () {
                      context.pushNamed(AddUser.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.logout_outlined),
                    title: const Text("Update User"),
                    onTap: () {
                      context.pushNamed(UpdateUser.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.logout_outlined),
                    title: const Text("Add Company"),
                    onTap: () {
                      context.pushNamed(AddOrgCompany.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.logout_outlined),
                    title: const Text("Add Company Group"),
                    onTap: () {
                      context.pushNamed(AddCompanyGroup.routeName);
                    },
                  )
                ],
              ),
            ),
            Visibility(
              visible: provider.mainMenu.isNotEmpty,
              child: ListTile(
                leading: const Icon(Icons.cameraswitch_outlined),
                title: const Text("Switch Company"),
                onTap: () async {
                  // bool confirmation = await showConfirmationDialogue(
                  //     context,
                  //     "Logging out will end your current session. Are you sure you want to proceed?",
                  //     "LOGOUT",
                  //     "GO BACK");
                  // if (confirmation) {
                  provider.updateUserCid(null);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? data = prefs.getString("userData");
                  GlobalVariables.requestBody.clear();
                  Navigator.pop(context);
                  context.pushNamed(OrgManagement.routeName,
                      queryParameters: {"usrDetails": data});
                  // }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
              onTap: () async {
                bool confirmation = await showConfirmationDialogue(
                    context,
                    "Logging out will end your current session. Are you sure you want to proceed?",
                    "LOGOUT",
                    "GO BACK");
                if (confirmation) {
                  provider.updateUserCid(null);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("auth_token");
                  GlobalVariables.requestBody.clear();
                  Navigator.pop(context);
                  context.pushNamed(LoginScreen.routeName);
                }
              },
            )
          ],
        ),
      );
    });
  }
}
