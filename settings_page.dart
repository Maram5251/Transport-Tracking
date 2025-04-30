import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/dialog.dart';
import 'package:transporttracking/View/feedback_page.dart';
import 'package:transporttracking/View/languages.dart';
import 'package:transporttracking/View/report_a_bug_page.dart';
import 'package:transporttracking/View/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class SettingsPage extends StatefulWidget {

  final Account? account;
  const SettingsPage({super.key ,required this.account});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   List<Account?> accounts = [];
  static final authApp = Firebase.app('AuthApp');  
  static final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: authApp);    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          lightTheme: SettingsThemeData(settingsListBackground: Color.fromARGB(255, 0, 194, 139)),
          contentPadding: EdgeInsets.only(top: 25),
          sections: [
            SettingsSection(
            title: Text('PROFIL '.tr(),style: TextStyle(fontFamily: 'Kanit' )),
              tiles: 
            [
              SettingsTile.navigation(
                title: 
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  border: Border.all(
                    width: 5,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  children: [ 
                    Icon(Icons.face, size: 45,color: Colors.amber,),
                    SizedBox(width: 25.0,),
                    Flexible(child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    Text('${widget.account?.userModel.firstName??''} ${widget.account?.userModel.lastName??''}'.tr(), style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.normal, color: Colors.white),
                     overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                    ),
                     Text('${widget.account?.email}'.tr(), style: TextStyle(fontFamily: 'Kanit', color: Colors.amber, fontSize: 15,
                      ), overflow: TextOverflow.ellipsis,
                      maxLines: 1,),
                   ],
                    ),),
                    SizedBox(width: 10.0,),
                    
                    GestureDetector(
                onTap: () async {
             List<Account?> result = await Controller.getUsersInTheDeviceWithDifferentEmails();
              setState(() {
              accounts = result;
              });
            if (context.mounted){
            showDialog(
            context: context,
            barrierColor: Color.fromARGB(200, 0, 0, 0),
           builder: (context) => AlertDialog(
            backgroundColor: Colors.teal,
           shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 5, color: Colors.black),
         ),
        title: Text("Other Users on Device".tr(), style: TextStyle(color: Colors.white, fontFamily: 'Kanit')),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: accounts.isNotEmpty
              ? ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade700,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${account?.userModel.firstName?? ''} ${account?.userModel.lastName ?? ''}'.tr(),
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            account?.email ?? ''.tr(),
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Colors.amber,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Text("No other users found.".tr(), style: TextStyle(color: Colors.white, fontFamily: 'Kanit')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
               padding: EdgeInsets.all(15),
               decoration: BoxDecoration(color: Colors.teal[900],
               borderRadius: BorderRadius.all(Radius.circular(15)),
               ),
               child: Text("Close".tr(), style: TextStyle(color: Colors.white,fontFamily: 'Kanit', fontWeight: FontWeight.bold ))),
          ),
        ],
      ),
    );}
  },
  child: Icon(Icons.more_horiz, size: 25),
),                      
                    ],), 
                ),
               ),
          ]),
             SettingsSection(
              title: Text('GENERAL'.tr(),style: TextStyle(fontFamily: 'Kanit' )),
              tiles: [
                SettingsTile.navigation
              ( leading: Icon(Icons.person),
                title: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Languages()));
                },
                child: Text('Account Settings'.tr(), style: TextStyle(fontSize: 20,fontFamily: 'Kanit'),),),
              Text(
              'Language'.tr(),
              style: TextStyle(
              fontSize: 12,
              color: Colors.amber,
              fontFamily: 'Kanit',
               ),)],
               ),
                onPressed: (context) {               
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Languages())) ;             
                },
                ),
                SettingsTile.navigation
              ( leading: Icon(Icons.logout),
                title: 
              Text('Logout'.tr(), style: TextStyle(fontSize: 20, fontFamily: 'Kanit'),),
                onPressed: (context) async {     
                  if (context.mounted)MyDialog.showMyDialog(context: context, mywidget:SplashScreen(), dialogtype: DialogType.success , title: "LogOut ".tr(), description: "You have logged out !!".tr());
                  await _auth.signOut();  
                },
                ),
                 SettingsTile.navigation
              ( leading: Icon(Icons.delete),
                title: 
              Text('Delete Account'.tr(), style: TextStyle(fontSize: 20, fontFamily: 'Kanit'),),
                onPressed: (context) async {    
                  await _auth.currentUser?.delete();     
                  if (widget.account!=null)widget.account!.deleteAccount();
                  Controller.deleteDocumentByAttribute('email', widget.account?.email??'',"account");
                  if (context.mounted)MyDialog.showMyDialog(context: context, mywidget: SplashScreen(), dialogtype: DialogType.success , title: "Delete Account".tr(), description: "Account Deleted".tr());
                },
                ),
              ]
             ),
              SettingsSection(
              title: Text('FEEDBACK'.tr(),style: TextStyle(fontFamily: 'Kanit' )),
              tiles: [
                SettingsTile.navigation
              ( leading: Icon(Icons.bug_report),
                title:
              Text('Report a Bug'.tr(), style: TextStyle(fontSize: 20,fontFamily: 'Kanit'),),
                onPressed: (context) { 
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportBugPage()));              
                },
                ),
                SettingsTile.navigation
              ( leading: Icon(Icons.favorite),
                title: 
              Text('Send Feedback'.tr(), style: TextStyle(fontSize: 20,fontFamily: 'Kanit'),),
                onPressed: (context) { 
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedbackPage())) ;             
                },
                ),
                ]),
          ],
        ),
      ),
      
    );
  }
}