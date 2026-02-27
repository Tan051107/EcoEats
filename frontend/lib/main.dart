import 'package:flutter/material.dart';
import 'package:frontend/pages/auth_wrapper.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/providers/favourite_provider.dart';
import 'package:frontend/providers/grocery_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await GoogleSignIn.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>FavouriteProvider()
        ),
        ChangeNotifierProvider(
          create: (_)=>DailyMealsProvider()
        ),
        ChangeNotifierProvider(
          create: (_)=>GroceryProvider()
        )
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade50,
        cardTheme: CardThemeData(
          color: Colors.white
        )
      ),
      home: AuthWrapper(),
    );
  }
}



 