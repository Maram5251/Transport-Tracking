import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transporttracking/Model/account.dart';

class ProfilPage extends StatefulWidget {
  final Account? account;
  const ProfilPage({super.key, required this.account});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Uint8List? _image;

  // Moved here from the widget class
  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No images selected');
    return null;
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Page'.tr(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        backgroundColor: Colors.tealAccent,
        leading: Icon(Icons.face, color: Colors.black),
      ),
      backgroundColor: Colors.teal,
      body: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 62, 56),
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _image != null
                    ? CircleAvatar(radius: 64, backgroundImage: MemoryImage(_image!),backgroundColor: Colors.black,)
                    : CircleAvatar(radius: 64, backgroundColor: Colors.black, child: Icon(Icons.face, size: 64, color: Colors.white),),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo, color: Colors.amber),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(child: Text('First Name: ${widget.account?.userModel.firstName}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
                SizedBox(width: 10,),
                Flexible(child: Text('Last Name: ${widget.account?.userModel.lastName}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
              ],
            ),
            SizedBox(height: 20),
           Flexible(child: Text('Email: ${widget.account?.email}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
            SizedBox(height: 20),
           Flexible(child: Text('Role: ${widget.account?.userModel.role}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
            SizedBox(height: 20),
           Flexible(child: Text('Country : ${widget.account?.userModel.country}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
            SizedBox(height: 20),
           Flexible(child: Text('Age: ${widget.account?.userModel.age}', style: TextStyle(fontFamily: 'Kanit', color: Colors.white, fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}
