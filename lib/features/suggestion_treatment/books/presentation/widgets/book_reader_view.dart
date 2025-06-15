import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/data/model/book_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class BookReaderView extends StatelessWidget {
  static const routeName = '/book-reader';

  const BookReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final BookModel book = ModalRoute.of(context)!.settings.arguments as BookModel;

    return Scaffold(
      appBar: AppBar(title: Text(book.title), backgroundColor: Colors.deepPurple),
      body: SfPdfViewer.asset(book.pdfAssetPath),
    );
  }
}
