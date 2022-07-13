import 'dart:convert';

import 'package:flexwm/models/cuad.dart';
import 'package:flexwm/screens/cuad_form.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

class CustomerAddress extends StatefulWidget{
  final int forceFilter;
  const CustomerAddress({Key? key, required this.forceFilter}) : super(key: key);

  @override
  State<CustomerAddress> createState() => _CustomerAddressState();
}

class _CustomerAddressState extends State<CustomerAddress>{
  final List<SoCustAddres> _customerAddressListData = [];

  @override
  void initState(){
    fetchSoCustomerAddress(widget.forceFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _customerAddressListData.length+1,
      itemBuilder: (BuildContext context, int index){
        if(index < _customerAddressListData.length){
          SoCustAddres nextSoCustAddress = SoCustAddres(
              _customerAddressListData[index].id,
              _customerAddressListData[index].type,
              _customerAddressListData[index].street,
              _customerAddressListData[index].number,
              _customerAddressListData[index].neighborhood,
              _customerAddressListData[index].zip,
              _customerAddressListData[index].description,
              _customerAddressListData[index].cityId,
              _customerAddressListData[index].customerId,
              _customerAddressListData[index].deliveryAddress,
              _customerAddressListData[index].interiorNumber);
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            child: ListTile(
              title: Text(index.toString() + ':' + nextSoCustAddress.type + ' ' + nextSoCustAddress.street),
              subtitle: Text(nextSoCustAddress.neighborhood+" "+nextSoCustAddress.number),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.home),
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
                            text: 'Registrar Nueva Dirección',
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
              const SizedBox(height: 20,)
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
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('Registro de Direcciones'),
                      ),
                    ),
                    const Divider(thickness: 2,color: Colors.blueGrey,),
                    CustAddressForm(soCustAddress: SoCustAddres.empty()),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<List<SoCustAddres>> fetchSoCustomerAddress(int forceFilter) async {
    print('SI en obtener CUAD screen');
    String url = params.getAppUrl(params.instance) +
        'restcuad;' +
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

    _customerAddressListData.addAll(
        parsed.map<SoCustAddres>((json) => SoCustAddres.fromJson(json)).toList());

    setState(() {});
    return parsed
        .map<SoCustAddres>((json) => SoCustAddres.fromJson(json))
        .toList();
  }

}