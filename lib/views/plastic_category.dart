import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/navigation.dart';

class PlasticCategory extends StatefulWidget {
  const PlasticCategory({super.key});

  @override
  _PlasticCategoryState createState() => _PlasticCategoryState();
}

class _PlasticCategoryState extends State<PlasticCategory> with SingleTickerProviderStateMixin {
  ValueNotifier<double> scrollPosition = ValueNotifier<double>(0.6);
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xffF7F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: EdgeInsets.all(isTablet ? 15.0 : 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffC9E6B0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.green, size: 30),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){return RecycleApp();}));
                    },
                  ),
                ),
              ),
            ),

            // Animated Image Container with Jump Effect
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: ValueListenableBuilder<double>(
                valueListenable: scrollPosition,
                builder: (context, value, child) {
                  double imageSize = screenHeight * (0.35 - (value - 0.6) * 0.2).clamp(0.15, 0.35);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 20),
                    padding: EdgeInsets.all(isTablet ? 15 : 10),
                    height: imageSize,
                    child: Image.asset(
                      "assets/images/Plastic - PNG.png",
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Bottom Sheet (DraggableScrollableSheet)
            Expanded(
              child: NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  scrollPosition.value = notification.extent;
                  return true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.4,
                  maxChildSize: 1,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.all(isTablet ? 25 : 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag Handle
                            Center(
                              child: Container(
                                width: screenWidth * 0.2,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Title
                            Text(
                              "How to recycle a plastic?",
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Description
                            Text(
                              "1- Check Recycling Codes – Plastics are labeled with numbers (1 to 7). Common recyclable plastics include:\n\n"
                                  "#1 (PET): Water bottles, soda bottles\n\n"
                                  "#2 (HDPE): Milk jugs, detergent bottles\n\n"
                                  "2- Rinse and Empty – Wash out any food or drink residue.\n\n"
                                  "3- Remove Caps and Labels – Separate them if required by your local recycling center.\n\n"
                                  "4- Don’t Recycle Soft Plastics Curbside – Plastic bags, wraps, and bubble wrap can jam machines—take them to store drop-offs.\n\n"
                                  "5- Avoid Black Plastic – It’s often not detected by recyclingmachines.",
                              style: TextStyle(fontSize: isTablet ? 18 : 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
