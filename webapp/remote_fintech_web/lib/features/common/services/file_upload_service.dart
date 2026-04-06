import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../network/service/network_service.dart';

class FileUploadService {
  Future<XFile?> getImage(String source) async {
    XFile? image = await ImagePicker().pickImage(
        source: source.toLowerCase() == 'camera'
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 65);
    return image;
  }

  Future<String> getBlobUrl(String blobPath) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${NetworkService.baseUrl}/upload/'));
    if (kIsWeb) {
      // Fetch the blob
      final response = await http.get(Uri.parse(blobPath));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;

        // Create a file name
        final String fileName =
            "${DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000}.png";

        // Create a multipart file
        final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: MediaType('image', 'png'),
        );

        // Add the multipart file to the request
        request.files.add(multipartFile);
      }
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', blobPath));
    }
    request.headers.addAll(headers);

    http.StreamedResponse resp = await request.send();
    if (resp.statusCode == 201) {
      return jsonDecode(await resp.stream.bytesToString())["file"];
    }
    return "";
  }

  Future<XFile?> showPicker(context, {provider, bool? removeImage}) async {
    XFile? ImagePath;
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Upload File"),
                    onTap: () async {
                      ImagePath = await getImage('gallery');
                      if (provider != null) {
                        provider.setCameraImagePath(ImagePath);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  Visibility(
                    visible: !kIsWeb,
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Camera"),
                      onTap: () async {
                        ImagePath = await getImage('camera');
                        if (provider != null) {
                          provider.setCameraImagePath(ImagePath);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: removeImage != null && removeImage == true,
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(Icons.cancel),
                      title: const Text("Remove Image"),
                      onTap: () async {
                        // ImagePath = "remove";
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ));
        });
    return ImagePath;
  }
}
