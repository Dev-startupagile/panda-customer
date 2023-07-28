import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingSlider extends StatefulWidget {
  const OnboardingSlider({super.key});
  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  int activeIndex = 0;
  CarouselController controller = CarouselController();

  Widget getComponent(String title, String body) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Center(
                    child: Image.asset("assets/logo.png"),
                  ),
                  const SizedBox(
                    height: 140,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(body),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      getComponent("Onboarding Screen One",
          "Locate available mobile technicians, book appointments for immediate or future automotive repairs."),
      getComponent("Onboarding Screen Two",
          "Pay for service directly through a secured portal after work is completed."),
      getComponent("Onboarding Screen three",
          "Keep track of your automotive repairs for reference and maximize resale value.")
    ];
    Widget buildIndicator() {
      return AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: items.length,
      );
    }

    return Scaffold(
      body: Column(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            itemCount: items.length,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height - 150,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              viewportFraction: 0.9,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    items[itemIndex],
          ),
          const SizedBox(
            height: 32,
          ),
          buildIndicator(),
          buildButton()
        ],
      ),
    );
  }

  Widget buildButton({bool stretch = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          activeIndex == 2
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 17, 168, 143),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                  child: const Text('Get Stated'),
                )
              : ElevatedButton(
                  onPressed: () => controller.nextPage(),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 17, 168, 143),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                  child: const Text('Next'),
                ),
        ],
      ),
    );
  }

  void next() => controller.nextPage();
}
