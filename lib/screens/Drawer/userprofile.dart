import 'package:flutter/material.dart';
import 'package:profile/profile.dart';

class userprofile extends StatefulWidget {
  const userprofile({super.key});

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Profile(
          imageUrl: "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
          name: "Shamim Miah",
          website: "shamimmiah.com",
          designation: "Project Manager | Flutter & Blockchain Developer",
          email: "cse.shamimosmanpailot@gmail.com",
          phone_number: "01757736053",
        ),
      ),
      appBar: AppBar(
        leading: BackButton(),
      ),


    );
  }
}
