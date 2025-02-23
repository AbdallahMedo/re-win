import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycling_app/views/login_view.dart';
import '../services/auth_services.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/navigation.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}
class _ProfileViewState extends State<ProfileView> {
  final AuthServices _authServices = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String firstName = "";
  String lastName = "";
  String phone = "";
  String imageUrl = "";
  File? _image;

  @override
  void initState() {
    super.initState();
    // _fetchUserData();
  }
  // Future<void> _fetchUserData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
  //     setState(() {
  //       firstName = userDoc['firstName'];
  //       lastName = userDoc['lastName'];
  //       phone = userDoc['phone'];
  //       imageUrl = userDoc['imageUrl'] ?? "";
  //     });
  //   }
  // }
  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() => _image = File(pickedFile.path));
  //     await _uploadImage();
  //   }
  // }
  // Future<void> _uploadImage() async {
  //   if (_image == null) return;
  //
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     Reference ref = _storage.ref().child('profile_images/${user!.uid}.jpg');
  //     await ref.putFile(_image!);
  //     String downloadUrl = await ref.getDownloadURL();
  //
  //     await _firestore.collection('users').doc(user.uid).update({'imageUrl': downloadUrl});
  //
  //     setState(() {
  //       imageUrl = downloadUrl;
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded!")));
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //   }
  // }
  // Future<void> _deleteImage() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     Reference ref = _storage.ref().child('profile_images/${user!.uid}.jpg');
  //     await ref.delete();
  //
  //     await _firestore.collection('users').doc(user.uid).update({'imageUrl': ""});
  //
  //     setState(() {
  //       imageUrl = "";
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Deleted!")));
  //   } catch (e) {
  //     print("Error deleting image: $e");
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
   // double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController _firstName=TextEditingController();
    TextEditingController _phoneNumber=TextEditingController();
    void _logout(BuildContext context) async {
      await _authServices.logout();

      Fluttertoast.showToast(
        msg: "Logged out successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
      );

      // Navigate back to login page and remove HomeView from stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
    bool isTablet = screenWidth > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed:()=>_logout(context),
              icon: Icon(Icons.login_outlined,color: Colors.green,)
          )
        ],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RecycleApp();
            }));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 30 : 20),
              Text(
                "Profile picture",
                style: TextStyle(
                    fontSize: isTablet ? 20 : 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: isTablet ? 30 : 20),

              // Profile Picture + Buttons in One Row
              Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 50 : 40,
                    backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl): AssetImage("assets/images/person.png"),
                  ),
                  const SizedBox(width: 15),

                  // Buttons (Change & Delete)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            title: "Change Picture",
                            backColor: Colors.green,
                            onpressed: (){},
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // if (imageUrl.isNotEmpty)
                        Expanded(
                          child: CustomElevatedButton(
                            title: "Delete Picture",
                            backColor: const Color(0xffF6F7F9),
                            onpressed:(){},
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 40 : 30),

              _buildSectionTitle("Username", isTablet),
              const SizedBox(height: 10),
              CustomTextField(hintText: "Username",controller: _firstName,),
              const SizedBox(height: 20),

              _buildSectionTitle("Phone Number", isTablet),
              const SizedBox(height: 10),
              CustomTextField(hintText: "Phone number",controller: _phoneNumber,),
              SizedBox(height: isTablet ? 50 : 40),

              _buildSectionTitle("Choose payment method", isTablet),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/Vodafone Cash.png",
                        height: isTablet ? 60 : 50),
                    Image.asset("assets/images/instapay.png",
                        height: isTablet ? 60 : 50),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Security Message
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "We adhere entirely to the data security standards of your payment",
                        style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Text(
      title,
      style:
          TextStyle(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold),
    );
  }
}
