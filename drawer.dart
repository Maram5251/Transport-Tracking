import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:easy_localization/easy_localization.dart';

class MyDrawer extends StatefulWidget {
  final Account? account;
  const MyDrawer({super.key ,required this.account});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
 
   @override
  Widget build(BuildContext context) {
    return Drawer(
       backgroundColor: Color.fromARGB(255,179, 216, 168),
        child: ListView(
          padding: EdgeInsets.all(12),
          physics: BouncingScrollPhysics(),
          children: [
            Center (  
            child : 
            UserAccountsDrawerHeader( 
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              border: Border.all(
                width: 5,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            accountName: Align( alignment: Alignment.center , child : Text('${widget.account?.userModel.firstName} ${widget.account?.userModel.lastName}', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kanit', color: const Color.fromARGB(255, 2, 73, 66)),)),
            accountEmail:Align(alignment: Alignment.center , child:  Text('${widget.account?.email}', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Kanit', color: const Color.fromARGB(255, 2, 73, 66)),)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.amber,
              child: 
              ClipOval(
                child: Icon(Icons.face,size: 50, color: const Color.fromARGB(255, 2, 70, 63),),
              ),
            ),
            ),),
            ListTile(
              leading: Icon(Icons.info_rounded,color :  Colors.white , size: 20,),
              title: Text('See Profil Details'.tr(), style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.emoji_transportation_rounded,color :  Colors.white , size: 20,),
              title: Text('See Transport Favorites'.tr(), style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.home,color :  Colors.white , size: 20,),
              title: Text('Go Home'.tr(), style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.settings,color :  Colors.white , size: 20,),
              title: Text('Settings'.tr(), style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.logout,color :  Colors.white , size: 20,),
              title: Text('Logout from application'.tr(),  style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ) 
    );

    }
    Widget divider(){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Divider(
          thickness: 1.5,
        ),
      );
    }
}