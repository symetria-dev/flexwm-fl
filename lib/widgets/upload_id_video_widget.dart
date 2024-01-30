import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/screens/cameraPhotoId.dart';
import 'package:flexwm/ui/input_decorations.dart';
import 'package:flexwm/widgets/alert_diaog.dart';
import 'package:flexwm/widgets/cameraVideo.dart';
import 'package:flexwm/widgets/show_image.dart';
import 'package:flexwm/widgets/show_video.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../routes/app_routes.dart';
import '../screens/pdf_view.dart';

class UploadIdVideo extends StatefulWidget {
  final String? initialRuta;
  final String programCode;
  final String fielName;
  final String id;
  final String label;
  final Function callBack;
  final String? idGuarantee;
  const UploadIdVideo(
      {Key? key,
      this.initialRuta,
      required this.programCode,
      required this.fielName,
      required this.id,
      required this.label,
      required this.callBack,
      this.idGuarantee,})
      : super(key: key);

  @override
  State<UploadIdVideo> createState() => uploadIdVideo();
}

// ignore: camel_case_types
class uploadIdVideo extends State<UploadIdVideo> {
  String? _ruta;
  late String _programCode;
  late String _fielName;
  late String _label;
  late String _id;
  bool _hasUpload = false;
  late String _initialRuta = '';
  late String _idGuarantee ='';
  late Function _callback;
  bool isLoading = false;

  @override
  void initState() {
    print('Cookie: ${params.jSessionIdQuery.toUpperCase()} ${params.jSessionId}');
    _programCode = widget.programCode;
    _fielName = widget.fielName;
    _id = widget.id;
    _label = widget.label;
    _callback = widget.callBack;
    print('id video - $_id - $_callback');
    if(widget.initialRuta != ''){
      _initialRuta = widget.initialRuta!;
    }
    if(widget.idGuarantee != ''){
      _idGuarantee = widget.idGuarantee!;
      print('id guaranty video - $_idGuarantee');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String urlDoc = params.getAppUrl(params.instance)+
        params.uploadFiles+'/'+_initialRuta;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                _label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
                      _navigateAndDisplaySelection(context);
                    },
                    icon: const Icon(
                      Icons.file_open, color: Colors.teal,)
                ),
                if (_hasUpload)
                  IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      //se ejecuta callback por si hay datos que actualizar antes de enviar
                      setState(() {
                        _callback(true);
                      });
                      sendFile(_ruta!, _programCode, _fielName, _id);
                    },
                    icon: const Icon(
                      Icons.upload,
                      color: Colors.red,
                    ),
                  ),
                if(_initialRuta != '')
                IconButton(
                    onPressed: () async {
                      String file = _initialRuta;
                      final dot = file.indexOf('.');
                      String type = file.substring(dot, file.length);
                      if(type == '.pdf' || type == '.PDF'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfView(url: urlDoc,),
                          ),
                        );
                        // _showModalPdf(context,urlDoc);
                      }else{
                         ShowVideoAlert(context, urlDoc);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_red_eye, color: Colors.teal,)
                ),

              ],
            ),
          ],
        ),
        if(isLoading)
          const LinearProgressIndicator(),
      ],
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    late CameraController _cameraController;
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          CameraVideo(cameraController: _cameraController,)
      ),
    );

    // Después de que la pantalla de selección devuelva un resultado,
    // oculta cualquier snackbar previo y muestra el nuevo resultado.
    setState(() {
      _ruta = result;
      if(_ruta != null) _hasUpload = true;
    });
  }

  void updateData(String initialRuta){
    setState(() {
      _initialRuta = initialRuta;
    });
  }

  void updateId(String id){
    setState(() {
      _id = id;
    });
  }

  sendFile(String ruta, String programCode, String fieldName, String id) async {
    setState((){isLoading = true;});
    print('object sendfile $ruta - $programCode - $fieldName - $id');
    _callback(true);
    final request = http.MultipartRequest('POST',
        Uri.parse(params.getAppUrl(params.instance) + 'uploadfileservelet'));

    request.fields['programCode'] = programCode;
    request.fields['fieldName'] = fieldName;
    request.fields['id'] = id;
    if(_idGuarantee != '') {
      request.fields['idGuarantee'] = _idGuarantee;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Cookie': params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
    };

    request.headers.addAll(headers);

    var file = await http.MultipartFile.fromPath('file', ruta);

    request.files.add(file);

    var response = await request.send();
    // _initialRuta = response.;

    if (response.statusCode == params.servletResponseScOk) {
      print('segun exitoso');
      resultMessage('Subido con éxito' , context);
      _callback(false);
      setState(() {
        isLoading = false;
        _hasUpload = false;
      });
    // }
    // else if(response.statusCode == 1){
    //   resultMessage('Identidad validada con éxito' , context);
    //   _callback(false);
    //   setState(() {
    //     _hasUpload = false;
    //   });
    // }else if(response.statusCode == 2){
    //   resultMessage('Los documentos anexos no cumplen los requisitos mínimos' , context);
    //   _callback(false);
    //   setState(() {
    //     _hasUpload = false;
    //   });

    }else{
      _callback(false);
      print('no exitoso');
      setState((){isLoading = false;});
      resultMessage(response.toString(), context);
    }
  }
}
