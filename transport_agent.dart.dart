
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';

class TransportAgent extends Account{
   @override
  final String email;
  final UserModel userModel;
  TransportAgent({required this.email, required this.userModel
  }) : super(email: email, userModel: userModel);
  
  void setDistances(){

  }
  void setTrainDeparture(){

  }

}

  
