import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auth_ui/screens/Posts.dart';
import 'package:flutter/widgets.dart';

// class Todo {
//   final String newsImage,newsTitle,description,author,time,data;
//
//   Todo(this.newsImage, this.newsTitle, this.description, this.author, this.time,
//       this.data);
// }

class home_nav extends StatefulWidget {
   // newsImage,newsTitle,description,author,time,data;
  const home_nav({super.key});


  @override
  State<home_nav> createState() => _home_nav();


}

class _home_nav extends State<home_nav> {



  List<Posts> postList = [];
  List<Posts> tempList = [];


  DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Posts");

  void initState() {
    super.initState();
    fetchData();
  }



  Future<void> fetchData() async {
    try {
      // DatabaseReference postRef = FirebaseDatabase.instance.reference().child("Posts");

      // Retrieve the DatabaseEvent
      DatabaseEvent event = await postRef.once();

      // Access the DataSnapshot from the DatabaseEvent
      DataSnapshot snapshot = event.snapshot;

      // Check if the snapshot value is not null
      if (snapshot.value != null) {
        // Convert the snapshot value to the correct type
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          List<Posts> tempList = [];

          // Iterate over the data
          data.forEach((key, value) {
            print('Key: $key, Value: $value');

            // Check if value is already a Map<String, dynamic>
            if (value is! Map<String, dynamic>) {
              // Convert value to Map<String, dynamic> if it's not already
              if (value is Map<Object?, Object?>) {
                value = value.cast<String, dynamic>(); // Convert to the correct type
              } else {
                print('Skipping value for key $key. Invalid value type: ${value.runtimeType}');
                return; // Skip processing this value
              }
            }

            // Process the data and add it to the temporary list
            Posts post = Posts(
              value['image'],
              value['title'],
              value['description'],
              value['publisher'],
              value['date'],
              value['time'],
            );
            tempList.add(post);
          });

          // Print the number of posts fetched for debugging
          print('Number of posts fetched: ${tempList.length}');

          // Update the state with the temporary list
          setState(() {
            postList = tempList;
          });
        }


        else {
          print('Data is null');
        }
      } else {
        print('Snapshot value is null');
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafc),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0 ,vertical: 20),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 120.0),
            //   child: Text("Top News", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            // ),
            Expanded(
                child: FirebaseAnimatedList(
                  query: postRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    if (snapshot.value == null) {
                    // Show loader while data is loading
                    return Center(child: CircularProgressIndicator());
                    } else {
                      return CupertinoPageScaffold(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(

                              padding: const EdgeInsets.all(8.0),
                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(

                                    children: [
                                      Padding(

                                        padding: const EdgeInsets.all(5.0),
                                        child: Text((snapshot.value as Map<dynamic,
                                            dynamic>)['title'] ??
                                            'Title not Found',
                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                                      ),
                                      Spacer(), // use Spacer
                                      IconButton(
                                        onPressed: () {

                                          if (snapshot.value is Map<dynamic, dynamic>) {
                                            final Map<dynamic, dynamic>? dataMap = snapshot.value as Map<dynamic, dynamic>?; // Change the type to nullable
                                            if (dataMap != null && dataMap.containsKey('image') && dataMap.containsKey('title') && dataMap.containsKey('description') && dataMap.containsKey('publisher') && dataMap.containsKey('date') && dataMap.containsKey('time')) {
                                              Navigator.push(context,CupertinoPageRoute(builder: (context) => SecondRoute(data: dataMap ),
                                              ),
                                              );
                                            };
                                        }
                                        }, icon: Icon(
                                        Icons.arrow_right,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                      ),
                                    ],

                                  ),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(

                                        fit: BoxFit.cover,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 1,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * .25,
                                        placeholder: 'assets/icons/ljnews.png',
                                        image: (snapshot.value as Map<
                                            dynamic,
                                            dynamic>)['image'],

                                    ),
                                  ),
                                  SizedBox(height: 10,),


                                    SizedBox(
                                      height: 65,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text((snapshot.value as Map<dynamic,
                                            dynamic>)['description'] ??
                                            'Description not available',
                                          style: TextStyle(fontSize: 14,),

                                        ),
                                      ),
                                    ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text("Publisher: " +
                                        (snapshot.value as Map<dynamic,
                                            dynamic>)['publisher'] ??
                                        'Description not available',
                                      style: TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text((snapshot.value as Map<dynamic,
                                        dynamic>)['time'] ??
                                        'Description not available',
                                      style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text((snapshot.value as Map<dynamic,
                                        dynamic>)['date'] ??
                                        'Description not available',
                                      style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.bold),),
                                  )


                                ],

                              ),
                            ),
                          ),
                        ),
                      );
                    }
                },
                ),
            )
          ],
        ),
      ),
    );
  }

}
class SecondRoute extends StatelessWidget {

  final Map<dynamic, dynamic> data;

  const SecondRoute({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      backgroundColor: Color(0xfff9fafc),

                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 50),

                      child: CupertinoPageScaffold(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(

                              padding: const EdgeInsets.all(8.0),
                              child: Column(



                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),

                                    child: Text( '${data['title']}',style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        color: Colors.black),),
                                  ),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(

                                      fit: BoxFit.cover,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 1,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * .25,
                                      placeholder: 'assets/icons/ljnews.png',
                                      image: '${data['image']}',

                                    ),
                                  ),
                                  SizedBox(height: 10,),


                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 451,
                                          child: SingleChildScrollView (
                                            child: Text('${data['description']}',
                                              style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.none,
                                                  color: Colors.black),
                                              textAlign: TextAlign.justify,
                                            ),

                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,vertical: 5),
                                    child: Text("Publisher: "+'${data['publisher']}',
                                      style: TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          color: Colors.black),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(

                                      children: [
                                        Text('${data['date']}',
                                          style: TextStyle(fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none,
                                              color: Colors.black),),
                                          Spacer(),
                                          Text('${data['time']}',
                                            style: TextStyle(fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none,
                                              color: Colors.black,
                                            ),),
                                      ],
                                    ),


                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8.0),
                                  //   child: Text('${data['time']}',
                                  //     style: TextStyle(fontSize: 14,
                                  //         fontWeight: FontWeight.bold,
                                  //         decoration: TextDecoration.none,
                                  //         color: Colors.black,
                                  //          ),),
                                  // )


                                ],

                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
                  }
                }





// class SecondRoute extends StatelessWidget {
//   final Map<dynamic, dynamic> data;
//
//   const SecondRoute({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return CupertinoPageScaffold(
//       backgroundColor: Color(0xfff9fafc),
//       navigationBar: const CupertinoNavigationBar(
//         middle: Text('Detail Description'),
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: FadeInImage.assetNetwork(
//
//                   fit: BoxFit.cover,
//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width * 1 ,
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height *.35,
//                   placeholder: 'assets/icons/ljnews.png',
//                   image: '${data['image']}',
//
//                 ),
//               ),
//               SizedBox(height: 10,),
//
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Text('${data['title']}',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.black),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Text('${data['description']}',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.black),),
//               ),
//               // Text('Image: ${data['image']}'),
//               // Text('Title: ${data['title']}'),
//               // Display more data fields as needed
//               CupertinoButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Go back!'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }









