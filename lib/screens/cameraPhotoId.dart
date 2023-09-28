import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:image_cropper/image_cropper.dart';

class CameraPhotoId extends StatefulWidget {
  const CameraPhotoId({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraPhotoId> createState() => _CameraPhotoIdState();
}

class _CameraPhotoIdState extends State<CameraPhotoId> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No se encontró ninguna cámara',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(
                snapshot.data!.first,
                CardOverlay.byFormat(
                    OverlayFormat.cardID3), (XFile file) async {
              CroppedFile? cropper = await ImageCropper().cropImage(
                sourcePath: file.path,
                aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
                aspectRatioPresets: [
                  CropAspectRatioPreset.ratio3x2,
                ],
                compressQuality: 40,
                maxHeight: 600,
                maxWidth: 600,
                // compressFormat: ImageCompressFormat.jpg,
                /*                            androidUiSettings: AndroidUiSettings(
                                  toolbarColor: Colors.blue,
                                  toolbarTitle: "Recorta la imagen",
                                  toolbarWidgetColor: Colors.white,
                                  backgroundColor: Colors.white)*/
              );
              afterTakePhoto(cropper!);
            },
                info:
                    'Coloque su tarjeta de identificación dentro del rectángulo y asegúrese de que la imagen sea perfectamente legible.',
                label: 'Escaneando');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Obteniendo cámaras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }

  afterTakePhoto(CroppedFile file) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) {
        CardOverlay overlay = CardOverlay.byFormat(OverlayFormat.cardID3);
        return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: Colors.black,
            title: const Text('Captura',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            actions: [
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close)),
              OutlinedButton(
                  onPressed: () {
                    sendFile()
                        .then((value) => Navigator.pop(context, file.path));
                  },
                  child: const Icon(Icons.check)),
            ],
            content: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: overlay.ratio!,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.center,
                      image: FileImage(
                        File(file.path),
                      ),
                    )),
                  ),
                )));
      },
    );
  }

  Future<bool> sendFile() async {
    Navigator.pop(context);
    return true;
  }
}
