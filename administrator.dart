import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';
import 'package:transporttracking/View/users_list.dart';

class Administrator extends Account{
   @override
  final String email;
  final UserModel userModel;
  Administrator({required this.email, required this.userModel
  }) : super(email: email,userModel: userModel);
  void consultUsersList(BuildContext context){
     Navigator.push(context, MaterialPageRoute(builder: (context)=> UsersList(account: super)));
  }
  void sortUsersList(){
     
  }
  void blockUser(){

  }
}
