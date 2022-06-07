
import 'package:flexwm/ui/appbar_flexwm.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget{
  final String url;

  const PdfView({Key? key, required this.url}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStyle.authAppBarFlex(title: 'title'),
      body: SfPdfViewer.network(url),
    );
  }
  
}