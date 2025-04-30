import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Model/account.dart';
import 'package:transporttracking/View/taxis.dart';

class Taxi extends StatefulWidget {
  final Account? account;
  const Taxi({super.key,required this.account });

  @override
  State<Taxi> createState() => _TaxiState();
}

class _TaxiState extends State<Taxi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(18),
      height: (MediaQuery.of(context).size.height) * 0.5,
      decoration: BoxDecoration(
        border: Border.all(width: 5,
        color: Colors.amber),
        color: Colors.teal,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),

      child:
       Column(
          children: [
          Image.asset('assets/taxi.png', height: 250,), 
          Container(
          padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(width: 5, color: Colors.teal),
            ),
            child: GestureDetector( 
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) => Taxis(account: widget.account,)));
              },
              child:Text('Reserve a Taxi Now !! '.tr(), style:TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 78, 59, 3), fontFamily: 'Kanit'),)), ),   
          ],
        ),
      );
  }
}