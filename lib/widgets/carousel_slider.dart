import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/route_constrant.dart';
import '../utils/theme.dart';

class SliderIntroduction extends StatefulWidget {
  const SliderIntroduction({super.key});

  @override
  State<SliderIntroduction> createState() => _SliderIntroductionState();
}

class _SliderIntroductionState extends State<SliderIntroduction> {
  final CarouselController _carouselController = CarouselController();
  int activeIndex = 0;

  final List<Map<String, String>> sliderData = [
    {
      'image':
          'https://lh3.googleusercontent.com/T9C1upN680cC_j89CqWiz0NhKWxacBEOjs3hFdcD4WL11k3oJS5swtS_m3Y3dcCyC5DPRVQxHG_9F1Q5Ge_fix9F_R4NjsI1M42knKvNJnbA-sNyKCK7-OJe69xSZLP5K0uJoewZ',
      'title': 'Welcome',
      'description': 'This is the first slide of our introduction.',
    },
    {
      'image':
          'https://assets-global.website-files.com/62dac784c266a307e14d76b4/62e11b66719db85baf734d86_622872651ac344283081bc57_How%2520Employee%2520Onboarding%2520Changed%2520In%2520A%2520Post--01.jpeg',
      'title': 'Discover',
      'description': 'Discover new features and functionalities.',
    },
    {
      'image':
          'https://lh3.googleusercontent.com/-sGtfHhNK0a908KZlhAJxp5TFE4Rg96NcXTQb0UZLZuZcZkxN_J6VzSZB13EwJlZUWaprOwXRrmJGHi-9Cmu48Ev4A5L_0zMeE5FOY5gtlR5C_FhLqilNk0cRM0LwtzBXrZaq6V7',
      'title': 'Get Started',
      'description': 'Let\'s get started with our app!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: sliderData.length,
                itemBuilder: (context, index, realIndex) {
                  final item = sliderData[index];
                  return buildPage(item, index);
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
                carouselController: _carouselController,
              ),
            ),
            buildIndicator(),
          ],
        ),
      ),
    );
  }

  Widget buildPage(Map<String, String> item, int index) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(15),
            //   child: Image.network(
            //     item['image']!,
            //     fit: BoxFit.contain,
            //     height: 250,
            //     width: double.infinity,
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              item['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item['description']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (activeIndex > 0) {
                    _carouselController.previousPage();
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: sliderData.length,
                  effect: ExpandingDotsEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: ThemeColor.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: activeIndex == 2
                  ? InkWell(
                      onTap: () {
                        Get.offNamed(RouteHandler.LOGIN);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (activeIndex < sliderData.length - 1) {
                          _carouselController.nextPage();
                        }
                      },
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
            ),
          ],
        ),
      );
}
