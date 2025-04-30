import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final String receiverEmail;
  final Timestamp timeStamp;
  Message({
    required this.receiverEmail,
    required this.message,
    required this.receiverId,
    required this.senderEmail,
    required this.senderId,
    required this.timeStamp,
  });

  Map<String ,dynamic> toMap(){
     return{
      'senderId': senderId,
      'receiverId': receiverId,
      'senderEmail':senderEmail,
      'receiverEmail': receiverEmail,     
      'message':message,
      'timestamp':timeStamp,
     };
  }
}