// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:urlnav2/constants/style.dart';
import 'package:urlnav2/pages/files/components/dropped_file.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({Key key, this.onDroppedFile}) : super(key: key);

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  DropzoneViewController dropzoneController;
  bool isDropzoneHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final dropzoneColor = isDropzoneHighlighted ? Colors.black54 : dark;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            // height: 360,
            color: dropzoneColor,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.white,
                strokeWidth: 3,
                dashPattern: const [8, 4],
                radius: const Radius.circular(10),
                child: Stack(
                  children: [
                    DropzoneView(
                        onHover: () =>
                            setState(() => isDropzoneHighlighted = true),
                        onLeave: () =>
                            setState(() => isDropzoneHighlighted = false),
                        onCreated: (dropzoneController) =>
                            this.dropzoneController = dropzoneController,
                        onDrop: acceptFile),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload,
                          color: Colors.white,
                          size: 60,
                        ),
                        const Text(
                          'Drag & Drop your files here',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'OR:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              primary: light,
                              shape: const RoundedRectangleBorder()),
                          icon: Icon(
                            Icons.attach_file,
                            size: 28,
                            color: dark,
                          ),
                          label: const Text('Attach Files',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                          onPressed: () async {
                            final events = await dropzoneController.pickFiles();
                            if (events.isEmpty) return;
                            acceptFile(events.first);
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Maximum file size: 1 GB.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<dynamic> acceptFile(dynamic event) async {
    final name = event.name; // or: await dropzoneController.getFilename(event);
    final mime = await dropzoneController.getFileMIME(event);
    final size = await dropzoneController.getFileSize(event);
    final url = await dropzoneController.createFileUrl(event);
    final bytes = await dropzoneController.getFileData(event);

    if (kDebugMode) {
      print(name);
      print(mime);
      print(size);
      print(url);
    }

    // ignore: unused_local_variable
    final droppedFile =
        DroppedFile(url: url, name: name, mime: mime, size: size, bytes: bytes);

    widget.onDroppedFile(droppedFile);

    setState(() {
      isDropzoneHighlighted = false;
    });
  }
}
