import 'package:flutter/material.dart';
import 'package:recycling_app/views/login_view.dart';

import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/navigation.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginView();
                    },
                  ),
                );
              },
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
                        const AssetImage("assets/images/person.png"),
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
                            onpressed: () {},
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomElevatedButton(
                            title: "Delete Picture",
                            backColor: const Color(0xffF6F7F9),
                            onpressed: () {},
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
              CustomTextField(hintText: "Username"),
              const SizedBox(height: 20),

              _buildSectionTitle("Mobile Number", isTablet),
              const SizedBox(height: 10),
              CustomTextField(hintText: "Mobile number"),
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
