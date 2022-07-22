import 'dart:convert';

import 'package:flexwm/models/curl.dart';
import 'package:flexwm/screens/curl_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

class CustomerRelative extends StatefulWidget{
  final int forceFilter;
  const CustomerRelative({Key? key, required this.forceFilter}) : super(key: key);

  @override
  State<CustomerRelative> createState() => _CustomerRelativeState();
}

class _CustomerRelativeState extends State<CustomerRelative>{
  final List<SoCustomerRelative> _customerRelativeListData = [];

  @override
  void initState(){
    fetchSoCustomerRelative(widget.forceFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _customerRelativeListData.length+1,
      itemBuilder: (BuildContext context, int index){
        if(index < _customerRelativeListData.length){
          SoCustomerRelative nextSoCustAddress = SoCustomerRelative(
              _customerRelativeListData[index].id,
              _customerRelativeListData[index].type,
              _customerRelativeListData[index].customerId,
              _customerRelativeListData[index].fullName,
              _customerRelativeListData[index].fatherLastName,
              _customerRelativeListData[index].motherLastName,
              _customerRelativeListData[index].email,
              _customerRelativeListData[index].number,
              _customerRelativeListData[index].cellPhone,
              _customerRelativeListData[index].extension,
              _customerRelativeListData[index].responsible);
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            child: ListTile(
              onTap: (){
                _showModalBottomSheet(context, nextSoCustAddress);
              },
              title: Text(index.toString() + ':' + nextSoCustAddress.type + ' ' + nextSoCustAddress.fullName),
              subtitle: Text(nextSoCustAddress.fatherLastName+" "+nextSoCustAddress.cellPhone),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.group),
                  // IconButton(onPressed: () {utils.makePhoneCall(item.phone);}, icon: const Icon(Icons.phone)),
                ],
              ),
            ),
          );
        }else{
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Registrar Nueva Referencia',
                            style: const TextStyle(color: Colors.blue,fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _newReference(SoCustomerRelative.empty());
                                // _showModalBottomSheet(context, SoCustomerRelative.empty());
                              }
                        )
                      ],
                    ),
                  )
              ),
              const SizedBox(height: 20,)
            ],
          );
        }
      },
    );
  }

  //Formulario en alert
  Future<void> _newReference(SoCustomerRelative soCustRelative) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registro de Referencia'),
            content: SingleChildScrollView(child: CustRelativeForm(soCustRelative: soCustRelative)),
          );
        }
    );
  }

  void _showModalBottomSheet(BuildContext context,SoCustomerRelative soCustRelative) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            //Funcion para mover widget a la altura del teclado
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 5,
                right: 5
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('Registro de Referencia'),
                    ),
                  ),
                  const Divider(thickness: 2,color: Colors.blueGrey,),
                  CustRelativeForm(soCustRelative: soCustRelative),
                ],
              ),
            ),
          );
        }).whenComplete(_onBottomSheetClosed);
  }

  //Funcion que se ejecuta al cerrar modalbottomsheet
  void _onBottomSheetClosed(){
    //Se actualiza la lista del subcatalogo
    _customerRelativeListData.clear();
    setState((){
      fetchSoCustomerRelative(widget.forceFilter);
    });
  }

  Future<List<SoCustomerRelative>> fetchSoCustomerRelative(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcurl;' +
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

    _customerRelativeListData.addAll(
        parsed.map<SoCustomerRelative>((json) => SoCustomerRelative.fromJson(json)).toList());

    setState(() {});
    return parsed
        .map<SoCustomerRelative>((json) => SoCustomerRelative.fromJson(json))
        .toList();
  }

}