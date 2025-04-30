import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';

class Passenger extends Account{
   @override
  final String email;
  final UserModel userModel;
  Passenger({required this.email, required this.userModel
  }) : super(email: email, userModel: userModel);
  void getMetroTimes(){
    
  }
  }