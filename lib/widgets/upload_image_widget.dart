import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import 'alert_diaog.dart';

class UploadImage extends StatefulWidget {
  final String? initialruta;
  final String programCode;
  final String fielName;
  final String id;

  const UploadImage(
      {Key? key,
      this.initialruta,
      required this.programCode,
      required this.fielName,
      required this.id})
      : super(key: key);

  @override
  State<UploadImage> createState() => _uploadImage();
}

// ignore: camel_case_types
class _uploadImage extends State<UploadImage> {
  String? _ruta;
  String? _initialruta;
  late String _programCode;
  late String _fielName;
  late String _id;
  bool _hasUpload = false;

  @override
  void initState() {
    _initialruta = widget.initialruta;
    _programCode = widget.programCode;
    _fielName = widget.fielName;
    _id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              (_initialruta != null)
                  ? CircleAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage(
                        _initialruta!,
                      ),
                    )
                  : (_ruta == null)
                      ? const CircleAvatar(
                          maxRadius: 50,
                        )
                      : CircleAvatar(
                          maxRadius: 50,
                          backgroundImage: FileImage(File(_ruta!)),
                        ),
              Positioned(
                left: 70,
                child: CircleAvatar(
                  maxRadius: 15,
                  backgroundColor: params.bgColor,
                  child: IconButton(
                      padding: const EdgeInsets.all(5),
                      color: const Color.fromRGBO(0, 130, 146, 1),
                      iconSize: 20,
                      onPressed: () => Platform.isIOS
                          ? displayDialogIos(context)
                          : displayDialogAndroid(context),
                      icon: const Icon(Icons.camera_alt_outlined)),
                ),
              ),
              if (_hasUpload)
                Positioned(
                  top: 5,
                  child: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: params.bgColor,
                    child: IconButton(
                        padding: const EdgeInsets.all(5),
                        color: const Color.fromRGBO(0, 130, 146, 1),
                        iconSize: 20,
                        onPressed: () =>
                            sendFile(_ruta!, _programCode, _fielName, _id),
                        icon: const Icon(Icons.upload)),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  sendFile(String ruta, String programCode, String fieldName, String id) async {
    final request = http.MultipartRequest('POST',
        Uri.parse(params.getAppUrl(params.instance) + 'uploadfileservelet'));

    request.fields['programCode'] = programCode;
    request.fields['fieldName'] = fieldName;
    request.fields['id'] = id;

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Cookie': params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
    };

    request.headers.addAll(headers);
    var file = await http.MultipartFile.fromPath('file', ruta);

    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == params.servletResponseScOk) {
      resultMessage('Subido con exito', context);
      setState(() {
        _hasUpload = false;
      });
    } else {
      resultMessage(response.toString(), context);
    }
  }

  openCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
        imageQuality: 100,
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front);

    setState(() {
      Navigator.pop(context);
      _ruta = image?.path;
      if (_ruta != null) _hasUpload = true;
      _initialruta = null;
    });
  }

  openGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      imageQuality: 100,
      source: ImageSource.gallery,
    );
    setState(() {
      Navigator.pop(context);
      _ruta = image?.path;
      if (_ruta != null) _hasUpload = true;
      _initialruta = null;
    });
  }

  void displayDialogAndroid(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Camara'),
                    IconButton(
                      iconSize: 40,
                      onPressed: () => openCamera(),
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Galeria'),
                    IconButton(
                      iconSize: 40,
                      onPressed: () => openGallery(),
                      icon: const Icon(Icons.image),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  //Alerta usando cupertino(estilos di IOS)
  void displayDialogIos(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Material(
              color: const Color.fromRGBO(255, 255, 255, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Camara'),
                      IconButton(
                        iconSize: 40,
                        onPressed: () => openCamera(),
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Galeria'),
                      IconButton(
                        iconSize: 40,
                        onPressed: () => openGallery(),
                        icon: const Icon(Icons.image),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
