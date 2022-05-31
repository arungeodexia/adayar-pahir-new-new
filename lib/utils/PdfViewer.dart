import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:ACI/data/api/repository/api_intercepter.dart';
import 'package:ACI/data/globals.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class PdfViewerNew extends StatefulWidget {
  String pdfUrl;
 String title;

  PdfViewerNew({required this.pdfUrl,required this.title});
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewerNew> {
  String? path;
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);
  @override
  initState() {
    super.initState();
    print("widget.pdfUrl initstate:==>"+widget.pdfUrl);
    globalAndroidIsOnMsgExecuted = false;
    globalAndroidIsOnResumeExecuted= false;
    loadPdf(widget.pdfUrl);

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost(String pdfUrl) async {
    print("widget.pdfUrl fetchPost:==>"+widget.pdfUrl);
    final response = await client.get(
      //'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'
        Uri.parse("https://d1rtv5ttcyt7b.cloudfront.net/app/pahir-resources/%2F1635851211704_dummy.pdf")
    );
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf(String pdfUrl) async {
    writeCounter(await fetchPost(pdfUrl));
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    globalcontext = context;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future<bool> onWillPop() async {
      Navigator.pop(context);
      globalISPNPageOpened = false;
      return false;
    }
    return   new WillPopScope(
        onWillPop:() => onWillPop(),
        child:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                onWillPop();
              },
            ),
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Center(

            child: Column(
              children: <Widget>[
                path != null?
                  Container(
                    height:  MediaQuery.of(context).size.height/1.2,
                    child: PdfView(
                      path: path!,
                    ),
                  )
                :
                  Text("Pdf is Loading ..."),
              ],
            ),
          ),
        ));
  }
}
