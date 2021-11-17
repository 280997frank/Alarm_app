import 'dart:async';

import 'package:alarm_app/view/alarmView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/notification_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationApi.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Judul(),
      ),
    );
  }
}

class Judul extends StatefulWidget {
  const Judul({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JudulState createState() => _JudulState();
}

class _JudulState extends State<Judul> {
  int _selectedNavbar = 0;
  PageController pageController = PageController();

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
    // pageController.jumpToPage(index);
  }


  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: IndexedStack(
          index: _selectedNavbar,
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              child: AlarmView(),
            ),Container(
              color: Colors.green,
            )
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.language),
            title: Text('World Clock'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            title: Text('Alarm'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            title: Text('StopWatch'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.timer),
          //   title: Text('Timer'),
          // ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}


