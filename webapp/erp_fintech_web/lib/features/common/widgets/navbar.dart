import 'package:fintech_new_web/features/JVoucher/screens/add_journal_voucher.dart';
import 'package:fintech_new_web/features/JVoucher/screens/journal_voucher_report_form.dart';
import 'package:fintech_new_web/features/additionalOrder/screen/additional_order.dart';
import 'package:fintech_new_web/features/additionalOrder/screen/additional_purchase_order_report_form.dart';
import 'package:fintech_new_web/features/advanceRequirement/screens/add_advance_req.dart';
import 'package:fintech_new_web/features/attendence/screen/get_attendance_report.dart';
import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:fintech_new_web/features/auth/screen/login.dart';
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
import 'package:fintech_new_web/features/bpBreakup/screens/bp_breakup_summary_report_form.dart';
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
import 'package:fintech_new_web/features/businessPartnerProcessing/screens/bp_processing_report_form.dart';
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
import 'package:fintech_new_web/features/jobWorkOutClear/screens/job_work_out_clear.dart';
import 'package:fintech_new_web/features/jobWorkOutClear/screens/job_work_out_clear_report_form.dart';
import 'package:fintech_new_web/features/jobWorkOutClear/screens/jwoc_report_form.dart';
import 'package:fintech_new_web/features/ledger/screens/ledger.dart';
import 'package:fintech_new_web/features/ledger/screens/trail.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/get_ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_code_report_form.dart';
import 'package:fintech_new_web/features/lineRejection/screens/get_line_rejection.dart';
import 'package:fintech_new_web/features/lineRejection/screens/line_rejection_pending.dart';
import 'package:fintech_new_web/features/manufacturing/screens/add_manufacturing.dart';
import 'package:fintech_new_web/features/manufacturing/screens/manufacturing_report_form.dart';
import 'package:fintech_new_web/features/material/screen/delete_material.dart';
import 'package:fintech_new_web/features/material/screen/get_material.dart';
import 'package:fintech_new_web/features/material/screen/mat_reorder_report_form.dart';
import 'package:fintech_new_web/features/material/screen/mat_stock_report_form.dart';
import 'package:fintech_new_web/features/material/screen/material_group_report.dart';
import 'package:fintech_new_web/features/material/screen/material_report_form.dart';
import 'package:fintech_new_web/features/material/screen/material_type_report.dart';
import 'package:fintech_new_web/features/material/screen/material_unit_report.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly_details.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/delete_material_assembly_processing.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/get_material_assembly.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/mat_assembly_comparison_report_form.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_costing_report_form.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_details.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_processing.dart';
import 'package:fintech_new_web/features/materialAssembly/screens/material_assembly_report_form.dart';
import 'package:fintech_new_web/features/materialAssemblyTechDetails/screens/get_mat_assembly_tech_details.dart';
import 'package:fintech_new_web/features/materialAssemblyTechDetails/screens/material_assembly_tech_details.dart';
import 'package:fintech_new_web/features/materialClassification/screens/add_material_classification.dart';
import 'package:fintech_new_web/features/materialClassification/screens/get_mat_classification.dart';
import 'package:fintech_new_web/features/materialClassification/screens/material_classification_report_form.dart';
import 'package:fintech_new_web/features/materialIQS/screens/create_material_iqs.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/add_material_incoming_standard.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/incoming_qc_pending.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/incoming_report_form.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/material_incoming_standard_report.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/material_incoming_standard_report_form.dart';
import 'package:fintech_new_web/features/materialReturn/screens/add_material_return.dart';
import 'package:fintech_new_web/features/materialSource/screen/edit_material_source_bulk.dart';
import 'package:fintech_new_web/features/materialSource/screen/get_material_source.dart';
import 'package:fintech_new_web/features/materialSource/screen/material_source_report_form.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/add_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/delete_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/get_material_tech_details.dart';
import 'package:fintech_new_web/features/materialTechDetails/screens/material_tech_detail_report_form.dart';
import 'package:fintech_new_web/features/obMaterial/screens/get_ob_material.dart';
import 'package:fintech_new_web/features/obMaterial/screens/ob_material_bulk_update.dart';
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
import 'package:fintech_new_web/features/productBreakup/screens/pb_cost_comparison_report_form.dart';
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
import 'package:fintech_new_web/features/salesReport/screens/yearly_category_sales_report_form.dart';
import 'package:fintech_new_web/features/salesReport/screens/yearly_report_form.dart';
import 'package:fintech_new_web/features/taClaim/screens/add_ta_claim.dart';
import 'package:fintech_new_web/features/taClaim/screens/get_claim_report.dart';
import 'package:fintech_new_web/features/tod/screens/tod_report_form.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/visitInfo/screens/add_visit_info.dart';
import 'package:fintech_new_web/features/visitInfo/screens/get_visit_info_report.dart';
import 'package:fintech_new_web/features/warehouse/screen/warehouse.dart';
import 'package:fintech_new_web/features/wireSize/screens/old_wire_size_report_form.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_by_matno.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_report.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_assembly_report_form.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_mat_report_form.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_report_form.dart';
import 'package:fintech_new_web/features/workProcess/screens/add_work_process.dart';
import 'package:fintech_new_web/features/workProcess/screens/get_work_process.dart';
import 'package:fintech_new_web/features/workProcess/screens/work_process_report.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../attendence/attendence.dart';
import '../../businessPartner/screen/bp_payment_info_report_form.dart';
import '../../businessPartner/screen/get-business-partner.dart';
import '../../businessPartnerObMaterial/screens/bp_ob_material_bulk_update.dart';
import '../../businessPartnerOnBoard/screens/bp_on_board_report_form.dart';
import '../../businessPartnerOnBoard/screens/business_partner_on_board.dart';
import '../../dbNote/screens/db_note_report_form.dart';
import '../../exportOrder/screens/export_invoice_report.dart';
import '../../financialCreditNote/screens/financial_crnote_report_form.dart';
import '../../gr/screen/export_gr_data.dart';
import '../../gr/screen/gr_rate_difference_pending.dart';
import '../../gr/screen/pending_gr_report.dart';
import '../../gr/screen/sale_item_report_form.dart';
import '../../gstReturn/screens/b2b_report_form.dart';
import '../../gstReturn/screens/get_b2b_match.dart';
import '../../gstReturn/screens/gst_r2b_upload.dart';
import '../../hsn/screens/ac_groups_report.dart';
import '../../invenReq/screens/add_req.dart';
import '../../jobWorkOutClear/screens/delete_job_work_out_clear.dart';
import '../../ledgerCodes/screen/ledger_codes.dart';
import '../../lineRejection/screens/add_line_rejection.dart';
import '../../material/screen/edit_material_bulk.dart';
import '../../material/screen/material_screen.dart';
import '../../material/screen/stock_value_report_form.dart';
import '../../materialAssembly/screens/material_assembly.dart';
import '../../materialIncomingStandard/screens/incoming_qc_pending_form.dart';
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
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    provider.initUserInfo();
    super.initState();
    // roles = provider.userInfo['roles'].split(",");
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
                child: provider.userInfo['logo'] != ""
                    ? Image.network(
                        'http://erpapi.rcinz.com${provider.userInfo['logo'] ?? ""}',
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

            Visibility(
                visible: (provider.userInfo['roles'] == 'PJ'),
                child: ExpansionTile(
                  leading: const Icon(Icons.mode_standby_outlined),
                  title: const Text("Costing"),
                  children: [
                    ListTile(
                      title: const Text("PB Costing"),
                      onTap: () {
                        context.pushNamed(PbCostingReportForm.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Part Assembly Costing"),
                      onTap: () {
                        context
                            .pushNamed(PartAssemblyCostingReportForm.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Part Sub-assembly Costing"),
                      onTap: () {
                        context.pushNamed(
                            PartSubAssemblyCostingReportForm.routeName);
                      },
                    )
                  ],
                )),

            // PURCHASE
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'PU'),
              child: ExpansionTile(
                leading: const Icon(Icons.bookmark_border_outlined),
                title: const Text("Purchase"),
                children: [
                  ExpansionTile(
                    title: const Text("Purchase Order"),
                    children: [
                      ListTile(
                        title: const Text("Create Order"),
                        onTap: () {
                          context.pushNamed(PurchaseOrderScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Purchase Order Report"),
                        onTap: () {
                          context.pushNamed(PurchaseOrderReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Purchase Order Item Report"),
                        onTap: () {
                          context
                              .pushNamed(PurchaseOrderItemReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Extend Validity"),
                        onTap: () {
                          context.pushNamed(EvOrder.routeName);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                      leading: const Icon(Icons.add_shopping_cart_outlined),
                      title: const Text("Additional Purchase Order"),
                      children: [
                        ListTile(
                          title: const Text("Create Order"),
                          onTap: () {
                            context.pushNamed(AdditionalOrder.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(
                                AdditionalPurchaseOrderReportForm.routeName);
                          },
                        ),
                      ]),
                  ListTile(
                    leading: const Icon(Icons.bookmark_border_outlined),
                    title: const Text("BR Pending"),
                    onTap: () {
                      context.pushNamed(BrFilterForm.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bookmark_border_outlined),
                    title: const Text("BR Report"),
                    onTap: () {
                      context.pushNamed(BrReportForm.routeName);
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.bookmark_border_outlined),
                    title: const Text("GR"),
                    children: [
                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(GrReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Item Report"),
                        onTap: () {
                          context.pushNamed(GrItemReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Add Other Charges"),
                        onTap: () {
                          context.pushNamed(AddGrCharges.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Other Charges Pending"),
                        onTap: () {
                          context
                              .pushNamed(GrOtherChargesPendingForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("GR Iqs Pending"),
                        onTap: () {
                          context.pushNamed(GrIqsPending.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Rate Approval Pending"),
                        onTap: () {
                          context.pushNamed(GrRateApprovalPending.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Rate Difference Pending"),
                        onTap: () {
                          context.pushNamed(GrRateDifferencePending.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Shortage Pending"),
                        onTap: () {
                          context.pushNamed(GrShortagePending.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Rejection Pending"),
                        onTap: () {
                          context.pushNamed(GrRejectionPending.routeName);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Production Plan"),
                    children: [
                      ListTile(
                        title: const Text("Add"),
                        onTap: () {
                          context.pushNamed(AddProductionPlan.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(ProductionPlanReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Delete"),
                        onTap: () {
                          context.pushNamed(DeleteProductionPlan.routeName);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Additional Plan"),
                    children: [
                      ListTile(
                        title: const Text("Add"),
                        onTap: () {
                          context.pushNamed(AddProductionPlanA.routeName);
                        },
                      ),
                      // ListTile(
                      //   title: const Text("Delete"),
                      //   onTap: () {
                      //     context.pushNamed(DeleteProductionPlan.routeName);
                      //   },
                      // ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Line Rejection"),
                    onTap: () {
                      context.pushNamed(AddLineRejection.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Line Rejection Pending"),
                    onTap: () {
                      context.pushNamed(GetLineRejection.routeName);
                    },
                  ),
                  ExpansionTile(
                    title: const Text('JobWork Challan'),
                    children: [
                      ListTile(
                        title: const Text("Add Jobwork Manual"),
                        onTap: () {
                          context.pushNamed(AddJobWorkOutDetails.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Add Jobwork Auto"),
                        onTap: () {
                          context.pushNamed(AddJobWorkOut.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(JobWorkoutReportForm.routeName);
                        },
                      ),
                      ExpansionTile(
                        title: const Text("Job Workout Clear"),
                        leading: const Icon(Icons.file_open_outlined),
                        children: [
                          ListTile(
                            title: const Text("Create"),
                            onTap: () {
                              context.pushNamed(JobWorkOutClear.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Report"),
                            onTap: () {
                              context
                                  .pushNamed(JobWorkOutClearReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Pending"),
                            onTap: () {
                              context
                                  .pushNamed(JwocPendingReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Delete"),
                            onTap: () {
                              context.pushNamed(DeleteJobWorkOutClear.routeName);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("DL Challan"),
                    children: [
                      ListTile(
                        title: const Text("Create"),
                        onTap: () {
                          context.pushNamed(AddDlChallan.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(DlChallanReportForm.routeName);
                        },
                      )
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Material Return"),
                    onTap: () {
                      context.pushNamed(AddMaterialReturn.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Req. Issue Pending"),
                    onTap: () {
                      context.pushNamed(ReqIssuePendingForm.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Req. Issue Summary"),
                    onTap: () {
                      context.pushNamed(ReqIssueSummary.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Material Min/Max"),
                    onTap: () {
                      context.pushNamed(MatReorderReportForm.routeName);
                    },
                  ),

                  // Material Classification
                  ExpansionTile(
                    title: const Text("Material Classification"),
                    children: [
                      ListTile(
                        title: const Text("Add"),
                        onTap: () {
                          context.pushNamed(AddMaterialClassification.routeName);
                        },
                      ),

                      ListTile(
                        title: const Text("Update"),
                        onTap: () {
                          context.pushNamed(GetMatClassification.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(MaterialClassificationReportForm.routeName);
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),

            // MASTER
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'MA'),
              child: ExpansionTile(
                  leading: const Icon(Icons.build_circle_outlined),
                  title: const Text("Master"),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add_business_outlined),
                      title: const Text("Company"),
                      onTap: () {
                        context.pushNamed(AddCompanyForm.routeName);
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.person_add_alt_outlined),
                      title: const Text("Business Partner"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(BusinessPartnerTabs.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Edit"),
                          onTap: () {
                            context.pushNamed(GetBusinessPartner.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("BP Discount Structure"),
                          onTap: () {
                            context.pushNamed(BpReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("BP Payment Info"),
                          onTap: () {
                            context
                                .pushNamed(BpPaymentInfoReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text("Warehouse"),
                      onTap: () {
                        context.pushNamed(Warehouse.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Edit BP Tax Info"),
                      onTap: () {
                        context.pushNamed(GetBpTaxInfo.routeName);
                      },
                    ),
                    ExpansionTile(
                        leading: const Icon(Icons.file_present_outlined),
                        title: const Text("Ledger Codes"),
                        children: [
                          ListTile(
                            title: const Text("Create"),
                            onTap: () {
                              context.pushNamed(LedgerCodes.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Edit"),
                            onTap: () {
                              context.pushNamed(GetLedgerCodes.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Report"),
                            onTap: () {
                              context.pushNamed(LedgerCodeReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Acc. Group Report"),
                            onTap: () {
                              context.pushNamed(AccountGroupsReport.routeName);
                            },
                          )
                        ]),
                    ExpansionTile(
                        title: const Text("HSN"),
                        leading: const Icon(Icons.currency_exchange_outlined),
                        children: [
                          ListTile(
                            title: const Text("Create"),
                            onTap: () {
                              context.pushNamed(AddHsn.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Update"),
                            onTap: () {
                              context.pushNamed(GetHsn.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Report"),
                            onTap: () {
                              context.pushNamed(HsnReport.routeName);
                            },
                          )
                        ]),
                    ExpansionTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: const Text("Material"),
                      children: [
                        ListTile(
                          title: const Text("Add Material"),
                          onTap: () {
                            context.pushNamed(MaterialScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Edit Material"),
                          onTap: () {
                            context.pushNamed(GetMaterial.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete Material"),
                          onTap: () {
                            context.pushNamed(DeleteMaterial.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update Material Bulk"),
                          onTap: () {
                            context.pushNamed(EditMaterialBulk.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Material Report"),
                          onTap: () {
                            context.pushNamed(MaterialReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Create Material IQS"),
                          onTap: () {
                            context.pushNamed(CreateMaterialIqs.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Material Group Report"),
                          onTap: () {
                            context.pushNamed(MaterialGroupReport.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Material Unit Report"),
                          onTap: () {
                            context.pushNamed(MaterialUnitReport.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Material Type Report"),
                          onTap: () {
                            context.pushNamed(MaterialTypeReport.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Material Source'),
                      children: [
                        ListTile(
                          // leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(MaterialSource.routeName);
                          },
                        ),
                        ListTile(
                          // leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text("Edit"),
                          onTap: () {
                            context.pushNamed(GetMaterialSource.routeName);
                          },
                        ),
                        ListTile(
                          // leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text("Bulk Update"),
                          onTap: () {
                            context.pushNamed(EditMaterialSourceBulk.routeName);
                          },
                        ),
                        ListTile(
                          // leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text("Report"),
                          onTap: () {
                            context
                                .pushNamed(MaterialSourceReportForm.routeName);
                          },
                        ),
                        ListTile(
                          // leading: const Icon(Icons.shopping_cart_outlined),
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetMaterialSource.routeName,
                                extra: true);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Resource"),
                      children: [
                        ListTile(
                          title: const Text("Create"),
                          onTap: () {
                            context.pushNamed(Resources.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Edit"),
                          onTap: () {
                            context.pushNamed(GetResources.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(ResourceReport.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("BP Shipping"),
                      children: [
                        ListTile(
                          title: const Text("Create"),
                          onTap: () {
                            context.pushNamed(BpShipping.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Edit"),
                          onTap: () {
                            context.pushNamed(GetBpShipping.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(ShippingReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Carrier"),
                      children: [
                        ListTile(
                          title: const Text("Create"),
                          onTap: () {
                            context.pushNamed(Carrier.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Edit"),
                          onTap: () {
                            context.pushNamed(GetCarrier.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(CarrierReport.routeName);
                          },
                        ),
                      ],
                    ),
                  ]),
            ),

            // FINANCE
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'FI'),
              child: ExpansionTile(
                leading: const Icon(Icons.attach_money_outlined),
                title: const Text("Finance"),
                children: [
                  ListTile(
                    title: const Text("GR Pending"),
                    onTap: () {
                      context.pushNamed(PendingGrReport.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Sales Debit Note"),
                    onTap: () {
                      context.pushNamed(SalesDebitNoteDetails.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Credit Note"),
                    onTap: () {
                      context.pushNamed(CrNoteDetails.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Upload E-Invoice Db/Cr Note"),
                    onTap: () {
                      context.pushNamed(UploadCrNoteInvoice.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Export E-Credit Note"),
                    onTap: () {
                      context.pushNamed(ExportEcrNote.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Export E-Invoice Debit Note"),
                    onTap: () {
                      context.pushNamed(ExportEdbNote.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Export E-Invoice Sales Debit Note"),
                    onTap: () {
                      context.pushNamed(ExportSalesEdbNote.routeName);
                    },
                  ),
                  // ListTile(
                  //   // leading: const Icon(Icons.note_alt_outlined),
                  //   title: const Text("Export E-Invoice PR Tax Invoice"),
                  //   onTap: () {
                  //     context.pushNamed(ExportPrTaxInvoice.routeName);
                  //   },
                  // ),
                  // ListTile(
                  //   // leading: const Icon(Icons.note_alt_outlined),
                  //   title: const Text("PR Tax Invoice"),
                  //   onTap: () {
                  //     context.pushNamed(PrTaxInvoiceDetails.routeName);
                  //   },
                  // ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Debit Note"),
                    onTap: () {
                      context.pushNamed(DbNoteDetails.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Receipt Voucher"),
                    onTap: () {
                      context.pushNamed(CreateReceiptVoucher.routeName);
                    },
                  ),
                  ExpansionTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Journal Voucher"),
                    children: [
                      ListTile(
                        // leading: const Icon(Icons.note_alt_outlined),
                        title: const Text("Create"),
                        onTap: () {
                          context.pushNamed(AddJournalVoucher.routeName);
                        },
                      ),
                      ListTile(
                        // leading: const Icon(Icons.note_alt_outlined),
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(JournalVoucherReportForm.routeName);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    // leading: const Icon(Icons.payment_outlined),
                    title: const Text("Payment Voucher"),
                    onTap: () {
                      context.pushNamed(CreatePaymentVoucher.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Financial Credit Note"),
                    onTap: () {
                      context.pushNamed(CreateFinancialCrnote.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Financial Credit Note Report"),
                    onTap: () {
                      context.pushNamed(FinancialCrnoteReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.balance_outlined),
                    title: const Text("Opening Balance"),
                    onTap: () {
                      context.pushNamed(CreateOBalance.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.balance_outlined),
                    title: const Text("Opening Balance Report"),
                    onTap: () {
                      context.pushNamed(ObalanceReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.request_page_outlined),
                    title: const Text("Bill Payable"),
                    onTap: () {
                      context.pushNamed(AddBillPayable.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.request_page_outlined),
                    title: const Text("Bill Receivable"),
                    onTap: () {
                      context.pushNamed(AddBillReceivable.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.card_giftcard_outlined),
                    title: const Text("Inward Voucher"),
                    onTap: () {
                      context.pushNamed(CreateInwardVoucher.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Bill Pending"),
                    onTap: () {
                      context.pushNamed(BillPendingReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Payment Pending"),
                    onTap: () {
                      context.pushNamed(PaymentPendingReportForm.routeName);
                    },
                  ),
                  // ListTile(
                  //   title: const Text("Payment Advance Pending"),
                  //   onTap: () {
                  //     context.pushNamed(PaymentAdvancePending.routeName);
                  //   },
                  // ),
                  ListTile(
                    title: const Text("Unadjusted Payment Pending"),
                    onTap: () {
                      context.pushNamed(UnadjustedPaymentPending.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Inward Bill Report"),
                    onTap: () {
                      context.pushNamed(InwardReportForm.routeName);
                    },
                  ),
                  // ListTile(
                  //   title: const Text("Purchase Transfer"),
                  //   onTap: () {
                  //     context
                  //         .pushNamed(PurchaseBillPendingReportForm.routeName);
                  //   },
                  // ),
                  // ListTile(
                  //   title: const Text("Sale Transfer"),
                  //   onTap: () {
                  //     context.pushNamed(SalePaymentPendingReportForm.routeName);
                  //   },
                  // ),
                  ListTile(
                    title: const Text("Payment Inward"),
                    onTap: () {
                      context.pushNamed(AddPaymentInward.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Unadjusted Payment Inward Pending"),
                    onTap: () {
                      context.pushNamed(UnadjustedPaymentInward.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Payment Inward Post"),
                    onTap: () {
                      context.pushNamed(PaymentInwardPost.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Debit Note Report"),
                    onTap: () {
                      context.pushNamed(DbNoteReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Sales Debit Note Report"),
                    onTap: () {
                      context.pushNamed(SaleDebitNoteReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Credit Note Report"),
                    onTap: () {
                      context.pushNamed(CrNoteReportForm.routeName);
                    },
                  ),
                  // ListTile(
                  //   // leading: const Icon(Icons.note_alt_outlined),
                  //   title: const Text("Pr Tax Invoice Report"),
                  //   onTap: () {
                  //     context.pushNamed(PrTaxInvoiceReportForm.routeName);
                  //   },
                  // ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Inward Payment Report"),
                    onTap: () {
                      context.pushNamed(PaymentInwardReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.note_alt_outlined),
                    title: const Text("Outward Payment Report"),
                    onTap: () {
                      context.pushNamed(PaymentOutwardReportForm.routeName);
                    },
                  ),
                  ListTile(
                    // leading: const Icon(Icons.send_to_mobile_outlined),
                    title: const Text("Debit Note Dispatch"),
                    onTap: () {
                      context.pushNamed(AddDebitNoteDispatch.routeName);
                    },
                  ),
                  // ListTile(
                  //   // leading: const Icon(Icons.send_to_mobile_outlined),
                  //   title: const Text("PR Tax Invoice Dispatch"),
                  //   onTap: () {
                  //     context.pushNamed(AddPrTaxInvoiceDispatch.routeName);
                  //   },
                  // ),
                  ListTile(
                    // leading: const Icon(Icons.send_to_mobile_outlined),
                    title: const Text("Debit Note Against Credit Note"),
                    onTap: () {
                      context.pushNamed(AddDbNoteAgainstCrNote.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("TOD Report"),
                    onTap: () {
                      context.pushNamed(TodReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("BP Discount Structure"),
                    onTap: () {
                      context.pushNamed(BpReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("BP Payment Info"),
                    onTap: () {
                      context.pushNamed(BpPaymentInfoReportForm.routeName);
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.upload_file_outlined),
                    title: const Text("Bank Details"),
                    children: [
                      ListTile(
                        title: const Text("Upload"),
                        onTap: () {
                          context.pushNamed(BankUpload.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Kotak Upload"),
                        onTap: () {
                          context.pushNamed(UploadKotak.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("HDFC Upload"),
                        onTap: () {
                          context.pushNamed(UploadHdfc.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Bank Statements"),
                        onTap: () {
                          context.pushNamed(BankReportForm.routeName);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                      leading: const Icon(Icons.arrow_circle_up_outlined),
                      title: const Text("Sales"),
                      children: [
                        ExpansionTile(
                          leading: const Icon(Icons.arrow_circle_up_outlined),
                          title: const Text("Order Processing"),
                          children: [
                            ListTile(
                              title: const Text("Order Approval"),
                              onTap: () {
                                context.pushNamed(
                                    GetOrderApprovalPending.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Hold/Denied Orders Report"),
                              onTap: () {
                                context
                                    .pushNamed(HoldDeniedOrderReport.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Order Bill Pending"),
                              onTap: () {
                                context
                                    .pushNamed(GetOrderBilledPending.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Update IRN"),
                              onTap: () {
                                context.pushNamed(GetBilledOrder.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("EInvoice Pending"),
                              onTap: () {
                                context.pushNamed(EinvoicePending.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Export Gr Data"),
                              onTap: () {
                                context.pushNamed(ExportGrData.routeName);
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          title: const Text("Export Eway Bill Sale"),
                          onTap: () {
                            context.pushNamed(ExportEwayBillSale.routeName);
                          },
                        ),
                        // ListTile(
                        //   title: const Text("Gst EInvoice"),
                        //   onTap: () {
                        //     context.pushNamed(GstEwayAuto.routeName);
                        //   },
                        // ),
                        ListTile(
                          title: const Text("Sale Report"),
                          onTap: () {
                            context.pushNamed(SalesReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("GR Details Report"),
                          onTap: () {
                            context.pushNamed(GrDetailsReportForm.routeName);
                          },
                        ),
                      ]),
                  ListTile(
                    leading: const Icon(Icons.bookmark_border_outlined),
                    title: const Text("BR Pending"),
                    onTap: () {
                      context.pushNamed(BrFilterForm.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.not_started_outlined),
                    title: const Text("Work In Progress Report"),
                    onTap: () {
                      context.pushNamed(WorkInProgressReport.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.not_started_outlined),
                    title: const Text("TDS Report"),
                    onTap: () {
                      context.pushNamed(TdsReportForm.routeName);
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: const Text("GST Return"),
                    children: [
                      ListTile(
                        title: const Text("B2B Report"),
                        onTap: () {
                          context.pushNamed(B2bReportForm.routeName,
                              queryParameters: {"type": "B2B"});
                        },
                      ),
                      ListTile(
                        title: const Text("B2C Report"),
                        onTap: () {
                          context.pushNamed(B2bReportForm.routeName,
                              queryParameters: {"type": "B2C"});
                        },
                      ),
                      ListTile(
                        title: const Text("B2CL Report"),
                        onTap: () {
                          context.pushNamed(B2bReportForm.routeName,
                              queryParameters: {"type": "B2CL"});
                        },
                      ),
                      ListTile(
                        title: const Text("GST HSN Summary"),
                        onTap: () {
                          context.pushNamed(GstHsnReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("CR/DB Note"),
                        onTap: () {
                          context.pushNamed(B2bReportForm.routeName,
                              queryParameters: {"type": "CRDR"});
                        },
                      ),
                      ListTile(
                        title: const Text("Doc. Type Report"),
                        onTap: () {
                          context.pushNamed(B2bReportForm.routeName,
                              queryParameters: {"type": "DOC"});
                        },
                      ),
                      ListTile(
                        title: const Text("Reverse Charge"),
                        onTap: () {
                          context.pushNamed(AddReverseCharge.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Reverse Charge Report"),
                        onTap: () {
                          context.pushNamed(ReverseChargeReportForm.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Upload GST R2B"),
                        onTap: () {
                          context.pushNamed(GstR2bUpload.routeName);
                        },
                      ),
                      // ListTile(
                      //   title: const Text("Generate IRN"),
                      //   onTap: () {
                      //     context.pushNamed(GenerateIrn.routeName);
                      //   },
                      // ),
                      ExpansionTile(
                        title: const Text("GST 2B"),
                        children: [
                          ListTile(
                            title: const Text("No Match"),
                            onTap: () {
                              context.pushNamed(GetB2bNoMatch.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Match"),
                            onTap: () {
                              context.pushNamed(GetB2bMatch.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Not-In"),
                            onTap: () {
                              context.pushNamed(GetB2bNotIn.routeName);
                            },
                          )
                        ],
                      )
                    ],
                  ),

                  ListTile(
                    title: const Text("Ledger"),
                    onTap: () {
                      context.pushNamed(Ledger.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Trial"),
                    onTap: () {
                      context.pushNamed(Trial.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Stock Value"),
                    onTap: () {
                      context.pushNamed(StockValueReportForm.routeName);
                    },
                  ),
                ],
              ),
            ),

            // SALES ORDER
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'SO'),
              child: ExpansionTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text("Sales Order"),
                children: [
                  ListTile(
                    title: const Text("Create Order"),
                    onTap: () {
                      context.pushNamed(SalesOrderDetails.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Create Advance Order"),
                    onTap: () {
                      context.pushNamed(SalesOrderAdvance.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Approval Request"),
                    onTap: () {
                      context.pushNamed(GetPendingApRequest.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Hold/Denied Orders Report"),
                    onTap: () {
                      context.pushNamed(HoldDeniedOrderReport.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Sales Order Details"),
                    onTap: () {
                      context.pushNamed(OrderReport.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Report"),
                    onTap: () {
                      context.pushNamed(SalesOrderReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Payment Pending"),
                    onTap: () {
                      context.pushNamed(PaymentPendingReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Sale Report"),
                    onTap: () {
                      context.pushNamed(SalesReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Short Qty"),
                    onTap: () {
                      context.pushNamed(SalesOrderShortQty.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Balance Report"),
                    onTap: () {
                      context.pushNamed(OrderBalanceReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Bank Statements"),
                    onTap: () {
                      context.pushNamed(BankReportFormSales.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Re-Order Balance Material"),
                    onTap: () {
                      context.pushNamed(ReOrderBalMatReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Convert GST Rate"),
                    onTap: () {
                      context.pushNamed(PostB2b.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Sale Item Report"),
                    onTap: () {
                      context.pushNamed(SaleItemReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("TOD Report"),
                    onTap: () {
                      context.pushNamed(TodReportForm.routeName);
                    },
                  ),
                  ExpansionTile(title: const Text("Export Order"), children: [
                    ListTile(
                      title: const Text("Add"),
                      onTap: () {
                        context.pushNamed(AddExportOrder.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Update"),
                      onTap: () {
                        context.pushNamed(GetExportOrder.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Report"),
                      onTap: () {
                        context.pushNamed(ExportOrderReport.routeName,
                            extra: true);
                      },
                    ),
                    ListTile(
                      title: const Text("Delete"),
                      onTap: () {
                        context.pushNamed(GetExportOrder.routeName,
                            extra: true);
                      },
                    ),
                  ]),
                  ListTile(
                    title: const Text("Export Invoice"),
                    onTap: () {
                      context.pushNamed(ExportInvoiceReport.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Cancel"),
                    onTap: () {
                      context.pushNamed(AddOrderCancel.routeName);
                    },
                  ),

                  ListTile(
                    title: const Text("Yearly Sales Report"),
                    onTap: () {
                      context.pushNamed(YearlyReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Yearly Category Sales Report"),
                    onTap: () {
                      context.pushNamed(YearlyCategorySalesReportForm.routeName);
                    },
                  ),
                ],
              ),
            ),

            // COSTING
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'CO'),
              child: ExpansionTile(
                  leading: const Icon(Icons.mode_standby_outlined),
                  title: const Text("Costing"),
                  children: [
                    ExpansionTile(
                        title: const Text("Wire Size"),
                        leading: const Icon(Icons.linear_scale_outlined),
                        children: [
                          ListTile(
                            title: const Text("Add"),
                            onTap: () {
                              context.pushNamed(WireSizeByMatno.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Wire Size With/Without TL"),
                            onTap: () {
                              context.pushNamed(WireSizeReport.routeName);
                            },
                          ),
                          // ListTile(
                          //   title: const Text("Wire Size Report"),
                          //   onTap: () {
                          //     context.pushNamed(WsReportForm.routeName);
                          //   },
                          // ),
                          ListTile(
                            title: const Text("Wire Size Assembly Report"),
                            onTap: () {
                              context.pushNamed(WsAssemblyReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Wire Size Material"),
                            onTap: () {
                              context.pushNamed(WsMatReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Old Wire Size Report"),
                            onTap: () {
                              context
                                  .pushNamed(OldWireSizeReportForm.routeName);
                            },
                          )
                        ]),
                    ExpansionTile(
                        title: const Text('Color'),
                        leading: const Icon(Icons.color_lens_outlined),
                        children: [
                          ListTile(
                            title: const Text("Add"),
                            onTap: () {
                              context.pushNamed(AddColor.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Update"),
                            onTap: () {
                              context.pushNamed(GetColor.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Report/Delete"),
                            onTap: () {
                              context.pushNamed(ColorReport.routeName);
                            },
                          ),
                        ]),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Resource"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(AddCostResource.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetCostResource.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report/Delete"),
                          onTap: () {
                            context.pushNamed(CostResourceReport.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Work Process"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(AddWorkProcess.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetWorkProcess.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report/Delete"),
                          onTap: () {
                            context.pushNamed(WorkProcessReport.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Part Assembly"),
                      leading: const Icon(Icons.linear_scale_outlined),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(PartAssemblyByMatno.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetPartAssembly.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(PartAssemblyReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Part Assembly Costing"),
                          onTap: () {
                            context.pushNamed(
                                PartAssemblyCostingReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text("Part Sub Assembly"),
                      leading: const Icon(Icons.subscript_outlined),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(PartSubAssemblyByMatno.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetPartSubAssembly.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context
                                .pushNamed(PartSubAssemblyReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Part Sub-assembly Costing"),
                          onTap: () {
                            context.pushNamed(
                                PartSubAssemblyCostingReportForm.routeName);
                          },
                        )
                      ],
                    ),
                    ExpansionTile(
                        title: const Text("Product Breakup"),
                        leading: const Icon(
                            Icons.production_quantity_limits_outlined),
                        children: [
                          ListTile(
                            title: const Text("Add"),
                            onTap: () {
                              context
                                  .pushNamed(ProductBreakupByMatno.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Update"),
                            onTap: () {
                              context.pushNamed(GetProductBreakup.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("Report"),
                            onTap: () {
                              context.pushNamed(
                                  ProductBreakupReportForm.routeName);
                            },
                          ),
                          ListTile(
                            title: const Text("PB Costing"),
                            onTap: () {
                              context.pushNamed(PbCostingReportForm.routeName);
                            },
                          ),

                          ListTile(
                            title: const Text("PB Cost Comparison"),
                            onTap: () {
                              context.pushNamed(PbCostComparisonReportForm.routeName);
                            },
                          ),
                          // ListTile(
                          //   title: const Text("Product Breakup Tech Details"),
                          //   onTap: () {
                          //     context.pushNamed(
                          //         AddProductBreakupTechDetails.routeName);
                          //   },
                          // ),
                        ]),
                    ExpansionTile(
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: const Text("Material Tech Details"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(AddMaterialTechDetails.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetMaterialTechDetails.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context
                                .pushNamed(DeleteMaterialTechDetails.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(
                                MaterialTechDetailReportForm.routeName);
                          },
                        )
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.mode_standby_outlined),
                      title: const Text("Product Final Standard"),
                      onTap: () {
                        context.pushNamed(AddProductFinalStandard.routeName);
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Material Incoming Standard"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(
                                AddMaterialIncomingStandard.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report/Delete"),
                          onTap: () {
                            context.pushNamed(MaterialIncomingStandardReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.mode_standby_outlined),
                      title: const Text("Part Search"),
                      onTap: () {
                        context.pushNamed(PartSearch.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mode_standby_outlined),
                      title: const Text("Not-In Bill Of Material"),
                      onTap: () {
                        context.pushNamed(NotInBillOfMaterial.routeName);
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("OB Material"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(ObMaterialScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetObMaterial.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Bulk Update"),
                          onTap: () {
                            context.pushNamed(ObMaterialBulkUpdate.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetObMaterial.routeName,
                                extra: true);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(ObMaterialReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Material Assembly"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(MaterialAssembly.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetMaterialAssembly.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(DeleteMaterialAssembly.routeName);
                          },
                        ),
                        // ListTile(
                        //   title: const Text("Report"),
                        //   onTap: () {
                        //     context.pushNamed(
                        //         MaterialAssemblyReportForm.routeName);
                        //   },
                        // ),
                        ListTile(
                          title: const Text("Material Assembly Costing"),
                          onTap: () {
                            context.pushNamed(
                                MaterialAssemblyCostingReportForm.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Material Assembly Comparison"),
                          onTap: () {
                            context.pushNamed(
                                MatAssemblyComparisonReportForm.routeName);
                          },
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.perm_device_info_outlined),
                          title: const Text("Material Assembly Details"),
                          children: [
                            ListTile(
                              title: const Text("Add"),
                              onTap: () {
                                context.pushNamed(
                                    MaterialAssemblyDetails.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Delete"),
                              onTap: () {
                                context.pushNamed(
                                    DeleteMaterialAssemblyDetails.routeName);
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.perm_device_info_outlined),
                          title: const Text("Material Assembly Processing"),
                          children: [
                            ListTile(
                              title: const Text("Add"),
                              onTap: () {
                                context.pushNamed(
                                    MaterialAssemblyProcessing.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Delete"),
                              onTap: () {
                                context.pushNamed(
                                    DeleteMaterialAssemblyProcessing.routeName);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Business Partner On Board"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(BusinessPartnerOnBoard.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetBpOnBoard.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetBpOnBoard.routeName,
                                extra: true);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(BpOnBoardReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Business Partner OB Material"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(BpObMaterial.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetBpObMaterial.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Bulk Update"),
                          onTap: () {
                            context.pushNamed(BpObMaterialBulkUpdate.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetBpObMaterial.routeName,
                                extra: true);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(BpObMaterialForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Material Assembly Tech Details"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(
                                MaterialAssemblyTechDetails.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context
                                .pushNamed(GetMatAssemblyTechDetails.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(
                                GetMatAssemblyTechDetails.routeName,
                                extra: true);
                          },
                        ),
                        // ListTile(
                        //   title: const Text("Report"),
                        //   onTap: () {
                        //     context.pushNamed(BpObMaterialForm.routeName);
                        //   },
                        // ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("Business Partner Processing"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(BpProcessing.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetBpProcessing.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetBpProcessing.routeName,
                                extra: true);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(BpProcessingReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.perm_device_info_outlined),
                      title: const Text("BP Breakup"),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(BpBreakup.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Update"),
                          onTap: () {
                            context.pushNamed(GetBpBreakup.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Delete"),
                          onTap: () {
                            context.pushNamed(GetBpBreakup.routeName,
                                extra: true);
                          },
                        ),
                        ListTile(
                          title: const Text("Report"),
                          onTap: () {
                            context.pushNamed(BpBreakupReportForm.routeName);
                          },
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.perm_device_info_outlined),
                          title: const Text("BP Breakup Details"),
                          children: [
                            ListTile(
                              title: const Text("Add"),
                              onTap: () {
                                context.pushNamed(BpBreakupDetails.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Delete"),
                              onTap: () {
                                context.pushNamed(
                                    DeleteBpBreakupDetails.routeName);
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(Icons.perm_device_info_outlined),
                          title: const Text("BP Breakup Processing"),
                          children: [
                            ListTile(
                              title: const Text("Add"),
                              onTap: () {
                                context
                                    .pushNamed(BpBreakupProcessing.routeName);
                              },
                            ),
                            ListTile(
                              title: const Text("Delete"),
                              onTap: () {
                                context.pushNamed(
                                    DeleteBpBreakupProcessing.routeName);
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          title: const Text("BP Breakup Summary"),
                          onTap: () {
                            context.pushNamed(BpBreakupSummaryReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                  ]),
            ),

            // PRODUCTION
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'PR' ||
                  provider.userInfo['roles'] == 'ST'),
              child: ExpansionTile(
                  leading: const Icon(Icons.not_started_outlined),
                  title: const Text("Production"),
                  children: [
                    ExpansionTile(
                      title: const Text('Manufacture'),
                      children: [
                        ListTile(
                          title: const Text("Add"),
                          onTap: () {
                            context.pushNamed(AddManufacturing.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Report/Delete"),
                          onTap: () {
                            context
                                .pushNamed(ManufacturingReportForm.routeName);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.not_started_outlined),
                      title: const Text("Advance Requirement"),
                      onTap: () {
                        context.pushNamed(AddAdvanceReq.routeName);
                      },
                    ),
                    ExpansionTile(
                      title: const Text('Inventory Requirement'),
                      children: [
                        ListTile(
                          title: const Text("Add Req. Auto"),
                          onTap: () {
                            context.pushNamed(AddReq.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text("Add Req. Manual"),
                          onTap: () {
                            context.pushNamed(AddReqDetails.routeName);
                          },
                        ),
                        // ListTile(
                        //   title: const Text("Report/Delete"),
                        //   onTap: () {
                        //     context.pushNamed(ManufacturingReportForm.routeName);
                        //   },
                        // ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.crisis_alert_outlined),
                      title: const Text("Req. Production Pending"),
                      onTap: () {
                        context.pushNamed(ReqProductionPending.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.crisis_alert_outlined),
                      title: const Text("Req. Packing Pending"),
                      onTap: () {
                        context.pushNamed(ReqPackingPending.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.crisis_alert_outlined),
                      title: const Text("Req. Packed Pending"),
                      onTap: () {
                        context.pushNamed(ReqPackedPending.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_open_outlined),
                      title: const Text("Req. Issue Pending"),
                      onTap: () {
                        context.pushNamed(ReqIssuePendingForm.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_open_outlined),
                      title: const Text("Job WorkOut Challan Clear"),
                      onTap: () {
                        context.pushNamed(AddJobWorkOutChallanClear.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.linear_scale_outlined),
                      title: const Text("Part Assembly Report"),
                      onTap: () {
                        context.pushNamed(PartAssemblyReportForm.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.subscript_outlined),
                      title: const Text("Part Sub Assembly Report"),
                      onTap: () {
                        context.pushNamed(PartSubAssemblyReportForm.routeName);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.production_quantity_limits_outlined),
                      title: const Text("Product Breakup Report"),
                      onTap: () {
                        context.pushNamed(ProductBreakupReportForm.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Wire Size With/Without TL"),
                      onTap: () {
                        context.pushNamed(WireSizeReport.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Wire Size Report"),
                      onTap: () {
                        context.pushNamed(WsReportForm.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Material Tech Details Report"),
                      onTap: () {
                        context
                            .pushNamed(MaterialTechDetailReportForm.routeName);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mode_standby_outlined),
                      title: const Text("Part Search"),
                      onTap: () {
                        context.pushNamed(PartSearch.routeName);
                      },
                    ),
                  ]),
            ),

            // STORE
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'ST'),
              child: ExpansionTile(
                title: const Text("Store"),
                leading: const Icon(Icons.home_outlined),
                children: [
                  ListTile(
                    title: const Text("GR Qty Clear Pending"),
                    onTap: () {
                      context.pushNamed(GrQtyClearPending.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Packing Pending"),
                    onTap: () {
                      context.pushNamed(OrderPackagingPending.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Goods Dispatch"),
                    onTap: () {
                      context.pushNamed(GetOrderGoodsDispatchPending.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Order Transport"),
                    onTap: () {
                      context.pushNamed(GetOrderTransportPending.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Req. Issue Pending"),
                    onTap: () {
                      context.pushNamed(ReqIssuePendingForm.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Req. Issue Summary"),
                    onTap: () {
                      context.pushNamed(ReqIssueSummary.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("GR Report"),
                    onTap: () {
                      context.pushNamed(GrReportForm.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text("Transport/Acknowledgement Slip"),
                    onTap: () {
                      context.pushNamed(TransportSlip.routeName);
                    },
                  ),
                ],
              ),
            ),

            // QUALITY
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'QA'),
              child: ExpansionTile(
                title: const Text("Quality"),
                leading: const Icon(Icons.home_outlined),
                children: [
                  ExpansionTile(
                    leading: const Icon(Icons.shopping_cart_outlined),
                    title: const Text("Material Tech Details"),
                    children: [

                      ListTile(
                        title: const Text("Report"),
                        onTap: () {
                          context.pushNamed(
                              MaterialTechDetailReportForm.routeName);
                        },
                      )
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Incoming QC Pending"),
                    onTap: () {
                      context.pushNamed(IncomingQcPendingForm.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.file_open_outlined),
                    title: const Text("Material Incoming Reading"),
                    onTap: () {
                      context.pushNamed(IncomingReportForm.routeName);
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.perm_device_info_outlined),
                    title: const Text("Material Incoming Standard"),
                    children: [
                      ListTile(
                        title: const Text("Add"),
                        onTap: () {
                          context.pushNamed(
                              AddMaterialIncomingStandard.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text("Report/Delete"),
                        onTap: () {
                          context.pushNamed(MaterialIncomingStandardReportForm.routeName);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // DOCUMNET UPLOAD
            Visibility(
              visible: (provider.userInfo['roles'] == 'AD' ||
                  provider.userInfo['roles'] == 'DO' ||
                  provider.userInfo['roles'] == 'FI'),
              child: ExpansionTile(
                leading: const Icon(Icons.bookmark_border_outlined),
                title: const Text("Document Upload"),
                children: [
                  ListTile(
                      title: const Text("Create BR"),
                      onTap: () {
                        context.pushNamed(CreateBillReceipt.routeName);
                      }),
                  ListTile(
                    // leading: const Icon(Icons.bookmark_border_outlined),
                    title: const Text("BR Report"),
                    onTap: () {
                      context.pushNamed(BrReportForm.routeName);
                    },
                  ),
                ],
              ),
            ),

            // EXTRAS
            ExpansionTile(
              leading: const Icon(Icons.person_add_alt_outlined),
              title: const Text("HR"),
              children: [
                ExpansionTile(
                  title: const Text("Attendance"),
                  children: [
                    ListTile(
                      title: const Text("Check-In"),
                      onTap: () {
                        checkIn(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Check-Out"),
                      onTap: () {
                        checkOut(context);
                      },
                    ),
                    ListTile(
                      title: const Text("Report"),
                      onTap: () {
                        context.pushNamed(GetAttendanceReport.routeName);
                      },
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.input_outlined),
                  title: const Text("Visit Info"),
                  children: [
                    ListTile(
                      title: const Text("Create"),
                      onTap: () {
                        context.pushNamed(AddVisitInfo.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Report"),
                      onTap: () {
                        context.pushNamed(GetVisitInfoReport.routeName);
                      },
                    )
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.document_scanner_outlined),
                  title: const Text("TA Claim"),
                  children: [
                    ListTile(
                      title: const Text("Create"),
                      onTap: () {
                        context.pushNamed(AddTaClaim.routeName);
                      },
                    ),
                    ListTile(
                      title: const Text("Report"),
                      onTap: () {
                        context.pushNamed(GetClaimReport.routeName);
                      },
                    )
                  ],
                ),
              ],
            ),
            ExpansionTile(
                leading: const Icon(Icons.file_open_outlined),
                title: const Text("Master Report"),
                children: [
                  ListTile(
                    title: const Text("Material Stock Report"),
                    onTap: () {
                      context.pushNamed(MatStockReportForm.routeName);
                    },
                  )
                ]),
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
