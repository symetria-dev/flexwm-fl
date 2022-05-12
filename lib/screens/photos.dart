import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'dart:convert';
import 'package:flexwm/models/cust.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/common/params.dart' as params;

class MyPhotosPage extends StatefulWidget {
  const MyPhotosPage({Key? key}) : super(key: key);

  @override
  _MyPhotosPageState createState() => new _MyPhotosPageState();
}

class _MyPhotosPageState extends State<MyPhotosPage> {
  List<int> verticalData = [];
  List<SoCustomer> customerListData = [];
  final int increment = 10;
  bool isLoadingVertical = false;

  @override
  void initState() {
    _loadMoreVertical();
    super.initState();
  }

  // Traer mas datos
  Future _loadMoreVertical() async {
    setState(() {
      isLoadingVertical = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));

    verticalData.addAll(List.generate(increment, (index) => verticalData.length + index));

    fetchSoCustomers(customerListData.length);

    setState(() {
      isLoadingVertical = false;
    });
  }

  // Genera la peticion de datos al servidor
  void fetchSoCustomers(int offset) async {
    String url = params.getAppUrl(params.instance) +
        'restcust'
            ';' +
        params.jSessionIdQuery +
        '=' +
        params.jSessionId +
        '?' +
        //params.searchQuery +
        //'=' +
        //searchController.text +
        //'&' +
        params.offsetQuery +
        '=' +
        offset.toString();
    final response = await http.Client().get(Uri.parse(url));

    print(url);

    // Si no es exitoso envia a login
    if (response.statusCode == params.servletResponseScForbidden) {
      Navigator.pushNamed(context, '/');
    } else if (response.statusCode != params.servletResponseScOk) {
      print('Error listado: ' + response.toString());
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    customerListData.addAll(parsed.map<SoCustomer>((json) => SoCustomer.fromJson(json)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazy List'),
      ),
      body: LazyLoadScrollView(
        isLoading: isLoadingVertical,
        onEndOfPage: () => _loadMoreVertical(),
        child: Scrollbar(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Vertical ListView',
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: customerListData.length,
                itemBuilder: (context, position) {
                  return DemoItem(position);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoItem extends StatelessWidget {
  final int position;

  const DemoItem(
      this.position, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    height: 40.0,
                    width: 40.0,
                  ),
                  SizedBox(width: 8.0),
                  Text("Item $position"),
                ],
              ),
              Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sed vulputate orci. Proin id scelerisque velit. Fusce at ligula ligula. Donec fringilla sapien odio, et faucibus tortor finibus sed. Aenean rutrum ipsum in sagittis auctor. Pellentesque mattis luctus consequat. Sed eget sapien ut nibh rhoncus cursus. Donec eget nisl aliquam, ornare sapien sit amet, lacinia quam."),
            ],
          ),
        ),
      ),
    );
  }
}