import 'dart:convert';

import 'package:flexwm/models/cust.dart';
import 'package:flexwm/providers/cust_provider.dart';
import 'package:flexwm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:http/http.dart' as http;

class TabsScrollableDemo extends StatefulWidget {

  @override
  _TabsScrollableDemoState createState() => _TabsScrollableDemoState();
}

class _TabsScrollableDemoState extends State<TabsScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);
  int index = 0;
  @override
  String get restorationId => 'tab_scrollable_demo';

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );

    _tabController.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      setState(() {
        tabIndex.value = _tabController.index;
        index = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newCustProv = Provider.of<CustFormProvider>(context);
    final tabs = [
       "General",
     "Datos de Contacto",
      "Datos Adicionales",
      "Datos de Referencia",
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Registro de Clientes"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (final tab in tabs) Tab(text: tab,),
          ],
        ),
      ),
      body: AuthFormBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            for(var ta in tabs)
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CardContainer(
                      child: _NewCustForm(newCustProv, _tabController.index),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_outlined, color: Color.fromRGBO(93, 109, 126, 1),),
        backgroundColor: Colors.blueGrey.shade50,
        onPressed: (){
          if(newCustProv.isValidForm()){
            print('valid papa');
            addCust(context, newCustProv);
          }else{
            print('no valid');
          }
        },
      ),
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }
}

class _NewCustForm extends StatelessWidget {

  final CustFormProvider newCustForm;
  int indexTab;
  _NewCustForm(this.newCustForm, this.indexTab);

  //fomr 3
  final leadController = TextEditingController();
  final notasRefController = TextEditingController();
  //form 0
  final custTypeController = TextEditingController();
  final displayNameController = TextEditingController();
  final legalNameController = TextEditingController();
  //form 1
  final firstNameController = TextEditingController();
  final fatherLastController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  //form 2
  final nssController = TextEditingController();
  final dateContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //form 0
    if(newCustForm.customerType != '') custTypeController.text = newCustForm.customerTypeName;
    if(newCustForm.displayName != '') displayNameController.text = newCustForm.displayName!;
    if(newCustForm.legalName != '') legalNameController.text = newCustForm.legalName!;
    // form 1
    if(newCustForm.firstName != '') firstNameController.text = newCustForm.firstName;
    if(newCustForm.fatherLastName != '') fatherLastController.text = newCustForm.fatherLastName;
    if(newCustForm.phone != '') phoneController.text = newCustForm.phone;
    if(newCustForm.email != '') emailController.text = newCustForm.email;
    //form 2
    if(newCustForm.nss != '') nssController.text = newCustForm.nss!;
    if(newCustForm.stablishMentDate != '') dateContr.text = newCustForm.stablishMentDate!;
    //form 3
    if(newCustForm.referralLabel != '') leadController.text = newCustForm.referralLabel;
    if(newCustForm.referralComments != '') notasRefController.text = newCustForm.referralComments!;

      return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            if(indexTab == 0)
            TextFormField(
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Tipo Cliente*',
                  sufixIcon: Icons.arrow_drop_down_circle_outlined
              ),
              readOnly: true,
              controller: custTypeController,
              validator: ( value ) {
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor seleccione tipo de cliente';
              },
              onTap: () => _showModalBottomSheet(context,newCustForm),
            ),
            if(indexTab == 0)
            const SizedBox(height: 10,),
            if(indexTab == 0)
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              // initialValue: newCustForm.displayName,
              controller: displayNameController,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Nombre Comercial",
                  labelText: "Nombre Comercial",
                  prefixIcon: Icons.account_circle_outlined
              ),
              onChanged: ( value ) => newCustForm.displayName = value,
            ),
            if(indexTab == 0)
            const SizedBox(height: 10),
            if(indexTab == 0)
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              // initialValue: newCustForm.legalName,
              controller: legalNameController,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Razón Social",
                  labelText: "Razón Social",
                  prefixIcon: Icons.ballot_outlined
              ),
              onChanged: ( value ) => newCustForm.legalName = value,
            ),
            if(indexTab == 0)
            const SizedBox(height: 10),
            if(indexTab == 0)
            TextFormField(
              autocorrect: false,
              readOnly: true,
              initialValue: "Cristian : Hernández",
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  hintText: "Vendedor",
                  labelText: "Vendedor*",
                  prefixIcon: Icons.assignment_ind_outlined
              ),
              validator: ( value ) {
                newCustForm.salesManId = 97;
                return ( value != null && value.isNotEmpty )
                    ? null
                    : 'Por favor ingrese un nombre valido';

              },
            ),
            if(indexTab == 0)
            const SizedBox( height: 10 ),

            if(indexTab == 1)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                // initialValue: newCustForm.firstName,
                controller: firstNameController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Nombre",
                    labelText: "Nombre*",
                    prefixIcon: Icons.account_circle_outlined
                ),
                onChanged: ( value ) => newCustForm.firstName = value,
                validator: ( value ) {

                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un nombre valido';

                },
              ),
            if(indexTab == 1)
              const SizedBox(height: 10),
            if(indexTab == 1)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                // initialValue: newCustForm.fatherLastName,
                controller: fatherLastController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Apellido Paterno*",
                    labelText: "Apellido Paterno",
                    prefixIcon: Icons.account_box_outlined
                ),
                onChanged: ( value ) => newCustForm.fatherLastName = value,
                validator: ( value ) {

                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor ingrese un apellido valido';

                },
              ),
            if(indexTab == 1)
              const SizedBox(height: 10),
            if(indexTab == 1)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.phone,
                // initialValue: newCustForm.phone,
                controller: phoneController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Teléfono",
                    labelText: "Teléfono",
                    prefixIcon: Icons.phone_iphone_outlined
                ),
                onChanged: ( value ) => newCustForm.phone = value,
              ),
            if(indexTab == 1)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                // initialValue: newCustForm.email,
                controller: emailController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'tucorreo@gmail.com',
                    labelText: 'Email*',
                    prefixIcon: Icons.alternate_email_rounded
                ),
                onChanged: ( value ) => newCustForm.email = value,
                validator: ( value ) {

                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no luce como un correo';

                },
              ),

            if(indexTab == 2)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                // initialValue: newCustForm.nss,
                controller: nssController,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Cta. Softrax",
                    labelText: "Cta. Softrax",
                    prefixIcon: Icons.add_alarm_outlined
                ),
                onChanged: ( value ) => newCustForm.nss = value,
              ),
            if(indexTab == 2)
              const SizedBox(height: 10),
            if(indexTab == 2)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Seleccione una Fecha",
                    labelText: "Cuenta desde",
                    prefixIcon: Icons.calendar_today_outlined
                ),
                controller: dateContr,
                readOnly: true,
                validator: ( value ) {

                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor selecciones una fecha valida';

                },
                onTap: (){
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2025),
                  ).then((DateTime? value){
                    if(value != null){
                      DateTime _formDate = DateTime.now();
                      _formDate = value;
                      final String date = DateFormat('yyyy-MM-dd').format(_formDate);
                      newCustForm.stablishMentDate = date;
                      dateContr.text = date;
                    }
                  });
                },
              ),

            if(indexTab == 3)
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                    labelText: 'Fuente de Lead*',
                    sufixIcon: Icons.arrow_drop_down_circle_outlined
                ),
                controller: leadController,
                readOnly: true,
                validator: ( value ) {
                  return ( value != null && value.isNotEmpty )
                      ? null
                      : 'Por favor seleccione un dato';
                },
                onTap: () => _showModalFuenteOp(context,newCustForm),
              ),
            if(indexTab == 3)
              const SizedBox(height: 10),
            if(indexTab == 3)
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.name,
                // initialValue: newCustForm.referralComments,
                controller: notasRefController,
                onChanged: (value) => newCustForm.referralComments = value,
                decoration: InputDecorations.authInputDecoration(
                    hintText: "Notas Red.",
                    labelText: "Notas Red.",
                    prefixIcon: Icons.note_outlined
                ),
              ),

            const SizedBox( height: 15 ),

          ],
        ),
      );
    }



  void _showModalFuenteOp(BuildContext context, CustFormProvider newCustForm) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text('Fuente de Lead'),
                ),
              ),
              const Divider(thickness: 2,color: Colors.blueGrey,),
              for(final opt in newCustForm.custLeadList)
                ListTile(
                  leading: const Icon(Icons.circle_outlined),
                  title:  Text(opt.label),
                  onTap: () {
                    newCustForm.referralId = opt.value;
                    newCustForm.referralLabel = opt.label;
                    leadController.text = opt.label;
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 30,)
            ],
          );
        });
  }

  void _showModalBottomSheet(BuildContext context, CustFormProvider newCustForm) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text('Seleccione el tipo de cliente'),
                ),
              ),
              const Divider(thickness: 2,color: Colors.blueGrey,),
              for(final opt in newCustForm.custTypeList)
                ListTile(
                  leading: const Icon(Icons.circle_outlined),
                  title:  Text(opt.label),
                  onTap: () {
                    newCustForm.customerType = opt.value;
                    newCustForm.customerTypeName = opt.label;
                    custTypeController.text = opt.label;
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 30,)
            ],
          );
        });
  }
}

// Actualiza el wflowstep en el servidor
void addCust(BuildContext context, CustFormProvider custFormProv) async {
  SoCustomer soUser = SoCustomer.empty();
  soUser.customerType = custFormProv.customerType;
  soUser.displayName = custFormProv.displayName!;
  soUser.legalName = custFormProv.legalName!;
  soUser.salesManId = custFormProv.salesManId;
  soUser.firstName = custFormProv.firstName;
  soUser.fatherLastName = custFormProv.fatherLastName;
  soUser.email = custFormProv.email;
  soUser.phone = custFormProv.phone;
  soUser.nss = custFormProv.nss!;
  soUser.stablishMentDate = custFormProv.stablishMentDate!;
  soUser.referralId = custFormProv.referralId;
  soUser.referralComments = custFormProv.referralComments!;


    // Envia la sesion como Cookie, con el nombre en UpperCase
    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restcust;' +
          params.jSessionIdQuery),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Cookie':
        params.jSessionIdQuery.toUpperCase() + '=' + params.jSessionId,
      },
      body: jsonEncode(soUser),
    );

    if (response.statusCode == params.servletResponseScOk) {
      // Si fue exitoso obtiene la respuesta
      soUser = SoCustomer.fromJson(jsonDecode(response.body));

      custFormProv.vaciar();
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente "' + soUser.email + '" regitrado')),
      );
      // Regresa al listado
      Navigator.pop(context);
      // Navigator.pushNamed(context, '/photos');
    } else if (response.statusCode == params.servletResponseScNotAcceptable ||
        response.statusCode == params.servletResponseScForbidden) {
      // Error al guardar
      custFormProv.vaciar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al Guardar')),
      );
    } else {
      // Aun no se recibe respuesta del servidor
      const Center(
        child: CircularProgressIndicator(),
      );
    }
}
