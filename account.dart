import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/user.dart';

class Account {
  final String email;
  final UserModel userModel;
  Account({required this.email,required this.userModel});
  void deleteAccount(){
      Controller.deleteDocumentByAttribute('email',email,"account");
  }
  void createAccount(){
      Controller.addAccountDetails(this);
  }
  factory Account.fromMap(Map<String, dynamic> data) {  
    return Account(
      
      userModel: UserModel(id: data['id'], firstName: data['first name'], lastName: data['last name'], 
      age: data['age'], country: data['country'], role: data['role'], deviceId: data['device_id']
      ),
      email: data['email'],
    );
  }
  static void changeLanguageAccountToFrench(BuildContext context){
      context.setLocale(const Locale('fr'));
  }
  static void changeLanguageAccountToEnglish(BuildContext context){
      context.setLocale(const Locale('en'));
  }
  void changeFN(String newValue){
    userModel.changeFN(email, newValue);
  }
  void changeLN(String newValue){
    userModel.changeLN(email, newValue);
  }
  void changeAge(String newValue){
    userModel.changeAge(email, newValue);
  }
  void changeCountry(String newValue){
    userModel.changeCountry(email, newValue);
  }
}
