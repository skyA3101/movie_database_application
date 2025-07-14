import 'package:movie_mania/core/utilities/imports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenProvider.instance()),
        ChangeNotifierProvider(create: (context) => MovieDetailsPageProvider.instance()),
        ChangeNotifierProvider(create: (context) => ThemeProvider.instance()),
        ChangeNotifierProvider(create: (context) => DownloadScreenProvider.instance()),
        ChangeNotifierProvider(create: (context) => ProfileScreenProvider.instance()),
        ChangeNotifierProvider(create: (context) => SearchScreenProvider.instance()),
        ChangeNotifierProvider(create: (context) => BookmarksProvider.instance()),
      ],
      child: const MovieManiaApp(),
    ),
  );
}

class MovieManiaApp extends StatelessWidget {
  const MovieManiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/search': (_) => const SearchScreen(),
        '/downloads': (_) => const DownloadsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/bookmarks': (_) => const BookmarksPage(),
      },
    );
  }
}
