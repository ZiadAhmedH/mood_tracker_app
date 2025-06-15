import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/data/model/book_model.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/data/service/book_service.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/presentation/widgets/book_reader_view.dart';


class BooksView extends StatelessWidget {
  static const routeName = '/books';
  final List<BookModel> books = BookService().getBooks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Books"), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                BookReaderView.routeName,
                arguments: book,
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Image.asset(book.coverImageUrl, width: 50, fit: BoxFit.cover),
                title: Text(book.title),
                subtitle: Text(book.author),
              ),
            ),
          );
        },
      ),
    );
  }
}
