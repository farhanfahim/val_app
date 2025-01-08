import 'package:flutter/material.dart';
import 'package:val_app/configs/routes/routes_name.dart';

class OnboardViewModel extends ChangeNotifier {
  PageController pageController = PageController();
  int selectedIndex = 0;

  List<String> titles = ['Welcome to Your Creative\nShowcase!', 'Crafting your personal\nbrand', 'Building an impactful\nportfolio'];

  List<String> subtitles = ['This app is your canvas to display your best work and inspire others', 'Tell your unique story by customizing your profile and creating a personal brand that shines.', 'Highlight your creativity with an impressive portfolio that captivates your audience and showcases your best work.'];

  void onPageChanged(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  nextPage(BuildContext context) {
    if (selectedIndex < 2) {
      pageController.animateToPage(
        selectedIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      // Navigate to login
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
    notifyListeners();
  }

  skip(BuildContext context) {
    // Navigate to login
    // Navigator.pushReplacementNamed(context, '/login');
    Navigator.pushReplacementNamed(context, RoutesName.login);
  }
}
