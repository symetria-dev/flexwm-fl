import 'dart:convert';

import 'package:flexwm/drawer.dart';
import 'package:flexwm/screens/user_form.dart';
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../models/user.dart';
import 'package:flexwm/common/utils.dart' as utils;

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserList createState() => _UserList();
}

class _UserList extends State<UserList> {
  List<SoUser> userListData = [];
  bool isLoading = false;

  //ate Future<List<SoUser>> _futureSoCustomers;

  @override
  void initState() {
    // _loadMoreVertical();
    //fetchSoCustomers(userListData.length);
    super.initState();
    fetchSoCustomers(userListData.length);
    _loadMoreVertical();
  }

  // Traer mas datos
  Future _loadMoreVertical() async {
    setState(() {
      isLoading = true;
    });

    // Add in an artificial delay
    await Future.delayed(const Duration(seconds: 2));

    fetchSoCustomers(userListData.length);
    // _futureSoCustomers = fetchSoCustomers(customerListData.length);
    setState(() {
      isLoading = false;
    });
  }

  // Genera la peticion de datos al servidor
  Future<List<SoUser>> fetchSoCustomers(int offset) async {
    String url = params.getAppUrl(params.instance) +
        'restuser'
            ';' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        params.offsetQuery +
        '=' +
        offset.toString();
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    userListData
        .addAll(parsed.map<SoUser>((json) => SoUser.fromJson(json)).toList());
    return parsed.map<SoUser>((json) => SoUser.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      // backgroundColor: Color.fromRGBO(171, 178, 185, 1),
      appBar: AppBarStyle.authAppBarFlex(title: "Usuarios"),
      body: LazyLoadScrollView(
        isLoading: isLoading,
        onEndOfPage: () => _loadMoreVertical(),
        child: Scrollbar(
          child: ListView(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userListData.length,
                  itemBuilder: (context, int index) =>
                      _UserInfo(userListData[index], index)),
            ],
          ),
        ),
      ),
     /* floatingActionButton: FloatingActionButton(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color.fromRGBO(0, 130, 146, 1),
                Color.fromRGBO(112, 169, 179, 1.0)
              ])),
        ),
        onPressed: () {
*//*          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewUserForm()),
          );*//*
        },
      ),*/
    );
  }
}

class _UserInfo extends StatelessWidget {
  final SoUser user;
  final int index;
  const _UserInfo(this.user, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserFormScreen(id: user.id.toString()),
          ),
        ),
        leading: (user.photo.isEmpty)
            ? const CircleAvatar(
                child: Icon(Icons.person, color: Colors.green),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(
                  params.getAppUrl(params.instance) +
                      params.uploadFiles +
                      '/' +
                      user.photo,
                ),
              ),
        title: Text('$index :' + user.firstname),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  utils.makeMail(user.email);
                },
                icon: const Icon(Icons.email)),
          ],
        ),
      ),
    );
  }
}
