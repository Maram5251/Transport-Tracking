import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static final authApp = Firebase.app('AuthApp');
  static final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: authApp);
  List<Map<String, String>> allUsers = [];
  List<Map<String, String>> filteredUsers = [];
  bool isLoading = true;
  String query = '';
  late StreamSubscription _favoritesSubscription;

  // Local variable to track favorites
  Set<String> localFavorites = Set();

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
  }

  // Load users from the controller
  Future<void> loadUserData() async {
    final users = await Controller.getUserByRole();
    if (mounted) {
      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    }
  }

  // Listen to updates from Firebase for favorites
  void listenToFavorites() {
    _favoritesSubscription = Controller.getFavoritesStream().listen((favList) {
      if (mounted) {
        setState(() {
          // Update the local favorites state
          localFavorites = favList.map((fav) => fav['email'] ?? '').toSet();
        });
      }
    });
  }

  // Update search query and filter users
  void updateSearch(String input) {
    setState(() {
      query = input;
      filteredUsers = allUsers.where((user) {
        return user.values.any(
          (value) => value.toLowerCase().contains(query.toLowerCase()),
        );
      }).toList();
    });
  }

  // Check if the user is in favorites
  bool isFavorite(String? email) {
    return localFavorites.contains(email);
  }

  // Toggle favorite status
  void toggleFavorite(Map<String, String> user) async {
    final email = user['email'] ?? '';
    final userModel = UserModel(
      id: user['id'] ?? '',
      firstName: user['firstname'] ?? '',
      lastName: user['lastname'] ?? '',
      role: user['role'] ?? '',
      age: 0,
      country: user['country'] ?? '',
      deviceId: '',
    );
    final account = Account(email: email, userModel: userModel);

    setState(() {
      if (isFavorite(email)) {
        localFavorites.remove(email); // Remove from local favorites
      } else {
        localFavorites.add(email); // Add to local favorites
      }
    });

    // Now update Firebase
    if (isFavorite(email)) {
      // Remove from Firebase
      Controller.listenAndDeleteByField('Favorite'.tr(), 'email'.tr(), email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites'.tr())),
      );
    } else {
      // Add to Firebase
      Controller.addFavorite(account, _auth.currentUser!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites'.tr())),
      );
    }
  }

  // Build user tile widget
  Widget buildUserTile(Map<String, String> user) {
    bool isInFavorites = isFavorite(user['email']);
    Color iconColor = isInFavorites ?  Colors.white: const Color.fromARGB(255, 117, 17, 10);

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
        leading:IconButton(
  onPressed: () {
  },
  icon: Icon(
    user['role'] == 'Taxi Driver'.tr() ? Icons.local_taxi : Icons.train,
    size: 50,
    color: user['role'] == 'Taxi Driver'.tr()
        ? Colors.amber
        : const Color.fromARGB(255, 1, 1, 16),
  ),
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
  void dispose() {
    // Cancel the favorites stream subscription
    _favoritesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 194, 139),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: updateSearch,
                    decoration: InputDecoration(
                      hintText: 'Search...'.tr(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => updateSearch(''),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? Center(child: Text('No matching users found.'.tr()))
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            return buildUserTile(filteredUsers[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
