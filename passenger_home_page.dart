import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/bus.dart';
import 'package:transporttracking/View/drawer.dart';
import 'package:transporttracking/View/favorite_page.dart';
import 'package:transporttracking/View/map_screen_passenger.dart';
import 'package:transporttracking/View/messages_passenger.dart';
import 'package:transporttracking/View/notifications_page.dart';
import 'package:transporttracking/View/profil_page.dart';
import 'package:transporttracking/View/search_page.dart';
import 'package:transporttracking/View/settings_page.dart';
import 'package:transporttracking/View/taxi.dart';
import 'package:transporttracking/View/taxis.dart';
import 'package:transporttracking/View/train.dart';

class PassengerHomePage extends StatefulWidget {
  final Account? account;
  const PassengerHomePage({super.key ,required this.account});

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldkey =GlobalKey<ScaffoldState>();

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late List<Widget> screens;
  int selectedIndex=0;
  @override
   void initState() {
    super.initState();
   screens=[
    HomePageContent(account: widget.account),
    SearchPage(),
    SettingsPage(account: widget.account),
    FavoritePage(),
    ProfilPage(account: widget.account,),
    Notificationspage(),
    MessagesPassenger(),
    Taxis(account:widget.account,),
  ];}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
    final items=<Widget> [
      Icon(Icons.home, size: 30,),
      Icon(Icons.search, size: 30,),
      Icon(Icons.settings, size: 30,),
      Icon(Icons.favorite, size: 30,),
      Icon(Icons.face, size: 30,),
      Icon(Icons.notifications, size: 30,),
      Icon(Icons.message, size: 30,),
    ];
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color.fromARGB(255, 0, 194, 139),
      appBar: AppBar(
        title: Text("Track Transport ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Kanit'),textAlign: TextAlign.center,),
        backgroundColor: Colors.teal,
        leading: IconButton(
              onPressed: () async {
                  _scaffoldkey.currentState!.openDrawer();
                },
              icon: Icon(Icons.face, color: Colors.amber,), 
            ),
            actions: [
              Padding(padding: const EdgeInsets.only(left: 24.0),
              child: IconButton (
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const MapScreenPassenger()));
                },
                icon : Icon(Icons.location_pin,
              size: 36,
              color: Colors.amber,
              ),
              ),),
            ],
            ),
      drawer: MyDrawer(account: widget.account,),
       body: screens[selectedIndex],
      bottomNavigationBar:Theme( 
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.amber),
        ),
        child:CurvedNavigationBar(
        height: 60,
        index: selectedIndex,
        items: items,
        animationCurve: Curves.easeInOut,
        backgroundColor: const Color.fromARGB(255, 1, 70, 63),
        animationDuration: Duration(milliseconds: 300),
        buttonBackgroundColor: Colors.tealAccent,
        color:  const Color.fromRGBO(22, 91, 84, 1),
        onTap:  (index) {
            setState(() {
              selectedIndex = index;
            });
            },
        ),
      )
      );}
      );
  }
}
class HomePageContent extends StatefulWidget {
  final Account? account; 
  const HomePageContent({super.key ,required this.account});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
@override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 3,
    child: Column(
      children: [
        SizedBox(height: 35,),
        Text("Welcome ${widget.account?.userModel.firstName} ${widget.account?.userModel.lastName} to Home Page , Choose a type of Transport ! ".tr() , style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 1, 30, 27) , fontFamily: 'Kanit'),textAlign: TextAlign.center,),
        SizedBox(height: 35,),
        const TabBar(
          tabs: [
            Icon(Icons.local_taxi, size: 50, color: Color.fromARGB(255, 2, 59, 53)),
            Icon(Icons.train, size: 50, color: Color.fromARGB(255, 2, 59, 53)),
            Icon(Icons.directions_bus_rounded, size: 50, color: Color.fromARGB(255, 2, 59, 53)),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              Taxi(account: widget.account),
              Train(),
              Bus(),
            ],
          ),
        ),
      ],
    ),
  );
}
}
