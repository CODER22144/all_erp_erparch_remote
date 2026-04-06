// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../common/widgets/pop_ups.dart';
import '../utility/services/geo_location.dart';

void checkIn(BuildContext context) async {
  NetworkService networkService = NetworkService();
  Position currentLocation = await getCurrentLocation();
  http.StreamedResponse result = await networkService.post("/checkin/", {
    "geoCheckIn": "${currentLocation.latitude} , ${currentLocation.longitude}"
  });
  var message = jsonDecode(await result.stream.bytesToString());
  if (result.statusCode == 200) {
    await showAlertDialog(context, "You CheckIn is Done", "Continue", false);
  } else if (result.statusCode == 400) {
    await showAlertDialog(
        context, message['message'].toString(), "Continue", false);
  } else if (result.statusCode == 500) {
    await showAlertDialog(context, message['message'], "Continue", false);
  } else {
    await showAlertDialog(context, message['message'], "Continue", false);
  }
}

void checkOut(BuildContext context) async {
  NetworkService networkService = NetworkService();
  Position currentLocation = await getCurrentLocation();
  http.StreamedResponse result = await networkService.post("/checkout/", {
    "geoCheckOut": "${currentLocation.latitude} , ${currentLocation.longitude}"
  });
  var message = jsonDecode(await result.stream.bytesToString());
  if (result.statusCode == 200) {
    await showAlertDialog(context, "You Check Out is Done", "Continue", false);
  } else if (result.statusCode == 400) {
    await showAlertDialog(
        context, message['message'].toString(), "Continue", false);
  } else if (result.statusCode == 500) {
    await showAlertDialog(context, message['message'], "Continue", false);
  } else {
    await showAlertDialog(context, message['message'], "Continue", false);
  }
}
