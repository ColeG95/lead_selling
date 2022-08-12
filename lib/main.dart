import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lead_selling/screens/lead_list_screen/lead_list_screen.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: LeadListScreen(),
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(),
      ).copyWith(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.lightBlueAccent,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[300],
            onPrimary: Colors.grey[900],
            shadowColor: Colors.grey,
            // elevation: 6,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: Colors.purple,
            backgroundColor: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}
