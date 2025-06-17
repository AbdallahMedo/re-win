import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class GlassCategory extends StatefulWidget {
  const GlassCategory({super.key});

  @override
  _GlassCategoryState createState() => _GlassCategoryState();
}

class _GlassCategoryState extends State<GlassCategory> with SingleTickerProviderStateMixin {
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
                      "assets/images/Glass - PNG.png",
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
                              "How to recycle a glass?",
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Description
                            Text(
                              "1- Rinse the Glass – Clean out any food or liquid residue.\n\n"
                                  "2- Remove Lids and Caps – Metal lids can be recycled separately, but plastic ones often cannot.\n\n"
                                  "3- Sort by Color (if required) – Some centers prefer clear, green, and brown glass separated.\n\n"
                                  "4- Don’t Break the Glass – Broken glass can be dangerous and harder to recycle.\n\n"
                                  "5- Use Proper Recycling Bins – Or take glass to a designated recyclingcenter.",
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
