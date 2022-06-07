import 'dart:convert';

import 'package:flexwm/models/usem.dart';
import 'package:flexwm/screens/usem_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

class UserEmail extends StatefulWidget {
  final int forceFilter;
  const UserEmail({Key? key, required this.forceFilter}) : super(key: key);

  @override
  State<UserEmail> createState() => _UserEmailState();
}

class _UserEmailState extends State<UserEmail> {
  final List<SoUserEmail> _userEmailListData = [];

  @override
  void initState() {
    fetchSoUsersEmail(widget.forceFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _userEmailListData.length,
      itemBuilder: (BuildContext context, int index) {
        SoUserEmail nextSoUserEmail = SoUserEmail(
            _userEmailListData[index].id,
            _userEmailListData[index].userId,
            _userEmailListData[index].email,
            _userEmailListData[index].type);
        return UserEmailForm(
          soUserEmail: nextSoUserEmail,
        );
      },
    );
  }

  Future<List<SoUserEmail>> fetchSoUsersEmail(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restusem;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.forceFilter +
        '=' +
        forceFilter.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    _userEmailListData.addAll(
        parsed.map<SoUserEmail>((json) => SoUserEmail.fromJson(json)).toList());

    setState(() {});
    return parsed
        .map<SoUserEmail>((json) => SoUserEmail.fromJson(json))
        .toList();
  }
}
