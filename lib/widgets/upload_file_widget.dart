import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flexwm/widgets/alert_diaog.dart';
import 'package:flexwm/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../screens/pdf_view.dart';

class UploadFile extends StatefulWidget {
  final String? initialRuta;
  final String programCode;
  final String fielName;
  final String id;
  final String? label;
  final Function callBack;
  final String? idGuarantee;
  final IconData? icono;
  const UploadFile(
      {Key? key,
      this.initialRuta,
      required this.programCode,
      required this.fielName,
      required this.id,
      required this.label,
      required this.callBack,
        this.idGuarantee,
        this.icono,
      })
      : super(key: key);

  @override
  State<UploadFile> createState() => uploadFile();
}

// ignore: camel_case_types
class uploadFile extends State<UploadFile> {
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
    _programCode = widget.programCode;
    _fielName = widget.fielName;
    _id = widget.id;
    _label = widget.label!;
    _callback = widget.callBack;
    if(widget.initialRuta != ''){
      _initialRuta = widget.initialRuta!;
    }
    if(widget.idGuarantee != ''){
      _idGuarantee = widget.idGuarantee!;
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
                /*SizedBox(
                  width: 200,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecorations.authInputDecoration(
                        labelText: _label,
                        prefixIcon: Icons.file_copy_outlined),
                    onTap: ()async {
                      final result = await FilePicker.platform
                          .pickFiles(allowMultiple: false);
                      if (result == null) return;
                      final file = result.files.first;
                      setState(() {
                        _ruta = file.path;
                        if (_ruta != null) _hasUpload = true;
                      });
                    },
                  ),
                ),*/
               /* Padding(
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    10,
                    0,
                    5,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(allowMultiple: false);
                      if (result == null) return;
                      final file = result.files.first;
                      setState(() {
                        _ruta = file.path;
                        if (_ruta != null) _hasUpload = true;

                      });
                    },
                    child: const Text("Seleccionar Archivo"),
                    style: ElevatedButton.styleFrom(
                        elevation: 6,
                        primary: const Color.fromARGB(255, 13, 109, 189)),
                  ),
                ),*/
                IconButton(
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(allowMultiple: false);
                      if (result == null) return;
                      final file = result.files.first;
                      setState(() {
                        _ruta = file.path;
                        if (_ruta != null) _hasUpload = true;
                      });
                    },
                    icon: const Icon(
                      Icons.file_open,
                      color: Colors.teal,)
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
                        ShowImageAlert(context, urlDoc);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_red_eye, color: Colors.teal,)
                ),
              ],
            ),
          ],
        ),
      ],
    );
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
      setState(() {
        isLoading = false;
      });
      resultMessage(response.toString(), context);
    }
  }
}
