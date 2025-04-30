import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  final TextStyle userTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 1, 30, 27),
    fontFamily: 'Kanit',
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'.tr()),
        backgroundColor: Colors.white,
        leading: Icon(Icons.favorite, color: Color.fromARGB(255, 149, 15, 5)),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 194, 139),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: Controller.getFavoritesStream(),
        builder: (context, snapshot) {
          // Check the connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // If no data or empty list, display a message
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites added yet.'.tr()));
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final user = favorites[index];

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
                    user['role'] == 'Taxi Driver'.tr() ? Icons.local_taxi : Icons.train,
                    size: 50,
                    color: user['role'] == 'Taxi Driver'.tr()
                        ? Colors.amber
                        : const Color.fromARGB(255, 1, 1, 16),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}