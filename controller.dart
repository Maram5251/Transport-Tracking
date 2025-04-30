
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/location.dart';
import 'package:transporttracking/Model/message.dart';
import 'package:transporttracking/Model/user.dart';
import 'package:transporttracking/View/dialog.dart';
import 'package:transporttracking/View/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transporttracking/Controller/login_or_register_page_controller.dart';
import 'package:transporttracking/View/registerpage.dart';
import 'package:transporttracking/get_access_token.dart';
class Controller {
 static final authApp = Firebase.app('AuthApp');  
 static final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: authApp);
 static final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: authApp);
 static bool isConnected(User? user) {
  return user != null; 
 }
  
 static Future<List<Map<String, String>>> getAccountsWithSpecificFavorite() async {
  List<Map<String, String>> myList = [];

  try {
    CollectionReference favorites = _firestore.collection('Favorite');

    QuerySnapshot favoriteSnapshot = await favorites
        .where('Favorite_id', isEqualTo: _auth.currentUser!.uid)
        .get();

    if (favoriteSnapshot.docs.isNotEmpty) {
      final favoriteData = favoriteSnapshot.docs.first.data() as Map<String, dynamic>;
      final String id = favoriteData['id'];

      CollectionReference accounts = _firestore.collection('accounts');
      QuerySnapshot accountsSnapshot = await accounts
          .where('id', isEqualTo: id)
          .get();

      for (var doc in accountsSnapshot.docs) {
        final accountData = doc.data() as Map<String, dynamic>;

        final Account account = Account(
          email: accountData['email'],
          userModel: UserModel(
            id: accountData['id'],
            firstName: accountData['first name'],
            lastName: accountData['last name'],
            age: accountData['age'],
            country: accountData['country'],
            role: accountData['role'],
            deviceId: accountData['device_id'],
          ),
        );

        myList.add({
          'id': account.userModel.id,
          'email': account.email,
          'firstname': account.userModel.firstName,
          'lastname': account.userModel.lastName,
          'country': account.userModel.country,
          'role': account.userModel.role,
        });
      }
    }
  } catch (e) {
    print('Error fetching favorite accounts: $e');
  }

  return myList;
}


  static Stream<bool> userConnectionStream() {
  return _auth.authStateChanges().map(isConnected);
}


static Future<List<Map<String ,String >>> getAccountsPassengers() async {
  List<Map<String ,String >> myList = [];

  try {
    CollectionReference accounts = _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('role', isEqualTo: 'Passenger').get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Account account = Account(
          email: data['email'],
          userModel: UserModel(
            id: data['id'],
            firstName: data['first name'],
            lastName: data['last name'],
            age: data['age'],
            country: data['country'],
            role: data['role'],
            deviceId: data['device_id'],
          ),
        );
        Map<String, String> myDictionary = {
          'id':account.userModel.id,
          'email': account.email,
          'firstname': account.userModel.firstName,
          'lastname': account.userModel.lastName,
          'country': account.userModel.country,
          'role': account.userModel.role,
        };

        myList.add(myDictionary);
      }
    }
  } catch (e) {
    print('Error updating user attribute: $e');
    return [];
  }
  return myList;
}


static Future<List<Map<String ,String >>> getAccounts() async {
  List<Map<String ,String >> myList = [];

  try {
    CollectionReference accounts = _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final Account account = Account(
          email: data['email'],
          userModel: UserModel(
            id: data['id'],
            firstName: data['first name'],
            lastName: data['last name'],
            age: data['age'],
            country: data['country'],
            role: data['role'],
            deviceId: data['device_id'],
          ),
        );
        Map<String, String> myDictionary = {
          'email': account.email,
          'firstname': account.userModel.firstName,
          'lastname': account.userModel.lastName,
          'country': account.userModel.country,
          'role': account.userModel.role,
        };

        myList.add(myDictionary);
      }
    }
  } catch (e) {
    print('Error updating user attribute: $e');
    return [];
  }
  return myList;
}


static void changeUserAttribute(String email ,String attributeName, String newValue) async {
  try {
    CollectionReference users =  _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await users.where('email',isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
          await doc.reference.update({
          attributeName: newValue,
        });
      }}
      }
      catch (e) {
    print('Error updating user attribute: $e');
  }
}

static Future<List<Account>> getUsersInTheDevice() async {
  List<Account> myList = [];

  final deviceId = await Controller.getDeviceId();
  try {
    CollectionReference accounts = _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('device_id', isEqualTo: deviceId).get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Account account = Account(email: data['email'], userModel: UserModel(id: data['id'] ,firstName: data['first name'], lastName: data['last name'], age: data['age'], country: data['country'], role: data['role'], deviceId: data['device_id']));
        print(account);
        myList.add(account);
      }
    return myList;
  } catch (e) {
    print("Error fetching users: $e");
    return [];
  }
}
    
    static Future<void> addAccountDetails(Account account) async {
    DocumentReference docRef = await _firestore.collection('accounts').add({
      'email': account.email,
      'first name' :account.userModel.firstName,
      'last name' : account.userModel.lastName,
      'age' :account.userModel.age,
      'role': account.userModel.role,
      'country': account.userModel.country,
      'device_id': account.userModel.deviceId,
    });
    await docRef.update({
    'id': _auth.currentUser!.uid,
  });
  }
  
  
  static Future<void> addUserLocation(UserModel usermodel,MyLocation location ) async {
    await _firestore.collection('location').add({
      'longitude': location.longitude,
      'latitude':location.latitude,
      'role': usermodel.role,
    });
  }
  static Future<void> addFavorite(Account account , String id) async {
    await  _firestore.collection('Favorite').add({
      'id' : id,
      'id_favorite': account.userModel.id,
      'first name' :account.userModel.firstName,
      'last name' : account.userModel.lastName,
      'role': account.userModel.role,
      'country': account.userModel.country,
      'age' :account.userModel.age,
      'device_id': account.userModel.deviceId,
    });
  }
  
  static Stream<List<Map<String, String>>> getFavoritesStream() {
  final collection =  _firestore.collection('Favorite');

  return collection.snapshots().map((snapshot) {
    List<Map<String, String>> favorites = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      Map<String, String> myDictionary = {
        'firstname': data['first name'] ?? '',
        'lastname': data['last name'] ?? '',
        'email': data['email'] ?? '',
        'country': data['country'] ?? '',
        'role': data['role'] ?? '',
      };

      favorites.add(myDictionary);
    }

    return favorites;
  });
}


 static void listenAndDeleteByField(String collectionName, String field, String value) {
    _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete().then((_) {
          print('Document ${doc.id} deleted');
        }).catchError((e) {
          print('Failed to delete document: $e');
        });
      }
    });
  }


  static Future<MyLocation?> getUserLocation(String email) async {
     try {
    CollectionReference locations =  _firestore.collection('location');

    QuerySnapshot querySnapshot = await locations.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return MyLocation.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
    } 
  } catch (e) {
    return null;
  }
  return null;
}


static Future<Account?> getUserByEmail(String email) async {
  try {
    CollectionReference accounts =  _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      final Account account = Account(email: data['email'], userModel: UserModel(id: data['id'], firstName: data['first name'], lastName: data['last name'], age: data['age'], country: data['country'], role: data['role'], deviceId: data['device_id']));
      return account;
    } 
  } catch (e) {
    return null;
  }
  return null;
}

static Future<Account?> getAccountByEmail(String email) async {
  try {
    CollectionReference accounts =  _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      final Account account = Account(email: data['email'], userModel: UserModel(id: data['id'], firstName: data['first name'], lastName: data['last name'], age: data['age'], country: data['country'], role: data['role'], deviceId: data['device_id']));
      return account;
    } 
  } catch (e) {
    return null;
  }
  return null;
}

static Future<List<Account?>> getUsersInTheDeviceWithDifferentEmails() async {
  List<Account?> myList = [];

  final deviceId = await Controller.getDeviceId();
   String currentUserEmail = (await Controller.getCurrentUserEmail().first) ?? '';
  try {
    CollectionReference accounts = _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('device_id', isEqualTo: deviceId).get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Account account = Account.fromMap(data);
      if (data['email'] != (currentUserEmail)) {
        myList.add(account);
      }
    }
    
    return myList;
  } catch (e) {
    print("Error fetching users: $e");
    return [];
  }
}


static Future<List<Map<String, String>>> getUserByRole() async {
  List<Map<String, String>> myList = []; 
  try {
    CollectionReference accounts =  _firestore.collection('accounts');

    QuerySnapshot querySnapshot = await accounts.where('role', whereIn: ['Transport Agent', 'Taxi Driver']).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final Account account = Account(
          email: data['email'],
          userModel: UserModel(
            id : data['id'],
            firstName: data['first name'],
            lastName: data['last name'],
            age: data['age'],
            country: data['country'],
            role: data['role'],
            deviceId: data['device_id'],
          ),
        );        
        Map<String, String> myDictionary = {
          'id': account.userModel.id,
          'email': account.email,
          'firstname': account.userModel.firstName,
          'lastname': account.userModel.lastName,
          'country': account.userModel.country,
          'role': account.userModel.role,
        };

        myList.add(myDictionary); 
      }
    }
  } catch (e) {
    return []; 
  }
  return myList; 
}




static void signUserIn(BuildContext context,TextEditingController emailController, 
TextEditingController userpasswordController,bool mounted, StatefulWidget widget) async{
    showDialog(context: context, builder:(context){ 
    return const Center(
     child: CircularProgressIndicator()
    );}
    );
    try {
    await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: userpasswordController.text,
    );
    if (context.mounted) Navigator.pop(context);
    if (context.mounted){
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    }
    }on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context); 
        Login.showAlert(context, "Error", e.message ?? "An unknown error occurred.");
      }
  }
}

static void signUserUp(BuildContext context , bool mounted , TextEditingController emailController, TextEditingController userpasswordController,
TextEditingController confirmpasswordController, StatefulWidget widget
) async{
    showDialog(context: context, builder:(context){ 
    return const Center(
     child: CircularProgressIndicator()
    );}
    );
    if (confirmpasswordController.text==userpasswordController.text){
      try {await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: userpasswordController.text,
    );if (context.mounted) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginOrRegisterPage(stfwidget: widget,)));
  }} on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context); 
        MyDialog.showMyDialog(context: context , mywidget:  Registerpage(onTap:null, stfwidget: widget,), dialogtype: DialogType.error, title: 'SignUpError', description: e.message ?? "An unknown error occurred.");
      }
  }
  }else{
    MyDialog.showMyDialog(context: context , mywidget:  Registerpage(onTap:null, stfwidget: widget,), dialogtype: DialogType.error, title: 'SignUpError', description: "Passwords don't match");
  }}

static Stream<String?> getCurrentUserEmail() {
  return _auth.authStateChanges().map((user) => user?.email);
}

static Future<bool> isUserRegistered(String email) async {
  QuerySnapshot query = await _firestore
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  return query.docs.isNotEmpty; 
}

static void listenForAuthStateChanges() {
  _auth.authStateChanges().listen((user) async {
    if (user != null) {
      try {
        await user.reload(); 
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'user-not-found') {
          await FirebaseAuth.instance.signOut();     
        }
      }
    }
  });
}
 static Future<void> deleteDocumentByAttribute(String attributeName, String attributeValue, String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName) 
          .where(attributeName, isEqualTo: attributeValue)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          DocumentReference documentRef = doc.reference;

          await documentRef.delete();
        }
      } else {
      }
    } catch (e) {
      return;
    }
  }

    static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
     return androidInfo.id; 
  }
  
  static void addTrainDetails(int numberOfStations, String trainSpeed, List<String> distances) async {
    await _firestore.collection('trainDetails').add({
        'numberOfStations': numberOfStations,
        'trainSpeed': double.parse(trainSpeed),
        'distances': distances,
        'timestamp': FieldValue.serverTimestamp(),
      });
  }

   static Future<List<Map<String, int>>> getTrainTime() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trainDetails')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      double trainSpeed = data['trainSpeed'];

      List<dynamic> rawDistances = data['distances'];
      List<double> distances =
          rawDistances.map((d) => double.parse(d.toString())).toList();

      List<Map<String, int>> trainTimes = [];

      for (double distance in distances) {
        double timeInHours = distance / trainSpeed;

        int heure = timeInHours.floor();
        double fractionalHour = timeInHours - heure;

        int minute = (fractionalHour * 60).floor();
        double fractionalMinute = (fractionalHour * 60) - minute;

        int seconde = (fractionalMinute * 60).round();

        trainTimes.add({
          'heure': heure,
          'minute': minute,
          'seconde': seconde,
        });
      }

      return trainTimes;
    } else {
      return [];
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return [];
  }
}

static Future<void> sendMessage(String message, String receiverId) async {
   final String currentUserId=_auth.currentUser!.uid;
   final String currentUserEmail=_auth.currentUser!.email.toString();
   final Timestamp timestamp=Timestamp.now();
   var receiverEmail='';
 QuerySnapshot receiverQuery = await _firestore
    .collection('accounts')
    .where('id', isEqualTo: receiverId)
    .limit(1)   
    .get();

if (receiverQuery.docs.isNotEmpty) {
  DocumentSnapshot receiverDoc = receiverQuery.docs.first;
  receiverEmail = receiverDoc['email'];
  print(receiverEmail); 
} else {
  print('No receiver found with that ID.');
}
   Message newMessage=Message(message: message, receiverId: receiverId, senderEmail:currentUserEmail,receiverEmail: receiverEmail, senderId: currentUserId, timeStamp: timestamp);
   List<String> ids=[currentUserId, receiverId];
   ids.sort();
   String chatRoomId=ids.join("_");
   await _firestore.collection('chatrooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
}

static Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
  List<String> ids= [userId, otherUserId];
  ids.sort();
  String chatRoomId=ids.join("_");
  return _firestore
  .collection('chatrooms')
  .doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
}

static Future<void> sendPushNotification(String token, String title, String body) async {
  final accessToken = await GetAccessToken.getAccessTokenFromServiceAccount();
  
  final url = Uri.parse('https://fcm.googleapis.com/v1/projects/your-project-id/messages:send');

  final message = {
    "message": {
      "token": token,
      "notification": {
        "title": title,
        "body": body
      },
      "data": {
        "key1": "value1",
        "key2": "value2",
      }
    }
  };

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification');
    print(response.body);
  }
}

static Future<void> getDeviceToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? token = await messaging.getToken();
  print('Device FCM Token: $token');
}

  }
