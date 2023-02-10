import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lesgou/screens/calendar_page.dart';
import 'package:lesgou/screens/home_page.dart';
import 'package:lesgou/screens/settings_page.dart';

import '../util/colors.dart';

class CommonHUD extends StatefulWidget {
  const CommonHUD({Key? key}) : super(key: key);

  static const String route = 'commonHUD';

  @override
  State<CommonHUD> createState() => _CommonHUDState();
}

class _CommonHUDState extends State<CommonHUD> {
  var _selectedTab = _SelectedTab.Home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DotNavigationBar(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        enableFloatingNavBar: false,
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        dotIndicatorColor: quaternary,
        backgroundColor: primary,
        unselectedItemColor: Colors.grey[700],
        selectedItemColor: Colors.white,
        enablePaddingAnimation: false,
        onTap: _handleIndexChanged,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).viewPadding.top + 20),
        child: navigation[_selectedTab.index],
      ),
    );
  }
}

enum _SelectedTab { Home, Calendar, Settings }

List<StatefulWidget> navigation = [HomePage(), CalendarPage(), SettingsPage()];
