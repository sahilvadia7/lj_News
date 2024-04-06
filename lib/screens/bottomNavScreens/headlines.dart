import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Posts.dart';



class headlines extends StatefulWidget {
  // String newsImage,newsTitle,description,author,time,data;
  const headlines({super.key});

  @override
  State<headlines> createState() => _headlines();
}

class _headlines extends State<headlines> {
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
                query: postRef.orderByChild('postType').equalTo('Headlines'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  if (snapshot.value == null) {
                    // Show loader while data is loading
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
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
                                child: Text((snapshot.value as Map<dynamic,
                                    dynamic>)['title'] ??
                                    'Title not Found',
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text((snapshot.value as Map<dynamic,
                                    dynamic>)['description'] ??
                                    'Description not available',
                                  style: TextStyle(fontSize: 14,),),
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