import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/service/network_service.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final String? url;

  const Hyperlink({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(

      child: Text(
        text,
        style: TextStyle(color: url != null ? Colors.blue : Colors.black),
      ),
      onTap: () => _launchURL(url),
    );
  }

  void _launchURL(String? url) async {
    final Uri uri = Uri.parse("${NetworkService.baseUrl}${url ?? ""}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
