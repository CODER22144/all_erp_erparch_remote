import 'dart:io';
import 'package:fintech_new_web/features/camera/service/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatefulWidget {
  final Function setImagePath;
  final bool showCamera;
  final String? label;

  const CameraWidget(
      {super.key, required this.setImagePath, required this.showCamera, this.label});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  XFile? imagePath;
  @override
  Widget build(BuildContext context) {
    Camera camera = Camera();

    return SafeArea(
      child: Material(
        child: InkWell(
            onTap: () async {
              var blobPath = await camera.showPicker(
                context,
              );
              widget.setImagePath(blobPath?.path, blobPath?.name);
              setState(() {
                imagePath = blobPath;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: null,
                      child: Text(
                        widget.label != null ? widget.label! : "Choose File",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )),
                  imagePath?.path != "" && imagePath?.path != null
                      ? const Text(
                          "File Uploaded Successfully",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.green),
                        )
                      : const SizedBox()
                ],
              ),
            )),
      ),
    );
  }
}
