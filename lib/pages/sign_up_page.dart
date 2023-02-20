import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocoicons/cocoicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revamph_assignment/controllers/user_data_controller.dart';
import 'package:revamph_assignment/models/user_model.dart';
import 'package:revamph_assignment/pages/login_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final _signUpFormKey1 = GlobalKey<FormState>();
  final _signUpFormKey2 = GlobalKey<FormState>();

  final UserDataController _userDataController = UserDataController();
  final _pageViewController = PageController();
  var _currentPage = 0;
  File? profileImg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 246),
      body: SizedBox(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Resgister Yourself As :",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Flexible(
                              child: Obx(
                                () => DropdownButton<UserType>(
                                  value: _userDataController
                                      .userData.userType.value,
                                  onChanged: (value) {
                                    _userDataController.userData.userType
                                        .value = value ?? UserType.student;
                                  },
                                  items:
                                      UserType.values.map((UserType userType) {
                                    return DropdownMenuItem<UserType>(
                                      value: userType,
                                      child: Text(
                                        userType.toString().split('.')[1],
                                        style: TextStyle(
                                          color: Colors.amber.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Text(
                          "Enter your details",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: .9),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                             CircleAvatar(
                              radius: 80,
                              foregroundImage:profileImg == null ? null : FileImage(profileImg!),
                              child: const Icon(
                                CocoIconLine.User,
                                color: Colors.grey,
                                size: 60,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "profile picture",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(
                                          CocoIconLine.Gallery,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Choose",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      // selecting img
                                      final ImagePicker picker = ImagePicker();
                                      var pickedImage = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );

                                      if (pickedImage == null) return;

                                      CroppedFile? croppedFile =
                                          await ImageCropper().cropImage(
                                        sourcePath: pickedImage.path,
                                        aspectRatio: const CropAspectRatio(
                                            ratioX: 1, ratioY: 1),
                                      );

                                      if (croppedFile == null) return;

                                      profileImg = File(croppedFile.path);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          height: 40,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: PageView(controller: _pageViewController, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),

                        //First form

                        child: Form(
                          key: _signUpFormKey1,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              TextFormField(
                                  initialValue:
                                      _userDataController.userData.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: _inputDecoration(
                                      label: "Enter your Full Name",
                                      iconData: CocoIconLine.User),
                                  onSaved: (newValue) {
                                    _userDataController.userData.userName =
                                        newValue ?? '';
                                  },
                                  validator: (value) =>
                                      value!.toString().trim().isEmpty
                                          ? "Enter your name"
                                          : null),
                              const SizedBox(height: 10),
                              TextFormField(
                                  initialValue:
                                      _userDataController.userData.emailAddress,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: _inputDecoration(
                                      label: "Enter your Email",
                                      iconData: CocoIconLine.Message_4),
                                  onSaved: (newValue) {
                                    _userDataController.userData.emailAddress =
                                        newValue ?? '';
                                  },
                                  validator: (value) =>
                                      !GetUtils.isEmail(value ?? "")
                                          ? "Enter a Valid email"
                                          : null),
                              const SizedBox(height: 10),
                              TextFormField(
                                  initialValue:
                                      _userDataController.userData.password,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: _inputDecoration(
                                      label: "Enter your Password",
                                      iconData: CocoIconLine.Lock),
                                  onSaved: (newValue) {
                                    _userDataController.userData.password =
                                        newValue ?? '';
                                  },
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your password"
                                      : null),
                              const SizedBox(height: 10),
                              TextFormField(
                                  initialValue:
                                      _userDataController.userData.mobileNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: _inputDecoration(
                                      label: "Enter your Mobile Number",
                                      iconData: CocoIconLine.Phone),
                                  onSaved: (newValue) {
                                    _userDataController.userData.mobileNumber =
                                        newValue ?? '';
                                  },
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your Mobile Number"
                                      : null),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Form(
                          key: _signUpFormKey2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                  initialValue:
                                      _userDataController.userData.collegeName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  decoration: _inputDecoration(
                                      label: "Enter your College Name",
                                      iconData: CocoIconLine.Home),
                                  onSaved: (newValue) {
                                    _userDataController.userData.collegeName =
                                        newValue ?? '';
                                  },
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your college name"
                                      : null),
                              const SizedBox(height: 10),
                              Obx(
                                () => _userDataController
                                            .userData.userType.value ==
                                        UserType.faculty
                                    ? const SizedBox(
                                        height: 65,
                                      )
                                    : TextFormField(
                                        initialValue:
                                            _userDataController.userData.year,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        decoration: _inputDecoration(
                                            label: _userDataController.userData
                                                        .userType.value ==
                                                    UserType.student
                                                ? "Enter your Addmission Year"
                                                : "Enter your Pass-out Year ",
                                            iconData: CocoIconLine.Calendar),
                                        onSaved: (newValue) {
                                          _userDataController.userData.year =
                                              newValue ?? '';
                                        },
                                        validator: (value) => value!.isEmpty
                                            ? "Enter Year"
                                            : null),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        border: Border.all(
                                            color: Colors.grey, width: 4),
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Icon(
                                                CocoIconLine.Folder,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Choose",
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
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaterialButton(
                          color: Colors.black,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          onPressed: () async {
                            if (_currentPage == 0) {
                              if (_signUpFormKey1.currentState!.validate()) {
                                _signUpFormKey1.currentState!.save();
                                _pageViewController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                                _currentPage++;
                                return;
                              }
                            }
                            if (_signUpFormKey2.currentState!.validate()) {
                              _signUpFormKey2.currentState!.save();
                              showDialog(context: context, builder: (context) => const SizedBox(height: 100,width: 100, child:  CircularProgressIndicator()));
                              var result = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _userDataController
                                          .userData.emailAddress
                                          .trim(),
                                      password: _userDataController
                                          .userData.password
                                          .trim());
                              File file = File(profileImg!.path);
                              final ref = FirebaseStorage.instance.ref().child("Profile/${profileImg!.path}");
                              final uploadTask = ref.putFile(file);
                              print(9999999999999999); 
                              final snapShot = await uploadTask.whenComplete(() {});
                              print(88888888888888888); 
                              final profileURL = await snapShot.ref.getDownloadURL();

                              
                              await FirebaseFirestore.instance
                                  .collection("User-Data")
                                  .doc(result.user!.uid)
                                  .set({
                                "profilePicURL":
                                    profileURL,
                                
                                "collegeName":
                                    _userDataController.userData.collegeName,
                                "emailAddress":
                                    _userDataController.userData.emailAddress,
                                "mobileNumber":
                                    _userDataController.userData.mobileNumber,
                                "userName":
                                    _userDataController.userData.userName,
                                "userType": _userDataController
                                    .userData.userType.value
                                    .toString()
                                    .split('.')[1],
                                "year": _userDataController.userData.year,
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        const Divider(
                          height: 40,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have a account, ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyLoginPage()));
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.amber.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? label, IconData? iconData}) =>
      InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: label,
        errorStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 18),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        prefixIcon: Icon(
          iconData,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey.shade200)),
      );
}
