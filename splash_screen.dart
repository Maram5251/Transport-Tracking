import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/administrator_page.dart';
import 'package:transporttracking/View/form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transporttracking/View/passenger_home_page.dart';
import 'package:transporttracking/Controller/login_or_register_page_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:transporttracking/View/taxi_driver_home_page.dart';
import 'package:transporttracking/View/transport_agent_home_page.dart';
import 'package:transporttracking/View/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
   
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override 
  void initState(){
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    redirect();
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color.fromARGB(255, 26, 52, 83), Color.fromARGB(255, 87, 219, 190)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        )),
      child : SingleChildScrollView(child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Image.png',
            fit: BoxFit.cover,
            ),
          const Center(
          child: CircularProgressIndicator()
           ),
          ],
        ),
      ),
    )
    ));
  }
  Future<void> redirect() async{
  await Future.delayed(Duration(seconds: 3));
  final authApp = Firebase.app('AuthApp');  
  final user = FirebaseAuth.instanceFor(app: authApp).currentUser;
   final storage = GetStorage();
  bool? isFirstTime=storage.read('isFirstTime'); 
  if (isFirstTime??false) {
    if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  } else {
     String userEmail = (await Controller.getCurrentUserEmail().first) ?? '';
      Account? userAccount;
      userAccount=await Controller.getAccountByEmail(userEmail);
      bool isTransportAgent=(userAccount?.userModel.role=='Transport Agent'.tr());
      bool isTaxiDriver=(userAccount?.userModel.role=='Taxi Driver'.tr());
      bool isPassenger=(userAccount?.userModel.role=='Passenger'.tr());
      StatefulWidget homePage;
      StatefulWidget stfwidget;
       if (isPassenger) {
             homePage = PassengerHomePage(account: userAccount);
             } else if (isTaxiDriver) {
             homePage = TaxiDriverHomePage(account: userAccount);
            } else if (isTransportAgent) {
             homePage = TransportAgentHomePage(account: userAccount,);
            } else {
             homePage = AdministratorPage(account: userAccount,);
             } 
              if (userAccount!=null){
              stfwidget=homePage;
             }
             else{
              stfwidget=FormPage();
             }
    if (user!=null){
    if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => stfwidget));}
  else{
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginOrRegisterPage(stfwidget: SplashScreen())));
  }
  } 
}
}