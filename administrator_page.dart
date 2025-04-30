import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/drawer.dart';
import 'package:transporttracking/View/notifications_page.dart';
import 'package:transporttracking/View/profil_page.dart';
import 'package:transporttracking/View/quiz_page.dart';
import 'package:transporttracking/View/settings_page.dart';
import 'package:transporttracking/View/users_list.dart';

class AdministratorPage extends StatefulWidget {
  final Account? account;
  const AdministratorPage({super.key, required this.account});

  @override
  State<AdministratorPage> createState() => _AdministratorPageState();
}

class _AdministratorPageState extends State<AdministratorPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late List<Widget> screens;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    screens = [
      HomePageContent(account: widget.account),
      SettingsPage(account: widget.account),
      UsersList(account: widget.account),
      ProfilPage(account: widget.account),
      Notificationspage(),
      QuizPageAdmin(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authApp = Firebase.app('AuthApp');
    final FirebaseAuth auth = FirebaseAuth.instanceFor(app: authApp);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final items = <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.settings, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.face, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.quiz, size: 30),
        ];
        return Scaffold(
          key: _scaffoldkey,
          backgroundColor: Color.fromARGB(255, 0, 194, 139),
          appBar: AppBar(
            title: Text(
              "Track Transport ".tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Kanit',
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.teal,
            leading: Icon(Icons.face, color: Colors.amber),
          ),
          drawer: MyDrawer(account: widget.account),
          body: screens[selectedIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(
              context,
            ).copyWith(iconTheme: IconThemeData(color: Colors.amber)),
            child: CurvedNavigationBar(
              height: 60,
              index: selectedIndex,
              items: items,
              animationCurve: Curves.easeInOut,
              backgroundColor: const Color.fromARGB(255, 1, 70, 63),
              animationDuration: Duration(milliseconds: 300),
              buttonBackgroundColor: Colors.tealAccent,
              color: const Color.fromRGBO(22, 91, 84, 1),
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class HomePageContent extends StatefulWidget {
  final Account? account;
  const HomePageContent({super.key, required this.account});

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
          SizedBox(height: 35),
          Text(
            "Welcome Administrator ${widget.account?.userModel.firstName} ${widget.account?.userModel.lastName} to Home Page , You can  :  "
                .tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 1, 30, 27),
              fontFamily: 'Kanit',
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 35),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 160),
                    border: Border.all(width: 10, color: Colors.amber),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => UsersList(account: widget.account),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Consult Users Now ! ".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 103, 72, 11),
                            fontFamily: 'Kanit',
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.asset('assets/Image1.png', width: 125),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 160),
                    border: Border.all(width: 10, color: Colors.amber),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProfilPage(account: widget.account),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Consult Profil Now  ! ".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 103, 72, 11),
                            fontFamily: 'Kanit',
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.asset('assets/pic2.jpg', width: 125),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 160),
                    border: Border.all(width: 10, color: Colors.amber),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPageAdmin(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Consult Quiz , Add questions and view responses ! "
                              .tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 103, 72, 11),
                            fontFamily: 'Kanit',
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.asset('assets/pic1.jpg', width: 125),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
