import 'package:flutter/material.dart';

class PageManager {
  final PageController _pageController;
  int page = 0;

  PageManager(this._pageController);

  void setpage(int value) {
    if (value == page) return;

    page = value;
    _pageController.jumpToPage(page);
  }
}
