import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

class DropdownWidget extends StatefulWidget {
  final Function callback;
  final String dropdownValue;
  final String programCode;
  final String label;

  const DropdownWidget({
    Key? key,
    required this.callback,
    required this.dropdownValue,
    required this.programCode,
    required this.label,
  }) : super(key: key);

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late String _dropdownValue = '-1';
  late Function _callback;
  late List dataList = [];

  @override
  void initState() {
    super.initState();
    _callback = widget.callback;
    _dropdownValue = widget.dropdownValue;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.blueGrey),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.blueGrey,
                    ),
                    value: _dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                        _callback(_dropdownValue);
                      });
                    },
                    items: dataList.map((e) {
                      return DropdownMenuItem(
                        child: Text(e['label']),
                        value: e['id'].toString(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getData() async {
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'dropdownlist;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'programCode': widget.programCode,
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
            params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
    );

    setState(() {
      dataList = json.decode(response.body);
      dataList.add({"id": -1, "label": "| " + widget.label + " | "});
    });
  }
}
