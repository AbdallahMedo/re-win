import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../../services/auth_services.dart';
import '../../../../theme/theme_provider.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../login/presentation/view/login_view.dart';
import '../widgets/reset_data_dialog.dart';

class ProfileView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String? uid;

  const ProfileView({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.uid,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthServices _authServices = AuthServices();
  final picker = ImagePicker();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  String? imagePath;
  bool _isUpdating = false;

  String get userKey => widget.uid ?? "anonymous";

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profileImage_$userKey');

    if (path != null && File(path).existsSync()) {
      setState(() {
        imagePath = path;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUpdating = true);

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${appDir.path}/$fileName';

      final imageFile = await File(pickedFile.path).copy(newPath);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage_$userKey', imageFile.path);

      setState(() {
        imagePath = imageFile.path;
        _isUpdating = false;
      });

      Fluttertoast.showToast(
        msg: "Profile Picture Updated!",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      setState(() => _isUpdating = false);
      Fluttertoast.showToast(msg: "Error updating picture", backgroundColor: Colors.red);
    }
  }

  Future<void> _deleteImage() async {
    setState(() => _isUpdating = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPath = prefs.getString('profileImage_$userKey');

      if (storedPath != null) {
        final file = File(storedPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      await prefs.remove('profileImage_$userKey');

      setState(() {
        imagePath = null;
        _isUpdating = false;
      });

      Fluttertoast.showToast(msg: "Profile Picture Deleted", backgroundColor: Colors.red);
    } catch (e) {
      setState(() => _isUpdating = false);
      Fluttertoast.showToast(msg: "Error deleting picture", backgroundColor: Colors.red);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final loginCubit = context.read<LoginCubit>();
      await loginCubit.logout();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error logging out", backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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
              fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.uid != null)
            IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, color: Colors.red),
            )
        ],
        centerTitle: true,
      ),
      body: _isUpdating
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isTablet ? 30 : 20),
              Text(
                "Profile picture",
                style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: isTablet ? 30 : 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 40 : 30,
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!))
                        : const AssetImage('assets/images/person.png')
                    as ImageProvider,
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
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Phone Number:", isTablet),
              const SizedBox(height: 10),
              Text(
                widget.phone,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: isTablet ? 50 : 40),
              if (widget.uid != null) ...[
                _buildSectionTitle("Choose payment method", isTablet),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => ResetDataDialog.show(
                    context: context,
                    userId: widget.uid!,
                  ),
                  child: Container(
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
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10)),
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
              ] else ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Sign in to access payment methods",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
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
