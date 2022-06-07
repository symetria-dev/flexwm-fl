import 'dart:convert';
import 'dart:io';
import 'package:flexwm/common/filters.dart';
import 'package:flexwm/models/usem.dart';
import 'package:flexwm/routes/app_routes.dart';
import 'package:flexwm/routes/routes.dart';
import 'package:flexwm/common/params.dart' as params;
import 'package:flexwm/screens/usem_screen.dart';
import 'package:flexwm/widgets/dropdown_widget.dart';
import 'package:flexwm/widgets/sub_catalog_widget.dart';
import 'package:flexwm/widgets/upload_file_widget.dart';
import 'package:flexwm/widgets/upload_image_widget.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class UserFormScreen extends StatefulWidget {
  final String id;

  const UserFormScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  SoUser soUser = SoUser.empty();
  late Future<SoUser> _futureSoUser;

  final textFirstNameController = TextEditingController();
  final textEmailControler = TextEditingController();
  late int locationId = 0;
  late int areaId = 0;

  @override
  void initState() {
    super.initState();
    _futureSoUser = fetchUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: params.bgColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text('Usuario', style: Theme.of(context).textTheme.headline6),
          backgroundColor: params.appBarBgColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserList()),
                  );
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),   
        body: Center(
          child: FutureBuilder<SoUser>(
              future: _futureSoUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(child: getForm(snapshot.data!));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  //Peticon de datos de un cliente especifico
  Future<SoUser> fetchUser(String id) async {
    final response = await http.get(Uri.parse(
        params.getAppUrl(params.instance) +
            'restuser;' +
            params.jSessionIdQuery +
            '=' +
            params.jSessionId +
            '?id=' +
            id.toString()));

    // Si no es exitoso envia a login
    if (response.statusCode != params.servletResponseScOk) {
      Navigator.pushNamed(context, AppRoutes.initialRoute);
    }

    return SoUser.fromJson(jsonDecode(response.body));
  }

  /*showExtra() {
    if (emailExpanded) {
      _heightEmailContainer = 0;
      emailExpanded = false;
    } else {
      _heightEmailContainer = 100;
      emailExpanded = true;
    }
    setState(() {});
  }*/

//Formulario
  Widget getForm(SoUser userData) {
    soUser = userData;
    textFirstNameController.text = userData.firstname;
    textEmailControler.text = userData.email;
    locationId = userData.locationId;
    areaId = userData.areaId;

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            UploadImage(
              initialruta: params.getAppUrl(params.instance) +
                  params.uploadFiles +
                  '/' +
                  userData.photo,
              fielName: 'user_photo',
              programCode: 'USER',
              id: userData.id.toString(),
            ),
            TextFormField(
              controller: textFirstNameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nombre',
              ),
            ),
            TextFormField(
              controller: textEmailControler,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            UploadFile(
                programCode: 'USER',
                fielName: 'user_photo',
                label: 'Foto',
                id: userData.id.toString()),
            DropdownWidget(
              callback: (String id) {
                locationId = int.parse(id);
              },
              dropdownValue: userData.locationId.toString(),
              programCode: 'LOCT',
              label: 'Ubicación',
              filterList: [
                SoFilters(
                    field: 'loct_name',
                    kind: SoUserEmail.kind,
                    value: 'GDL',
                    filterMethod: SoFilters.METHOD_SETVALUELABELFILTER),
                SoFilters(
                    field: 'loct_name',
                    kind: SoUserEmail.kind,
                    value: 'CDMX',
                    filterMethod: SoFilters.METHOD_SETVALUELABELFILTER),
              ],
            ),
            DropdownWidget(
              callback: (String id) {
                setState(() {
                  areaId = int.parse(id);
                });
              },
              dropdownValue: userData.areaId.toString(),
              programCode: 'AREA',
              label: 'Area',
            ),
            SubCatalogContainerWidget(
              title: 'Correos',
              child: UserEmail(
                forceFilter: userData.id,
              ),
            ),
            
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Actualiza registro

                    updateCustomer();
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCustomer() async {
    soUser.firstname = textFirstNameController.text;
    soUser.email = textEmailControler.text;
    soUser.locationId = locationId;
    soUser.areaId = areaId;

    final response = await http.post(
      Uri.parse(params.getAppUrl(params.instance) +
          'restuser;' +
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
      // Muestra mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserList()),
      );
    } else if (response.statusCode == params.servletResponseScNotAcceptable ||
        response.statusCode == params.servletResponseScForbidden) {
      // Error al guardar
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

  Widget getPhoto(SoUser soUser) {
    if (soUser.photo.isNotEmpty) {
      return Center(
        child: CircleAvatar(
          maxRadius: 50,
          backgroundImage: NetworkImage(
            params.getAppUrl(params.instance) +
                params.uploadFiles +
                '/' +
                soUser.photo,
          ),
        ),
      );
    } else {
      return CircleAvatar(
        maxRadius: 30,
        child: Text(
          soUser.firstname.substring(0, 1).toString().toUpperCase(),
          style: const TextStyle(fontSize: 30),
        ),
      );
    }
  }

  Widget getHeader(SoUser soUser) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.green),
        title: Text(soUser.firstname + ' ' + soUser.email),
      ),
    );
  }
}
