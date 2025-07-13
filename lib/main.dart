import 'package:movie_mania/core/utilities/imports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MovieManiaApp());
}

class MovieManiaApp extends StatelessWidget {
  const MovieManiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
