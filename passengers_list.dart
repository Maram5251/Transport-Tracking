import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';
import 'package:transporttracking/View/favorite_page_taxi.dart';
import 'package:transporttracking/View/messsages_taxi_train.dart';
import 'package:transporttracking/View/profil_page.dart';
import 'package:transporttracking/View/settings_page.dart';
import 'package:transporttracking/View/taxi_driver_home_page.dart';

class PassengersList extends StatefulWidget {
  final UserModel? userModel;
  final Account? account;
  const PassengersList({super.key,required this.account , this.userModel});

  @override
  State<PassengersList> createState() => _PassengersListState();
}

class _PassengersListState extends State<PassengersList> {
  static final authApp = Firebase.app('AuthApp');  
 static final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: authApp);
  List<Map<String, String>> allAccounts = [];
  List<Map<String, String>> filteredAccounts = [];
  List<Map<String, String>> favorites = [];
  bool isLoading = true;
  int selectedIndex = 0;
  late List<Widget> screens;

  final TextStyle userTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 1, 30, 27),
    fontFamily: 'Kanit',
    fontSize: 20,
  );

  @override
  void initState() {
    super.initState();
    loadUserData();
    listenToFavorites();

    screens = [
      TaxiDriverHomePage(account: widget.account),
      SettingsPage(account: widget.account),
      FavoritePageTaxi(account: widget.account),
      ProfilPage(account: widget.account),
      PassengersList(account: widget.account,),
      MessagesTaxiTrain(),
    ];
  }

  Future<void> loadUserData() async {
    final users = await Controller.getAccountsWithSpecificFavorite();
    setState(() {
      allAccounts = users;
      filteredAccounts = users;
      isLoading = false;
    });
  }

  void listenToFavorites() {
    Controller.getFavoritesStream().listen((favList) {
      setState(() {
        favorites = favList;
      });
    });
  }

  bool isFavorite(String? email) {
    return favorites.any((fav) => fav['email'] == email);
  }

  void toggleFavorite(Map<String, String> user) {
    final email = user['email'] ?? '';
    final userModel = UserModel(
      id: user['id']??'',
      firstName: user['firstname'] ?? '',
      lastName: user['lastname'] ?? '',
      role: user['role'] ?? '',
      age: 0,
      country: user['country'] ?? '',
      deviceId: '',
    );
    final account = Account(email: email, userModel: userModel);

    final isAdded = isFavorite(email);

    if (!isAdded) {
      Controller.addFavorite(account , _auth.currentUser!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites'.tr())),
      );
    } else {
      Controller.listenAndDeleteByField('Favorite', 'email', email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites'.tr())),
      );
    }
  }

  Widget buildUserTile(Map<String, String> user) {
    final isAdded = isFavorite(user['email']);
    final Color iconColor =
        isAdded ? const Color.fromARGB(255, 117, 17, 10) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.teal,
        border: Border.all(
          width: 5,
          color: const Color.fromARGB(255, 11, 12, 12),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: ListTile(
        leading: Icon(
          Icons.face,
          size: 50,
          color:   Colors.white,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user['firstname'] ?? 'No FirstName'.tr(), style: userTextStyle),
            Text(user['lastname'] ?? 'No LastName'.tr(), style: userTextStyle),
            Text(user['role'] ?? 'No Role'.tr(), style: userTextStyle),
            Text(user['country'] ?? 'No Country'.tr(), style: userTextStyle),
          ],
        ),
        subtitle: Text(
          user['email'] ?? 'No Email'.tr(),
          style: userTextStyle,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.favorite, size: 25, color: iconColor),
          onPressed: () => toggleFavorite(user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30),
       const Icon(Icons.settings, size: 30),
       const Icon(Icons.favorite, size: 30),
       const Icon(Icons.face, size: 30),
       const Icon(Icons.notification_add, size: 30,),
       const Icon(Icons.message, size: 30,),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Taxis'.tr(),style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Kanit'),textAlign: TextAlign.center,),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 194, 139),
      body: selectedIndex == 0
          ? isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: filteredAccounts.isEmpty
                          ?  Center(child: Text('No matching users found.'.tr()))
                          : ListView.builder(
                              itemCount: filteredAccounts.length,
                              itemBuilder: (context, index) {
                                return buildUserTile(filteredAccounts[index]);
                              },
                            ),
                    ),
                  ],
                )
          : screens[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        child: CurvedNavigationBar(
          height: 60,
          index: selectedIndex,
          items: items,
          animationCurve: Curves.easeInOut,
          backgroundColor: const Color.fromARGB(255, 1, 70, 63),
          animationDuration: const Duration(milliseconds: 300),
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
  }
}
