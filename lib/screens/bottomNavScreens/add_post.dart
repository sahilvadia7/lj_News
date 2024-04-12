import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'home_nav.dart';
// import 'package:auth_ui/screens/home.dart';
import 'package:auth_ui/screens/home.dart';


class add_post extends StatefulWidget {
  const add_post({super.key});

  @override
  _add_postState createState() => _add_postState();
}

class _add_postState extends State<add_post> {
  File? sampleImage;
  late String img_description;
  late String img_uploadBy;
  late String url,title;
  final formKey = new GlobalKey<FormState>();
  static const List<String> list = <String>['Post','Headlines', 'Events', 'Lost', 'Found'];
  // Define a variable to track upload status
  bool isUploading = false;

  String DropdownValue = list.first;



  Future getImage() async{
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage =  File(image!.path);
    });
  }

  void uploadStatusImage() async{
    setState(() {
      isUploading = true; // Start uploading, set isUploading to true
    });

    if(validateAndSave()){
      final Reference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timekey = new DateTime.now();

      final UploadTask uploadTask = postImageRef.child(timekey.toString() + ".jpg").putFile(sampleImage!);
      var imageUrl = await(await uploadTask).ref.getDownloadURL();
      url =imageUrl.toString();
      print("Image Url = "+url);

      gotoHome();
      saveToDatabase(url);

      setState(() {
        isUploading = false; // Upload finished, set isUploading back to false
      });

    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference Dref= FirebaseDatabase.instance.ref();
    var data={
      "title": title,
      "image": url,
      "description": img_description,
      "publisher":img_uploadBy,
      "date": date,
      "time": time,
      "postType":DropdownValue,

    };

    Dref.child("Posts").push().set(data);


  }

  void gotoHome(){
    Navigator.push(context,
    MaterialPageRoute(builder: (context)
    {
      return new HomeScreen();
    }
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset : false,

      appBar:  AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:
              Expanded(
                child: Row(
                  children: [
                    Text("A",
                      style: TextStyle(fontSize: 25,color: Colors.blueAccent),),
                    Text("dd Post",style: TextStyle(fontSize: 18),)
                  ],
                ),

              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Center(
        child: sampleImage == null? Text("Select an image"): enableUpload(),
      ),


      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.file(
                sampleImage!,
                height: 300.0,
                width: 300.0,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Title is required' : null;
                },
                onSaved: (value) {
                  title = value!;
                },
                enabled: !isUploading, // Disable field when uploading
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Bold Description is required' : null;
                },
                onSaved: (value) {
                  img_description = value!;
                },
                enabled: !isUploading, // Disable field when uploading
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Author',
                  contentPadding: EdgeInsets.all(10.0),
                  isDense: true,
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Author-Name is required' : null;
                },
                onSaved: (value) {
                  img_uploadBy = value!;
                },
                enabled: !isUploading, // Disable field when uploading
              ),
              DropdownButton<String>(
                value: DropdownValue,
                isExpanded: true,
                icon: Icon(Icons.menu),
                iconSize: 25.0,
                elevation: 16,
                padding: EdgeInsets.all(8.0),
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: !isUploading ?(String? value) {
                  setState(() {
                    DropdownValue = value!;
                  });
                } : null, // Disable dropdown when uploading

                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed:(){
                  uploadStatusImage();
                },
                child: isUploading? CircularProgressIndicator(): Text("Add a New Post!"),
              ),
              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }


  bool validateAndSave() {
    final form = formKey.currentState;

    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }


  void dropdownCallBack(String? value) {
    if(value is String){
      setState(() {

      });
    }
  }
}
