import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/camera_emotion_view.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/feeling_selection_screen.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/question_view.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/text_emotaion_view.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/tips_guide_view.dart';
import 'package:moodtracker_app/features/profile/presentation/mood_statistics_view.dart';
import 'package:moodtracker_app/features/profile/presentation/profile_view.dart';
import 'package:moodtracker_app/features/splash/presentation/splash_view.dart';
import 'package:moodtracker_app/features/auth/presentation/login_view.dart';
import 'package:moodtracker_app/features/auth/presentation/sign_up_view.dart';
import 'package:moodtracker_app/features/onBoarding/onboarding_screen1.dart';
import 'package:moodtracker_app/features/home/Presentation/main_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/data/model/book_model.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/presentation/book_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/presentation/widgets/book_reader_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/quran_view/quran_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/rate_mood_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/relaxtaion/presentation/relaxation_exercises_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/suggestion_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/videos/presentation/videos_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch(settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => SplashView());

    case OnboardingScreen.routeName:
      return PageRouteBuilder(
        pageBuilder: (_, animation, __) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      );

    case SignUpView.routeName:
      return MaterialPageRoute(builder: (context) => SignUpView());

    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => LoginView());

    case MainView.routeName:
      return MaterialPageRoute(builder: (context) => const MainView());

    case ProfileView.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileView());
      
    case CameraEmotionView.routeName:
      return MaterialPageRoute(builder: (context) => const CameraEmotionView());
    
    case FeelingView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      return PageRouteBuilder(
        pageBuilder: (_, animation, __) => FeelingView(
          userFeeling: args?['userFeeling'] ?? '', 
        ),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      );

      case QuestionView.routeName:
      return MaterialPageRoute(builder: (context) => const QuestionView());
     
     case EmotionTextView.routeName:
      return MaterialPageRoute(builder: (context) => const EmotionTextView());


    case TipsAndGuidanceView.routeName:
      return MaterialPageRoute(builder: (context) =>  const TipsAndGuidanceView());
    

    case TreatmentSuggestionView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(builder: (context) => TreatmentSuggestionView(
        userFeeling: args?['userFeeling'] ?? '',
      ));
    
    case QuranView.routeName:
      return MaterialPageRoute(builder: (context) => const QuranView());

    case MoodStatisticsView.routeName:
      return MaterialPageRoute(builder: (context) => const MoodStatisticsView());  



    case RateMoodView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(builder: (context) => RateMoodView(
         userFeeling: args?['userFeeling'] ?? '',
      ));
    
    case VideosView.routeName:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(builder: (context) => VideosView(
        mood: args?['mood'] ?? '',
      ));
    

    case RelaxationExercisesView.routeName:
      return MaterialPageRoute(builder: (context) => RelaxationExercisesView());
    
    case BooksView.routeName:
      return MaterialPageRoute(builder: (_) => BooksView());
     case BookReaderView.routeName:
      final book = settings.arguments as BookModel;
      return MaterialPageRoute(builder: (_) => BookReaderView(key: UniqueKey()));
   
     default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('No route defined')),
        ),
      );
  }
}