import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

import '../models/data.dart';
import '../ui/input_decorations.dart';

class AutocompleteExampleApp extends StatefulWidget {
  final String programCode;
  final String label;
  final Function callback;
  final int autoValue;

  const AutocompleteExampleApp({
    Key? key,
    required this.programCode,
    required this.label,
    required this.callback,
    required this.autoValue,
  }) : super(key: key);

  @override
  State<AutocompleteExampleApp> createState() => _AutocompleteBasicUserExample();
}


class _AutocompleteBasicUserExample extends State<AutocompleteExampleApp> {
  late Function _callback;
  late int _autoValue = -1;
  late List<Data> dataList = [];

  @override
  void initState(){
    super.initState();
    _callback = widget.callback;
    _autoValue = widget.autoValue;
    getData();
  }

/*  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];*/

  static String _displayStringForOption(Data option) => option.label;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Data>(
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: InputDecorations.authInputDecoration(
              labelText: "Vendedor",
              prefixIcon: Icons.account_balance_wallet_outlined
          ),
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
        );
      },
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Data>.empty();
        }
        return dataList.where((Data option) {
          return option.label.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Data selection) {
        setState((){
          _autoValue = selection.id;
          _callback(_autoValue);
        });
        debugPrint('You just selected ${_displayStringForOption(selection)}');
      },
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
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      dataList =  parsed.map<Data>((json) => Data.fromJson(json)).toList();
      // dataList = json.decode(response.body);
      dataList.add(Data(-1, widget.label));
    });
  }
}