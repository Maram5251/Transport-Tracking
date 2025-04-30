import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      name: 'AuthApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
await GetStorage.init();
final storage = GetStorage();
final accounts= await Controller.getUsersInTheDevice();
await Controller.getDeviceToken();
if (accounts.isEmpty) {
    storage.write('isFirstTime', true);
  } else {
    storage.write('isFirstTime', false);
  }
Controller.listenForAuthStateChanges();
runApp( 
  EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations', 
      fallbackLocale: Locale('fr'),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
   
   
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transport Tracking',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home:SplashScreen(),
    );    
     }
    }    
    
