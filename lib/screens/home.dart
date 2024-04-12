import 'package:auth_ui/screens/auth.dart';
import 'package:auth_ui/screens/bottomNavScreens/events.dart';
import 'package:auth_ui/screens/bottomNavScreens/headlines.dart';
import 'package:auth_ui/screens/bottomNavScreens/home_nav.dart';
import 'package:auth_ui/screens/bottomNavScreens/lost_found.dart';
import 'package:auth_ui/screens/bottomNavScreens/add_post.dart';
import 'package:auth_ui/screens/lost_found/lost.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottomNavScreens/add_post.dart';
import 'package:auth_ui/screens/Drawer/userprofile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _firebase = FirebaseAuth.instance;
  var _isSgignoutLoading = false;

  String? _displayNameGoogle = '';

  Future<void> _signOut() async {
    try {
      setState(() {
        _isSgignoutLoading = true;
      });

      await _firebase.signOut();

      //also sign out the user if is sign in with google

      if (_firebase.currentUser == null) {
        await _googleSignIn.signOut();
      }
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    } catch (error) {
      setState(() {
        _isSgignoutLoading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _gitRepo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    //for setting the display name of google if the firebase auth user is null
    if (_firebase.currentUser == null) {
      getGoogleUserInfo();
    }
  }

  Future<void> getGoogleUserInfo() async {
    //.silently() will signIn the previously authenticated google user without the user interaction
    await _googleSignIn.signInSilently();
    setState(() {
      _displayNameGoogle = _googleSignIn.currentUser!.displayName;
    });
  }


  // for get current index of bottom navigation bar
  int _currentIndex = 0;
  List<Widget> widgetList = const[
    home_nav(),
    headlines(),
    add_post(),
    events(),
    lost_found(),
  ];


  @override
  Widget build(BuildContext context) {

  return Scaffold(

      body: Center(
        child: widgetList[_currentIndex],
      ),
      appBar: AppBar(

        elevation: 10,
        titleSpacing: -5,

        title: const Text(
            'Lj News',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          // Icon(Icons.more_vert),

          // const Text(
          //   'Log out',
          //   style:
          //       TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey),
          // ),
          // IconButton(
          //   onPressed: _signOut,
          //   icon: const Icon(Icons.logout),
          //   color: Theme.of(context).primaryColor,
          // ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white54,
          child: ListView(
            children: [
              DrawerHeader(child:
                Image.asset('assets/icons/ljnews.png')
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("User Profile",style: TextStyle(fontSize: 15),),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => userprofile())
                  );
                },
              ),
             ListTile(
                leading: Icon(Icons.account_tree),
                title: Text("Git Repo",style: TextStyle(fontSize: 15),),
                onTap: (){
                  _gitRepo("https://flutter.dev");
                },
              ),

              ListTile(
                leading: Icon(Icons.verified),
                title: Text("Version 1.0",style: TextStyle(fontSize: 15),),

              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout",style: TextStyle(fontSize: 15),),
                onTap: (){
                  _signOut();
                },
              ),

            ],
          ),
        ),
      ),




      // body: _isSgignoutLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Container(
      //         decoration: const BoxDecoration(
      //           image: DecorationImage(
      //             opacity: 0.5,
      //             image: AssetImage('assets/images/bg.png'),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //         child: Center(
      //           child: _firebase.currentUser == null
      //               ? Text(
      //                   'Hello $_displayNameGoogle \n Welcome Here!',
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 20,
      //                       wordSpacing: 3),
      //                 )
      //               : Text(
      //                   'Hello ${_firebase.currentUser!.displayName} \n Welcome Here!',
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 20,
      //                       wordSpacing: 3),
      //                 ),
      //         ),
      //       ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        // showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (int newIndex){
        setState(() {
          _currentIndex = newIndex;
        });
        }, items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',

          ),
        BottomNavigationBarItem(
            icon: Icon(Icons.view_headline_outlined),
            label: 'Headlines'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late_outlined),
            label: 'Lost Found'
        ),

      ],


      ),

    );
  }


}

