import 'dart:convert';

import 'package:flexwm/models/usem.dart';
import 'package:flexwm/screens/usem_form.dart';
import 'package:flutter/gestures.dart';
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
      itemCount: _userEmailListData.length+1,
      itemBuilder: (BuildContext context, int index) {
        if(index < _userEmailListData.length){
          SoUserEmail nextSoUserEmail = SoUserEmail(
              _userEmailListData[index].id,
              _userEmailListData[index].userId,
              _userEmailListData[index].email,
              _userEmailListData[index].type);
            return UserEmailForm(
              soUserEmail: nextSoUserEmail,
            );
          }else{
            return Column(
              children: [
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){
                        _showModalBottomSheet(context);
                    },
                        icon: const Icon(Icons.add_circle,color: Colors.blue,)
                    ),
                  *//*  const SizedBox(width: 1,),
                    IconButton(
                        onPressed: (){
                          _showModalBottomSheet(context);
                        },
                        icon: const Icon(Icons.mail_outlined,color: Colors.blue,)
                    ),*//*
                  ],
                ),*/
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Registrar Nuevo Correo',
                              style: const TextStyle(color: Colors.blue,fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showModalBottomSheet(context);
                                }
                          )
                        ],
                      ),
                    )
                ),
                SizedBox(height: 20,)
              ],
            );
          }
      },
    );
  }

  void _showModalBottomSheet(BuildContext context,) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 5,
              right: 5

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text('Registro de Correo'),
                  ),
                ),
                const Divider(thickness: 2,color: Colors.blueGrey,),
                UserEmailForm(soUserEmail: SoUserEmail.empty()),
                /*for(final opt in newCustForm.custTypeList)
                  ListTile(
                    leading: const Icon(Icons.circle_outlined),
                    title:  Text(opt.label),
                    onTap: () {
                      newCustForm.customerType = opt.value;
                      newCustForm.customerTypeName = opt.label;
                      // custTypeController.text = opt.label;
                      Navigator.pop(context);
                    },
                  ),*/

                const SizedBox(height: 30,)
              ],
            ),
          );
        });
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
