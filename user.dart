
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';

class UserModel{
  final String id;
  final String firstName;
  final String lastName;
  final int? age;
  final String country;
  final String role;
  final String deviceId;
  UserModel({required this.id,required this.firstName, required this.lastName, required this.age , required this.country , required this.role, required this.deviceId});
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id']??'',
      firstName: data['first name'] ?? '',
      lastName: data['last name'] ?? '',
      age: data['age']?? 0, 
      country: data['country'] ?? '',
      role: data['role'] ?? '',
      deviceId: data['device_id']??'',
    );
  }
  void changeFN(String email,String newValue){
  Controller.changeUserAttribute(email,'first name', newValue);
  }
   void changeLN(String email,String newValue){
      Controller.changeUserAttribute(email,'first name', newValue);

  }
   void changeEmail(String email,String newValue){
          Controller.changeUserAttribute(email,'email', newValue);

  }
   void changeCountry(String email,String newValue){
          Controller.changeUserAttribute(email,'country', newValue);

  }
   void changeAge(String email,String newValue){
      Controller.changeUserAttribute(email,'age', newValue);
    
  }
  void logIn(BuildContext context, TextEditingController emailController,TextEditingController userpasswordController,bool mounted,StatefulWidget widget){
     Controller.signUserIn(context, emailController, userpasswordController, mounted, widget);
  }
  void signUp(BuildContext context,bool mounted,TextEditingController emailController,TextEditingController userpasswordController,TextEditingController confirmpasswordController,StatefulWidget widget){
    Controller.signUserUp(context, mounted, emailController, userpasswordController, confirmpasswordController, widget);
  }
  }