import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flexwm/http.dart';
import 'package:flexwm/drawer.dart';

class MyPhotos extends StatelessWidget {
  const MyPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Isolate Demo';

    return const MyPhotosPage(title: appTitle);
  }
}

class MyPhotosPage extends StatelessWidget {
  const MyPhotosPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: HttpUtils.fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: getDrawer(context),
    );
  }
}
