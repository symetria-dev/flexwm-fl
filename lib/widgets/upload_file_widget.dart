import 'package:file_picker/file_picker.dart';
import 'package:flexwm/widgets/alert_diaog.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

class UploadFile extends StatefulWidget {
  final String? initialruta;
  final String programCode;
  final String fielName;
  final String id;
  final String label;
  const UploadFile(
      {Key? key,
      this.initialruta,
      required this.programCode,
      required this.fielName,
      required this.id,
      required this.label})
      : super(key: key);

  @override
  State<UploadFile> createState() => _uploadFile();
}

// ignore: camel_case_types
class _uploadFile extends State<UploadFile> {
  String? _ruta;
  late String _programCode;
  late String _fielName;
  late String _label;
  late String _id;
  bool _hasUpload = false;

  @override
  void initState() {
   
    _programCode = widget.programCode;
    _fielName = widget.fielName;
    _id = widget.id;
    _label = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Padding(
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
              ),
              if (_hasUpload)
                IconButton(
                  color: Colors.blue,
                  onPressed: () =>
                      sendFile(_ruta!, _programCode, _fielName, _id),
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.red,
                  ),
                ),
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
}
