import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/dialog.dart';
import 'package:transporttracking/View/administrator_page.dart';
import 'package:transporttracking/View/form_page.dart';
import 'package:transporttracking/Controller/login_or_register_page_controller.dart';
import 'package:transporttracking/View/passenger_home_page.dart';
import 'dart:async';
import 'package:transporttracking/View/taxi_driver_home_page.dart';
import 'package:transporttracking/View/transport_agent_home_page.dart';

class GetStarted extends StatefulWidget {
   
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {

  final PageController _controller = PageController();


final String email = Controller.getCurrentUserEmail().toString();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 194, 139),
       body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0 , vertical: 50.0),
        child : Stack ( children : [
        PageView(
        controller: _controller,
       children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.amber,
          border: Border.all(
            width: 5,
            color: const Color.fromARGB(255, 2, 54, 49),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.all(25),
          child : Column(children :[Text("Welcome to our Application : ".tr(), style: TextStyle(fontFamily: "Kanit", fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.center,),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                width: 5,
                color: Colors.blueAccent,
              )
            ),
            child:ClipRRect( 
              borderRadius: BorderRadius.circular(10),
              child : Image.asset('assets/img1.jpg' , width: 200,),),),
          SizedBox(height: 20),
          Text("Transport Tracking".tr(), style: TextStyle(fontFamily: "Kanit", fontSize: 30, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 46, 185)),textAlign: TextAlign.center, )
        ]),),          
          ),
        Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            width: 5,
            color: const Color.fromARGB(255, 2, 54, 49),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container ( 
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.all(25),
          child : Column(
          children: [
             Text("This app enhances your transportation experience, making it better, easier, and smarter. Stay informed about any changes affecting your journey.".tr(), style: TextStyle(fontFamily: "Kanit", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.center,),
           SizedBox(height: 10),
          Text("What are you waiting for? Sign up now or log in if you already have an account!".tr(), style: TextStyle(
            fontFamily: "Kanit", fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white,
            ),textAlign: TextAlign.center ),
            SizedBox(height: 15,),
            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                width: 5,
                color: Colors.amber,
              )
            ),
            child:ClipRRect( 
              borderRadius: BorderRadius.circular(10),
              child : Image.asset('assets/splash.webp' , width: 200),),),
          ],
        ),),
        ),
        Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 6, 135, 122),
          border: Border.all(
            width: 5,
            color: const Color.fromARGB(255, 2, 54, 49),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.all(25),
          child : Center( child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                width: 5,
                color: Colors.amber,
              )
            ),
            child:ClipRRect( 
              borderRadius: BorderRadius.circular(10),
              child : Image.asset('assets/img2.jpg' , width: 200),),),
              SizedBox(height: 20,),
            GestureDetector( child :Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
          color :  Colors.amber,
          border: Border.all(
            width: 5,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),  
              child:Text(
          "Next".tr(), 
          style: TextStyle(
            color: const Color.fromARGB(255, 7, 28, 189),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        ),
        onTap : ()  async {
          String? userEmail = await Controller.getCurrentUserEmail().first??'';
          Account? userModel = await Controller.getUserByEmail(userEmail);
          Account? userAccount;
         (userModel!=null)? userAccount=await Controller.getAccountByEmail(userEmail): null;
          bool isTransportAgent=(userModel?.userModel.role=='Transport Agent'.tr());
          bool isTaxiDriver=(userModel?.userModel.role=='Taxi Driver'.tr());
          bool isPassenger=(userModel?.userModel.role=='Passenger'.tr());
          StatefulWidget stfwidget;
          StatefulWidget homePage;
             if (isPassenger) {
             homePage = PassengerHomePage( account: userAccount);
             } else if (isTaxiDriver) {
             homePage = TaxiDriverHomePage(account: userAccount,);
            } else if (isTransportAgent) {
             homePage = TransportAgentHomePage(account: userAccount,);
            } else {
             homePage = AdministratorPage(account:  userAccount,);
             } 
             if (userModel!=null){
              stfwidget=homePage;
             }
             else{
              stfwidget=FormPage();
             }
          StreamSubscription? subscription;
           subscription= Controller.userConnectionStream().listen((isConnected) async {
           if (!isConnected){
            if (context.mounted)MyDialog.showMyDialog(context: context, mywidget :  LoginOrRegisterPage(stfwidget:stfwidget), dialogtype: DialogType.warning, title: "LogIn Warning ", description: "You Should LogIn !");}
            else{
            if(context.mounted) 
            {Navigator.push(
          context,
           MaterialPageRoute(builder: (context) => stfwidget),
          );}
          }
          subscription?.cancel();
        });
        }
        ),
        SizedBox(height: 20,),
          ],
        ),
        ),),),]),
        Container (
        alignment: Alignment(0, 0.85),  
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap : () {_controller.previousPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeIn,
            );},
              child: Icon(Icons.navigate_before_rounded),
              ),
              SmoothPageIndicator(controller: _controller, count: 3 ,   
         effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.grey.shade400,
                dotHeight: 8,
                dotWidth: 8,
              ),),
            GestureDetector(
                onTap : () {_controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeIn,
            );},
                child: Icon(Icons.navigate_next_rounded),
              ),
              GestureDetector(
                onTap : () {_controller.jumpToPage(2);},
                child: Icon(Icons.skip_next_rounded),
              ),
            ],
          ),
        ),    
       ],
       ),),
      );
  }
}