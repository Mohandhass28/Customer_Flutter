import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  @override
  Widget build(BuildContext context) {
    // Wrap with NotificationListener to prevent scroll events from bubbling up
    return NotificationListener<ScrollNotification>(
      // Prevent scroll notifications from propagating upward
      onNotification: (notification) => true,
      child: CarouselSlider(
        items: [
          Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage('assets/images/CarouselImg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        options: CarouselOptions(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.ease,
          enableInfiniteScroll: true,
          // Use NeverScrollableScrollPhysics to prevent manual scrolling
          // but still allow auto-play to work
          scrollPhysics: AlwaysScrollableScrollPhysics(),
          autoPlayAnimationDuration: Duration(milliseconds: 2000),
          viewportFraction: 0.8,
        ),
      ),
    );
  }
}
