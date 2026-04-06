import 'dart:typed_data';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import '../services/file_upload_service.dart';

class FileUploadField extends StatefulWidget {
  final FormUI fieldDetails;
  final String feature;
  final bool showCamera;

  const FileUploadField(
      {super.key,
      this.showCamera = false,
      required this.fieldDetails,
      required this.feature});

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  String imagePath = "";
  String fileName = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    FileUploadService cameraService = FileUploadService();

    return SafeArea(
      child: Material(
        child: InkWell(
          onTap: () async {
            var imageFile = await cameraService.showPicker(
              context,
            );
            final response = await http.get(Uri.parse(imageFile?.path ?? ""));
            if (response.statusCode == 200) {
              final Uint8List bytes = response.bodyBytes;
              final http.MultipartFile multipartFile =
                  http.MultipartFile.fromBytes(
                widget.fieldDetails.id,
                bytes,
                filename: imageFile?.name,
                contentType: MediaType('image', 'png'),
              );
              GlobalVariables.multipartRequest.files.add(multipartFile);
              setState(() {
                imagePath = imageFile!.path;
                fileName = imageFile!.name;
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: screenWidth * 0.09,
            width: screenHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black12,
            ),
            child: Column(
              children: [
                imagePath != ""
                    ? const Icon(Icons.file_present_outlined)
                    : const Icon(Icons.file_upload_outlined),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    fileName != "" ? fileName : widget.fieldDetails.name,
                    style: const TextStyle(
                        color: Color(0xFF707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
