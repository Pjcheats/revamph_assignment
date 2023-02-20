import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoicons/cocoicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revamph_assignment/models/user_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var user = FirebaseAuth.instance.currentUser!;
  var userData = UserData();
  String? profilePicURL = '';

  void getData()async{
    
    var fetchedData = await FirebaseFirestore.instance.collection('User-Data').doc(user.uid).get();
    userData.password = fetchedData.data()?["userType"]?? "no data ";
    userData.collegeName = fetchedData.data()?["collegeName"]?? "no data ";
    userData.userName = fetchedData.data()?["userName"]?? "no data ";
    userData.mobileNumber = fetchedData.data()?["mobileNumber"]?? "no data ";
    userData.year = fetchedData.data()?["year"]?? "no data ";
    userData.emailAddress = fetchedData.data()?["emailAddress"]?? "no data ";
    profilePicURL = fetchedData.data()?["profilePicURL"];


    setState(() {
      
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 246),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "You are logged in with :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: .9),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 80,
                foregroundImage: profilePicURL == null ? null :
                NetworkImage(profilePicURL!),
                child: Icon(
                  CocoIconLine.User,
                  color: Colors.grey,
                  size: 60,
                ),
              ),
              const Divider(
                height: 40,
                thickness: 2,
              ),
              _userInfoTab(
                  label: 'Category',
                  value: userData.password),
              _userInfoTab(label: 'Name', value: userData.userName),
              _userInfoTab(label: 'Email', value: userData.emailAddress),
              _userInfoTab(label: 'Number', value: userData.mobileNumber),
              _userInfoTab(label: 'College', value: userData.collegeName),
              _userInfoTab(label: 'Pass-out year', value: userData.year),
              
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey, width: 4),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding: EdgeInsets.all(50),
                      child: Icon(
                        CocoIconLine.Menu_1,
                        color: Colors.grey,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Your Resume",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              height: .9),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          color: Colors.amber.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                CocoIconLine.Message_5,
                                color: Colors.white,
                              ),
                              Text(
                                "Open",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Divider(
                height: 40,
                thickness: 2,
              ),
              MaterialButton(
                color: Colors.black,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  "Log out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoTab({String? label, String? value}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? '',
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? '',
            style: TextStyle(
                color: Colors.amber.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      );
}
