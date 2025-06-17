import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../theme/theme_provider.dart';
import '../widgets/custom_elevated_button.dart';
import '../features/login/presentation/view/login_view.dart';

class ProfileView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;

  const ProfileView({super.key, required this.firstName, required this.lastName, required this.phone});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthServices _authServices = AuthServices();
  final picker = ImagePicker();
  String? imagePath;
  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Load profile image path from local storage
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('profileImage');
    });
  }

  // Pick and save image locally
// Pick and save image locally
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    Directory appDir = await getApplicationDocumentsDirectory();

    // Generate a unique filename (to force reload)
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String savedPath = '${appDir.path}/profile_$timestamp.jpg';

    await imageFile.copy(savedPath);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', savedPath);

    setState(() {
      imagePath = savedPath;
    });

    Fluttertoast.showToast(msg: "Profile Picture Updated!", backgroundColor: Colors.green);
  }


  // Delete image locally
  Future<void> _deleteImage() async {
    if (imagePath == null) return;
    File imageFile = File(imagePath!);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImage');

    setState(() {
      imagePath = null;
    });

    Fluttertoast.showToast(msg: "Profile Picture Deleted", backgroundColor: Colors.red);
  }




  // Logout Function
  void _logout(BuildContext context) async {
    await _authServices.signOut();
    Fluttertoast.showToast(msg: "Logged out successfully!", backgroundColor: Colors.black38);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading:  IconButton(
        //   icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),color: Colors.green,
        //   onPressed: () {
        //     themeProvider.toggleTheme();
        //   },
        // ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Profile", style: TextStyle(color: Colors.black, fontSize: isTablet ? 24 : 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () => _logout(context), icon: Icon(Icons.login_outlined, color: Colors.green))
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 30 : 20),
              Text("Profile picture", style: TextStyle(fontSize: isTablet ? 20 : 18, fontWeight: FontWeight.bold)),
              SizedBox(height: isTablet ? 30 : 20),

              // Profile Picture + Buttons
              Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 50 : 40,
                    backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : AssetImage('assets/images/person.png') as ImageProvider,
                  ),
                  const SizedBox(width: 15),

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            title: "Change Picture",
                            backColor: Colors.green,
                            onpressed: _pickImage,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (imagePath != null)
                          Expanded(
                            child: CustomElevatedButton(
                              title: "Delete Picture",
                              backColor: const Color(0xffF6F7F9),
                              onpressed: _deleteImage,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 40 : 30),
              _buildSectionTitle("Username:", isTablet),
              const SizedBox(height: 10),
              Text('${widget.firstName} ${widget.lastName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              _buildSectionTitle("Phone Number:", isTablet),
              const SizedBox(height: 10),
              Text('${widget.phone}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    Image.asset("assets/images/Vodafone Cash.png", height: isTablet ? 60 : 50),
                    Image.asset("assets/images/instapay.png", height: isTablet ? 60 : 50),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "We adhere entirely to the data security standards of your payment",
                        style: TextStyle(fontSize: isTablet ? 16 : 14, fontWeight: FontWeight.bold),
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

  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Text(title, style: TextStyle(fontSize: isTablet ? 18 : 16, fontWeight: FontWeight.bold));
  }
