import 'dart:convert';
import 'package:flexwm/common/filters.dart';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

class DropdownWidgetCrmt extends StatefulWidget {
  final Function callback;
  final String dropdownValue;
  final String programCode;
  final String label;
  final List<SoFilters>? filterList;
  final String supplierId;

  const DropdownWidgetCrmt({
    Key? key,
    required this.callback,
    required this.dropdownValue,
    required this.programCode,
    required this.label,
    this.filterList,
    required this.supplierId,
  }) : super(key: key);

  @override
  State<DropdownWidgetCrmt> createState() => dropdownWidgetStateCrmt();
}

class dropdownWidgetStateCrmt extends State<DropdownWidgetCrmt> {
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
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Colors.blueGrey,
                    ),
                    value: getValue(_dropdownValue),
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
                        onTap: () {
                          print("tap credit motive");
                        },
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

  // se hace esta validación porque si no hay un item con id manda un error
  String getValue(String value) {
    int index = -1;

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['id'].toString() == value) {
        index = 1;
      }
    }

    if (index < 0) value = '-1';

    return value;
  }

  Future getDataAfterTapAgency(String supplierId) async {
    final response = await http.post(
        Uri.parse(params.getAppUrl(params.instance) +
            'dropdownlistcrmt;' +
            params.jSessionIdQuery),
        headers: <String, String>{
          'programCode': widget.programCode,
          'supplierId': supplierId,
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Cookie':
              params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
        },
        body: json.encode(widget.filterList));

    setState(() {
      dataList = json.decode(response.body);
      dataList.add({"id": -1, "label": widget.label});
    });
  }

  Future getAllDataAfterTapAgency() async {
    final response = await http.post(
        Uri.parse(params.getAppUrl(params.instance) +
            'dropdownlistcrmt;' +
            params.jSessionIdQuery),
        headers: <String, String>{
          'programCode': widget.programCode,
          'supplierId': '',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Cookie':
              params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
        },
        body: json.encode(widget.filterList));

    setState(() {
      dataList = json.decode(response.body);
      dataList.add({"id": -1, "label": widget.label});
    });
  }

  Future getData() async {
    final response = await http.post(
        Uri.parse(params.getAppUrl(params.instance) +
            'dropdownlistcrmt;' +
            params.jSessionIdQuery),
        headers: <String, String>{
          'programCode': widget.programCode,
          'supplierId': widget.supplierId,
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Cookie':
              params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
        },
        body: json.encode(widget.filterList));

    setState(() {
      dataList = json.decode(response.body);
      dataList.add({"id": -1, "label": widget.label});
    });
  }
}
