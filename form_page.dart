import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/Model/user.dart';
import 'package:transporttracking/View/administrator_page.dart';
import 'package:transporttracking/View/country_page.dart';
import 'package:transporttracking/View/form_component.dart';
import 'package:transporttracking/View/passenger_home_page.dart';
import 'package:transporttracking/View/role_field.dart';
import 'package:transporttracking/View/taxi_driver_home_page.dart';
import 'package:transporttracking/View/transport_agent_home_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});
  
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final firstNameController= TextEditingController() ;
  final lastNameController= TextEditingController() ;
  final ageController= TextEditingController() ;
  final countryController= TextEditingController() ; 
  final roleController= TextEditingController() ; 
  int currentStep=0; 
  
  final _personalInfoFormKey =GlobalKey<FormState> ();
  final _roleFormKey=GlobalKey<FormState> (); 
  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
         title: Text("Getting Started".tr()),
         centerTitle: true,
         backgroundColor: Colors.amber,
      ),
      body:
       Container(
        decoration:  BoxDecoration(
          color: const Color.fromARGB(255, 250, 189, 215),
        ),
        child: Column (
          children : [ 
         Expanded(
         child : Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 142, 142),
            border: Border.all(
              width: 5,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
           child: Theme(
          data: ThemeData(canvasColor: Colors.amberAccent),
           child: Stepper(     
            type: StepperType.horizontal, 
            steps: getSteps(),
            currentStep: currentStep,
            
            onStepContinue: _onStepContinue,
            onStepCancel: currentStep == 0 ? null : () => setState(() => currentStep -= 1), 
           
              ),
         ),),),
        if (currentStep==2)
       Container(
  margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
  child: ElevatedButton(
    onPressed: () {        
        navigateToHome(context, firstNameController, lastNameController, ageController, countryController, roleController);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home),
        SizedBox(width: 10), 
        Text("Go to Home Page".tr(), textAlign: TextAlign.center),
      ],
       ),
       ),
      ),
        if (!keyboardVisible) 
        Container(
          margin: EdgeInsets.all(10),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child : Image.asset('assets/train.jpg',
          width: 200,),),
        ),
        ]),
      ),
    );
  }
   List<Step> getSteps(){return[
    Step(
      isActive: currentStep >=0,
      title: SizedBox( 
        width: 60,
        child :  Text('Personal Informations'.tr() , style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),softWrap: true,
    overflow: TextOverflow.visible,),),
      content: Form ( 
        key: _personalInfoFormKey,
        child: Column(
        children: [
          FormComponent(labeltext: "First Name".tr(), hinttext: "Choose First Name".tr(),controller: firstNameController,),
          SizedBox(height: 10,),
          FormComponent(labeltext: "Last Name".tr(), hinttext: "Choose Last Name".tr(),controller: lastNameController,),
          SizedBox(height: 10,),
          FormComponent(labeltext: "Age".tr(), hinttext: "Choose Age".tr(),controller: ageController,),
          SizedBox(height: 10,),
          CountryPage(controller: countryController),
        ],
      ),),
    ),
    Step(
    isActive: currentStep >=1,
    title: SizedBox(
      width: 30,
      child: Text('Role'.tr(),style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),softWrap: true,
    overflow: TextOverflow.visible,)),
    content: 
    Form(
      key: _roleFormKey,
      child: RoleField(controller: roleController),)
    ),
    Step(isActive: currentStep >=2,
    title: SizedBox(
      width: 50,
      child: Text('Complete'.tr(),style: TextStyle(fontSize: 8 , fontWeight: FontWeight.bold),softWrap: true,
    overflow: TextOverflow.visible,)),
    content: Column(children: [
      Text("Completed !".tr()),
    ],) 
    )
  ];}
  void _onStepContinue() {
    if (currentStep == 0) {
      if (_personalInfoFormKey.currentState!.validate()) {
        setState(() => currentStep += 1);
      }}
      else if (currentStep == 1) {
      if (_roleFormKey.currentState!.validate()) {
        setState(() => currentStep += 1);
      }}
}
static void navigateToHome (BuildContext context, TextEditingController firstNameController,TextEditingController lastNameController , TextEditingController ageController, TextEditingController countryController, TextEditingController roleController ) async {
  final String firstName = firstNameController.text;
      final String lastName = lastNameController.text;
      final int? age = int.tryParse(ageController.text);
      final String country = countryController.text;
      final String role = roleController.text;
      String? userEmail = await Controller.getCurrentUserEmail().first??'';
        UserModel userModel = UserModel(
          id: '',
          firstName: firstName,
          lastName: lastName,
          age: age,
          country: country,
          role: role,
          deviceId: await Controller.getDeviceId(),
        );
        Account userAccount=Account(email: userEmail, userModel: userModel);
        userAccount.createAccount();
      bool isTransportAgent=(userModel.role=='Transport Agent'.tr());
      bool isTaxiDriver=(userModel.role=='Taxi Driver'.tr());
      bool isPassenger=(userModel.role=='Passenger'.tr());
      StatefulWidget homePage;
       if (isPassenger) {
             homePage = PassengerHomePage( account: userAccount );
             } else if (isTaxiDriver) {
             homePage = TaxiDriverHomePage(account: userAccount);
            } else if (isTransportAgent) {
             homePage = TransportAgentHomePage(account:  userAccount,);
            } else {
             homePage = AdministratorPage(account:  userAccount,);
             } 
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homePage),
          );
        }
}
}