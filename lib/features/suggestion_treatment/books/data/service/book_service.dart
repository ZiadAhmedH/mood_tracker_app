import 'package:moodtracker_app/features/suggestion_treatment/books/data/model/book_model.dart';


class BookService {
  List<BookModel> getBooks() {
    return [
      BookModel(
        title: 'Understanding Emotions',
        author: 'Jane Doe',
        coverImageUrl: 'assets/images/book1.jpg',
        pdfAssetPath: 'assets/pdfs/Understanding_Emotions.pdf',
      ),
     
    ];
  }
}
