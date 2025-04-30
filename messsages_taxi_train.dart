import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/messages.dart';

class MessagesTaxiTrain extends StatefulWidget {
  const MessagesTaxiTrain({super.key});

  @override
  State<MessagesTaxiTrain> createState() => _MessagesTaxiTrainState();
}

class _MessagesTaxiTrainState extends State<MessagesTaxiTrain> {
  List<Map<String, String>> allUsers = [];
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
    final users = await Controller.getAccountsPassengers();
    setState(() {
      allUsers = users;
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
              color:  Colors.white,
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
          icon: const Icon(Icons.message, size: 25, color: Colors.blue),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Messages(
                recieverUserEmail: user['email'] ?? '',
                recieverUserID: user['id'] ?? '',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 194, 139),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allUsers.isEmpty
              ? Center(child: Text('No matching users found.'.tr()))
              : ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    return buildUserTile(allUsers[index]);
                  },
                ),
    );
  }
}
