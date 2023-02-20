import 'package:cocoicons/cocoicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revamph_assignment/pages/sign_up_page.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var  _emailText =    '';
  var  _passwordText = '';



  final _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 246),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "assets/logo.jpg",
                      scale: 2,
                    ),
                    const Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      "Enter your details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: .9),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _loginFormKey,
                      child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: _inputDecoration(
                              label: "Enter your Email",
                              iconData: CocoIconLine.Message_4),
                               onSaved: (newValue) => _emailText = newValue ?? '',
                          validator: (value)=> 
                           !GetUtils.isEmail(value ?? "") ? 
                            "Enter a Valid email" : null
                           
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: _inputDecoration(
                              label: "Enter your Password",
                              iconData: CocoIconLine.Lock),
                          onSaved: (newValue) => _passwordText = newValue ?? '',
                          validator: (value)=> 
                           value!.isEmpty ? 
                            "Enter Your password" : null
                        ),
                      ],
                    )),
                    const SizedBox(height: 10),
                    MaterialButton(
                      color: Colors.black,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onPressed: () {
                        if(_loginFormKey.currentState!.validate()){
                          _loginFormKey.currentState!.save();
                          FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailText.trim(), password: _passwordText.trim());
                        }
                      },
                    ),
                    const Spacer(),
                    const Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "didn't have a account, ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MySignUpPage()));
                          },
                          child: Text(
                            "Sign up",
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
