import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moodtracker_app/core/get_it.dart' as di;
import 'package:moodtracker_app/core/helper/route_generate_helper.dart';
import 'package:moodtracker_app/core/helper/shared_prefrence.dart';
import 'package:moodtracker_app/features/splash/presentation/splash_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,);
   await di.init();
   await LocalDataCore.init();

  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF6F6FB),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6C63FF)),
      ),
      initialRoute: SplashView.routeName,
      onGenerateRoute: onGenerateRoute
    );
  }
}
