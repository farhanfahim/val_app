import 'package:flutter/material.dart';
import 'package:val_app/configs/color/colors.dart';

// ignore: must_be_immutable
class MainScaffold extends StatelessWidget {
  Widget? appBar;
  Color backgroundColor;
  Widget? body;
  Widget? bottomNavigationBar;
  Widget? floatingActionButton;
  Widget? bottomSheet;
  bool extendBehindAppBar;
  bool isTopSafeArea;
  Widget? drawer;
  bool isBottomSafeArea;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  @override
  MainScaffold({
    Key? key,
    this.drawer,
    this.appBar,
    this.backgroundColor = AppColors.backgroundColor,
    this.isTopSafeArea = true,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.bottomSheet,
    this.extendBehindAppBar = false,
    this.isBottomSafeArea = false,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: extendBehindAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
      bottomSheet: bottomSheet,
      appBar: appBar != null ? PreferredSize(preferredSize: const Size.fromHeight(35.0), child: appBar!) : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
