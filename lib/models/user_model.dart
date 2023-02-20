import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum UserType { 
   student, 
   faculty,  
   alumni 
}
class UserData{
  Rx<UserType> userType = UserType.student.obs;
  String password = '';
  String emailAddress = '';
  String mobileNumber = '';
  String userName = '';
  String collegeName = '';
  String year = DateTime.now().year.toString();
  XFile? profilePicFile;
  File? resumneFile; 
}