import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';

class UsersList extends StatefulWidget {
  final UserModel? userModel;
  final Account? account;
  const UsersList({super.key, required this.account, this.userModel});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<Map<String, String>> allAccounts = [];
  bool isLoading = true;

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
  }

  Future<void> loadUserData() async {
    final accounts = await Controller.getAccounts();
    setState(() {
      allAccounts = accounts;
      isLoading = false;
    });
  }

  Widget buildUserTile(Map<String, String> user) {
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
          color: const Color.fromARGB(255, 255, 254, 252),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              user['firstname'] ?? 'No FirstName'.tr(),
              style: userTextStyle,
            ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 194, 139),
      body: Column(
        children: [
          Expanded(
            child:
                allAccounts.isEmpty
                    ? Center(child: Text('No matching users found.'.tr()))
                    : ListView.builder(
                      itemCount: allAccounts.length,
                      itemBuilder: (context, index) {
                        return buildUserTile(allAccounts[index]);
                      },
                    ),
          ),
        ],
      )
    );
  }
}
