import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transporttracking/Controller/controller.dart';
import 'package:transporttracking/View/chat_bubble.dart';
import 'package:transporttracking/View/text_field.dart';

class Messages extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;
  const Messages({super.key , required this.recieverUserEmail, required this.recieverUserID});

  @override
  State<Messages> createState() => MessagesState();
}

class MessagesState extends State<Messages> {
  final TextEditingController _messageController =TextEditingController();
   static final authApp = Firebase.app('AuthApp');  
    static final FirebaseAuth _firebaseAuth = FirebaseAuth.instanceFor(app: authApp);
  void sendMessage() async {
     if(_messageController.text.isNotEmpty){
      await Controller.sendMessage(_messageController.text,widget.recieverUserID);
      _messageController.clear();
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
      Text(widget.recieverUserEmail, style: TextStyle(fontFamily: 'Kanit'),),
      backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.tealAccent,
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            _buildMessagesInput(),
            const SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
  Widget _buildMessagesList(){
    return StreamBuilder(stream: Controller.getMessages(_firebaseAuth.currentUser!.uid,widget.recieverUserID), builder:(context,snapshot){
      if (snapshot.hasError){
          return Text('Error ${snapshot.error}');
      }
      if (snapshot.connectionState==ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: snapshot.data!.docs.map((document)=>_buildMessageItem(document)).toList(),
      );
    });
  }
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
     var isSender = data['senderEmail'] == _firebaseAuth.currentUser!.email;
      var displayEmailSender = data['senderEmail'];
    var alignement = (isSender)? Alignment.centerRight: Alignment.centerLeft;
    return Container(
      alignment: alignement,
      child: Column(
        crossAxisAlignment: (isSender)? CrossAxisAlignment.end : CrossAxisAlignment.start ,
        children: [
          Text(displayEmailSender, style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold , color: const Color.fromRGBO(3, 24, 42, 1)),),
          const SizedBox(height: 5,),
          ChatBubble(message: data['message']),
        ],
      ),
    );
  }
  Widget _buildMessagesInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
           Expanded(child: MyTextField(controller: _messageController, hintText: 'Enter Message', obscureText: false),
           ),
           IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward,size: 40,))
        ],
      ),
    );
  } 
}