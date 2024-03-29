import 'dart:convert';

import 'package:flexwm/models/crqa.dart';
import 'package:flexwm/models/crqg.dart';
import 'package:flexwm/screens/crqa_form.dart';
import 'package:flexwm/widgets/upload_file_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;
import 'package:intl/intl.dart';

import '../models/data.dart';

class CreditRequestAsset extends StatefulWidget{
  final SoCreditRequestGuarantee soCreditRequestGuarantee;
  const CreditRequestAsset({Key? key,
    required this.soCreditRequestGuarantee}) : super(key: key);

  @override
  State<CreditRequestAsset> createState() => _CreditRequestAssetState();
}

class _CreditRequestAssetState extends State<CreditRequestAsset>{
  final List<SoCreditRequestAsset> _creditRequestAssetListData = [];
  late List<Data> dataList = [];
  //id de aval
  int creditRequestGuaranteeId = 0;

  @override
  void initState(){
    creditRequestGuaranteeId = widget.soCreditRequestGuarantee.id;
    fetchSoCreditRequestAssets(widget.soCreditRequestGuarantee.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _creditRequestAssetListData.length+1,
      itemBuilder: (BuildContext context, int index){
        if(index < _creditRequestAssetListData.length){
          SoCreditRequestAsset nextSoCrqa = SoCreditRequestAsset(
            _creditRequestAssetListData[index].id,
            _creditRequestAssetListData[index].type,
            _creditRequestAssetListData[index].description,
            _creditRequestAssetListData[index].value,
            _creditRequestAssetListData[index].purchaseDate,
            _creditRequestAssetListData[index].photo,
            _creditRequestAssetListData[index].folio,
            _creditRequestAssetListData[index].deedNumber,
            _creditRequestAssetListData[index].civicNumber,
            _creditRequestAssetListData[index].street,
            _creditRequestAssetListData[index].extNumber,
            _creditRequestAssetListData[index].intNumber,
            _creditRequestAssetListData[index].zip,
            _creditRequestAssetListData[index].invoice,
            _creditRequestAssetListData[index].brand,
            _creditRequestAssetListData[index].model,
            _creditRequestAssetListData[index].year,
            _creditRequestAssetListData[index].serial,
            _creditRequestAssetListData[index].motor,
            _creditRequestAssetListData[index].comments,
            _creditRequestAssetListData[index].status,
            _creditRequestAssetListData[index].cityId,
            _creditRequestAssetListData[index].creditRequestGuaranteeId,
            _creditRequestAssetListData[index].creditRequestId
          );
          return Slidable(
            endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: <Widget> [
                  SlidableAction(
                    icon: Icons.delete_forever,
                      foregroundColor: Colors.red,
                      label: 'Eliminar',
                      onPressed: (_){
                        deleteSoCustomerAssets(_creditRequestAssetListData[index].id).
                        then((value) {
                          if(value){
                            //Se actualiza la lista del subcatalogo
                            _creditRequestAssetListData.clear();
                            setState((){
                              fetchSoCreditRequestAssets(widget.soCreditRequestGuarantee.id);
                            });
                          }
                        });
                      }
                  ),
                ]
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
              child: ListTile(
                onTap: (){
                  getData().then((value) {
                    String cityText = '';
                    for(int i =0;i<dataList.length;i++){
                      if(nextSoCrqa.cityId == dataList[i].id){
                        cityText = dataList[i].label;
                      }
                    }
                    if(nextSoCrqa.type == SoCreditRequestAsset.TYPE_PROPERTY){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              CreditRequestAssetsForm(
                                soCreditRequestAsset: nextSoCrqa,
                                soCreditRequestGuarantee: widget.soCreditRequestGuarantee,
                                label: cityText,),
                          )
                      ).then((value) {
                        _creditRequestAssetListData.clear();
                        setState(() {
                          fetchSoCreditRequestAssets(creditRequestGuaranteeId);
                        });
                      });
                    }else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              CreditRequestAssetsForm(
                                soCreditRequestAsset: nextSoCrqa,
                                soCreditRequestGuarantee: widget.soCreditRequestGuarantee,),
                          )
                      ).then((value) {
                        _creditRequestAssetListData.clear();
                        setState(() {
                          fetchSoCreditRequestAssets(creditRequestGuaranteeId);
                        });
                      });
                    }

                  });

                },
                title: Text((index+1).toString() + ':' +
                    SoCreditRequestAsset.getLabelType(nextSoCrqa.type) + ' ' +
                    SoCreditRequestAsset.getLabelStatus(nextSoCrqa.status)),
                subtitle: Text('Valor Actual: ' +
                    NumberFormat.currency(locale: 'es_MX',symbol: '\$').format(nextSoCrqa.value)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(nextSoCrqa.type == SoCreditRequestAsset.TYPE_PROPERTY)
                    const Icon(Icons.home_work_outlined),
                    if(nextSoCrqa.type == SoCreditRequestAsset.TYPE_AUTO)
                      const Icon(Icons.directions_car_filled_outlined),
                  ],
                ),
              ),
            ),
          );
        }else{
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child:
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Nueva Garantia',
                            style: const TextStyle(color: Colors.blue,fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // _showModalBottomSheet(context, SoCreditRequestAsset.empty(),true,'');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        CreditRequestAssetsForm(
                                            soCreditRequestAsset: SoCreditRequestAsset.empty(),
                                            soCreditRequestGuarantee: widget.soCreditRequestGuarantee),
                                    )
                                ).then((value) {
                                  _creditRequestAssetListData.clear();
                                  setState(() {
                                    fetchSoCreditRequestAssets(creditRequestGuaranteeId);
                                  });
                                });
                              }
                        ),
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

  void _showModalBottomSheet(BuildContext context,SoCreditRequestAsset soCrqa,bool typeInmueble, String cityText) {
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
                      child: Text('Registro de Direcciones'),
                    ),
                  ),
                  const Divider(thickness: 2,color: Colors.blueGrey,),
                  CreditRequestAssetsForm(soCreditRequestAsset: soCrqa,
                      soCreditRequestGuarantee: widget.soCreditRequestGuarantee, label: cityText,
                  ),
                ],
              ),
            ),
          );
        }).whenComplete(_onBottomSheetClosed);
  }

  //Funcion que se ejecuta al cerrar modalbottomsheet
  void _onBottomSheetClosed(){
    //Se actualiza la lista del subcatalogo
    _creditRequestAssetListData.clear();
    setState((){
      fetchSoCreditRequestAssets(widget.soCreditRequestGuarantee.id);
    });
  }

  Future<List<SoCreditRequestAsset>> fetchSoCreditRequestAssets(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqa;' +
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

    _creditRequestAssetListData.addAll(
        parsed.map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json)).toList());
    setState((){});
    print('consultadads garantias ---> ${_creditRequestAssetListData.length}');
    return parsed
        .map<SoCreditRequestAsset>((json) => SoCreditRequestAsset.fromJson(json))
        .toList();
  }

  Future<bool> deleteSoCustomerAssets(int forceFilter) async {
    String url = params.getAppUrl(params.instance) +
        'restcrqa;' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?id='+
        forceFilter.toString()+
        '&' +
        params.deleteFilter +
        '=' +
        forceFilter.toString();
        print(url);
    final response = await http.Client().get(Uri.parse(url));

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScOk) {
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado correctamente')),
      );
      return true;
    }else{
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al eliminar el registro')),
      );
      return false;
    }

  }

  Future getData() async {
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'dropdownlist;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'programCode': 'CITY',
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
    });
  }


}