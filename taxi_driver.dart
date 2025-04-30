import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';

class TaxiDriver extends Account{
   @override
  final String email;
  final UserModel userModel;
  TaxiDriver({required this.email, required this.userModel
  }) : super(email: email, userModel: userModel);
  }