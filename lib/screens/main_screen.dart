import 'package:flutter/material.dart';
import 'package:sunshine/sunshine.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home',
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          onPressed: () {
            ExtendedNavigator.root.push(Routes.accountScreen);
          },
        ),
      ),
      body: const Center(
        child: SunshineLoading(),
      ),
    );
  }
}
