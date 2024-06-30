import 'package:flutter/cupertino.dart';

class Responsive {

  late double width;

  Responsive(BuildContext context) {
    width = MediaQuery.of(context).size.width;
  }

  bool isMobile() {
    return width < 850;
  }

  bool isTablet() {
    return width >= 850 && width <= 1100;
  }

  bool isDesktop() {
    return width > 100;
  }
}