import 'package:flutter/material.dart';

class DrawerItem {
  String? title;
  Image? image;
  IconData? icon;
  String? route;

  DrawerItem(this.title, this.icon, this.route);
  //DrawerItem(this.title, this.icon,this.image, this.route);
}
