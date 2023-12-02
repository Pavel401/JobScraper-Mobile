import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatelessWidget {
  final String pdfUrl;

  const PdfView({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume'),
      ),
      body: FutureBuilder<File>(
        future: DefaultCacheManager().getSingleFile(pdfUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // return PDFView(
            //   filePath: snapshot.data!.path,
            // );
            return PDFView(
              filePath: snapshot.data!.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (_pages) {
                // setState(() {
                //   pages = _pages;
                //   isReady = true;
                // });
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                // _controller.complete(pdfViewController);
              },
              // onPageChanged: (int page, int total) {
              //   // print('page change: $page/$total');
              // },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
