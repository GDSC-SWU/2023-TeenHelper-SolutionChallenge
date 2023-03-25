import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/google_map/MapPractice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google/Login/main_screen.dart';
import 'package:google/Login/splash_screen.dart';
import 'package:google/home/HomeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  // await FirebaseFirestore.instance.clearPersistence();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context , child) {
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => splash_screen(),
            '/main': (context) => main_screen(),
          },
          // home: splash_screen(),
        );
      },
    );
  }
}
