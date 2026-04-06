import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/pop_ups.dart';

class StepperForm extends StatefulWidget {
  static const String routeName = '/stepForm';
  const StepperForm({super.key});

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Stepper Form Widget",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blueAccent),
      body: Center(
        child: SizedBox(
          width: GlobalVariables.deviceWidth / 2,
          child: Stepper(
              currentStep: currentStep,
              onStepContinue: () {
                final lastStep = currentStep == 2;

                if (lastStep) {
                  showAlertDialog(
                      context, "Your Records are submitted?", "OKAY", false);
                }

                if (!lastStep) {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                setState(() {
                  currentStep -= 1;
                });
              },
              controlsBuilder: (context, details) {
                final lastStep = currentStep == 2;
                return Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.lightBlue),
                              ),
                              child: Text(lastStep ? "SAVE" : "NEXT",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)))),
                      const SizedBox(width: 10),
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.redAccent),
                                ),
                                onPressed: details.onStepCancel,
                                child: const Text("BACK",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))))
                    ],
                  ),
                );
              },
              steps: [
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 0,
                    title: const Text("Personal Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Last Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Date Of Birth",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                      ],
                    )),
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 1,
                    title: const Text("Work Experience",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Company Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Last Working Day",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Notice Period",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                      ],
                    )),
                Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep == 2,
                    title: const Text("Bank Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Bank Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Account No.",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "IFSC Code",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)))),
                        ),
                      ],
                    ))
              ],
              type: StepperType.horizontal),
        ),
      ),
    );
  }
}
