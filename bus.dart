import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Bus extends StatefulWidget {
  const Bus({super.key});

  @override
  State<Bus> createState() => _BusState();
}

class _BusState extends State<Bus> {
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
          Image.asset('assets/bus.png', height: 250,), 
          Container(
          padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(width: 5, color: Colors.teal),
            ),
            child: Text('Click for more Bus Details'.tr(), style:TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 78, 59, 3), fontFamily: 'Kanit'),)),
        
          ],
        ),
      );
  }
}