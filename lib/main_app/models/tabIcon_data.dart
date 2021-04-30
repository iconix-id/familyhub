import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/main_app/news.png',
      selectedImagePath: 'assets/main_app/news.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/main_app/chat.png',
      selectedImagePath: 'assets/main_app/chat.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/main_app/family.png',
      selectedImagePath: 'assets/main_app/family.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/main_app/user.png',
      selectedImagePath: 'assets/main_app/user.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
