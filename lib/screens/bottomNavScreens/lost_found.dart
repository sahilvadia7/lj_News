import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class lost_found extends StatefulWidget {
  const lost_found({super.key});

  @override
  State<lost_found> createState() => _lostState();
}

class _lostState extends State<lost_found> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
      child:
        Text("lost & found"),
      ),
    );
  }
}
