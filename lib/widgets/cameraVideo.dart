import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:image_cropper/image_cropper.dart';

class CameraVideo extends StatefulWidget {
  final CameraController cameraController;
  const CameraVideo({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  State<CameraVideo> createState() => _CameraVideoState();
}

class _CameraVideoState extends State<CameraVideo> {

  late CameraController _cameraController;
  bool record = false;

  @override
  void initState() {
    super.initState();
    _cameraController = widget.cameraController;
  }

/*  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();
  }*/

  void startRecording() {
    setState(() {
      record = true;
    });
    if (_cameraController != null && _cameraController.value.isInitialized) {
      _cameraController.startVideoRecording();
    }
  }

  void stopRecording() async {
    setState(() {
      record = false;
    });
    if (_cameraController != null && _cameraController.value.isRecordingVideo) {
      final XFile videoFile = await _cameraController.stopVideoRecording();
      // Ahora, puedes enviar videoFile al servidor.
      Navigator.pop(context, videoFile.path);
      // uploadVideo(videoFile.path);
    }
  }
/*
  void uploadVideo(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('tu_url_del_servidor'));
    request.files.add(await http.MultipartFile.fromPath('video', filePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Video subido exitosamente');
      } else {
        print('Error al subir el video. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al subir el video: $error');
    }
  }*/

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grabar y subir video'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if(!record)
              ElevatedButton(
                onPressed: startRecording,
                child: Text('Iniciar grabación'),
              ),
              if(record)
              ElevatedButton(
                onPressed: stopRecording,
                child: Text('Detener grabación'),
              ),
            ],
          ),
        ],
      ),
    );
  }

 /* afterTakePhoto(CroppedFile file) {
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
  }*/
}
