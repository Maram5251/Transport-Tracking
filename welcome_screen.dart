import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/View/get_started.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
       child : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height : MediaQuery.of(context).size.height/1.6,
              decoration : BoxDecoration(
                color: const Color.fromARGB(255, 68, 188, 176),
              ),
            ),
             Container(
              width: MediaQuery.of(context).size.width,
              height : MediaQuery.of(context).size.height/1.6,
              decoration : BoxDecoration(
                color: Color.fromARGB(255, 0, 194, 139),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(70))
                ),
              child: Center(child: Image.asset('assets/Image1.png', scale: 0.8,),),
              ),

          ],),
          Align(alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2.666,
            decoration: BoxDecoration(
              color:  Color.fromARGB(255, 0, 194, 139),
            ),

          ),
          ),
          Align(alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2.666,
            padding: EdgeInsets.only(top: 40,bottom: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 68, 188, 176),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(70))
            ),
            child: Column(children: [
                Text("Transport Tracking ".tr(),
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Kanit",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  wordSpacing: 2,
                  color: const Color.fromARGB(255, 106, 45, 5),
                ),
                ),
                SizedBox(height: 15,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 40), 
                child: Text("Transport Smarter , Travel Easier , Track Transport !!!".tr(),textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: const Color.fromARGB(255, 4, 51, 90),
                  fontWeight: FontWeight.bold,
                ),
                ),
                ),
                SizedBox(height: 10,),
                Material(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GetStarted()),
                     );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      child: Text("Get Started".tr(), style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 27,
                        letterSpacing: 1,
                        color: const Color.fromARGB(255, 1, 64, 3),
                      ),),
                    ),
                  ),
                )
            ],),
            )
            ),
        ],),
      ),
      );
  }
}