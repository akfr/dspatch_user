import 'package:dspatch_user/bottom_navigation/account/account_page.dart';
import 'package:dspatch_user/bottom_navigation/my_deliveries/ui/my_deliveries.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home/home_page.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int currentIndex = 1;
    if (ModalRoute.of(context)?.settings?.arguments != null) {
      try {
        currentIndex = (ModalRoute.of(context).settings.arguments as int) ?? 0;
      } catch (e) {
        print(e);
      }
    }
    return BottomNavigationStateful(currentIndex ?? 0);
  }
}

class BottomNavigationStateful extends StatefulWidget {
  final int currPos;

  BottomNavigationStateful(this.currPos);

  _BottomNavigationState createState() => _BottomNavigationState(currPos);
}

class _BottomNavigationState extends State<BottomNavigationStateful> {
  Permission _permission = Permission.location;

  PermissionStatus _status;
  int _currentIndex;

  _BottomNavigationState(this._currentIndex);

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
    requestPermission(_permission);
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _status = status);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _status = status;
      print(_status);
    });
  }

  final List<Widget> _children = <Widget>[
    MyDeliveriesPage(),
    HomePage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _bottomBarItems = [
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_feeds.png', scale: 3),
        activeIcon: Image.asset(
          'images/ic_feeds.png',
          scale: 3,
          color: Theme.of(context).primaryColor,
          colorBlendMode: BlendMode.color,
        ),
        // title: SizedBox.shrink(),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_home.png', scale: 3),
        activeIcon: Image.asset('images/ic_home_active.png', scale: 3),
        // title: SizedBox.shrink(),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('images/ic_profile.png', scale: 3),
        activeIcon: Image.asset('images/ic_profile_active.png', scale: 3),
        // title: SizedBox.shrink(),
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              elevation: 50,
              items: _bottomBarItems,
              currentIndex: _currentIndex,
              showSelectedLabels: false,
              onTap: (int index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}
