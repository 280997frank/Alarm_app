import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/notification_api.dart';
import 'package:alarm_app/alarm.dart';
import 'package:intl/intl.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Alarm App'),
          leading: Center(
            child: Text('Edit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent
            ),
            ),
          ),
        ),
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
  @override
  void initState() {
    super.initState();

    dateTime = DateTime.now();
  }


  DateTime initialDate = DateTime.now();
  int counter = 0;
  int click = 1;
  bool startAndStop = true;
  bool stopwatch;
  bool alarm = false;
  String button = 'start';
  bool isNotification = false;
  final alarms = <Alarm>[];

  void _activeButton(Alarm item, bool value) async {
    setState(() {
      item.active = value;
    });

    Future<bool> isNotif = NotificationApi.showNotification(item.clock, value);
    isNotif.then((value) {
      if (value) {
        isNotification = true;
      }
    });

    startAndStop = false;
    stopwatch = true;
    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (!stopwatch) {
        timer.cancel();
      }
      if (stopwatch) {
        int diff = item.clock.difference(DateTime.now()).inSeconds;
        // print(diff);
        // print(isNotification);
        if ( diff <= -1 && isNotification) {
          stopwatch = false;
          setState(() {
            item.active = false;
          });
        }
      }
    });
  }

  void _addAlarm(DateTime date) {
      setState(() {
        dateTime = date;
        print('ini bro ' + dateTime.toString());
      });
  }

  void _setAlarm() {
    // int diff = dateTime.difference(DateTime.now()).inSeconds;
    // setState(() {
    //   initialDate = DateTime.now();
    // });
    //
    // bool tes1 = initialDate.difference(DateTime.now()).inMinutes == 0;
    // bool tes2 = dateTime.difference(initialDate).inSeconds == 0;
    // print('ini tes1 ' + tes1.toString());
    // print('ini tes2 ' + tes2.toString());
    // if (initialDate.difference(DateTime.now()).inMinutes == 0 && dateTime.difference(initialDate).inSeconds == 0) {
    //   dateTime = DateTime.now();
    // }
    //
    // print('ini date time ' + dateTime.toString());
    //
    // // if(diff <= -1) {
    // //   dateTime = DateTime.now();
    // // }

    setState(() {
      Alarm alarm = new Alarm(dateTime, true);
      alarms.add(alarm);

      NotificationApi.showNotification(alarm.clock, alarm.active);

      startAndStop = false;
      stopwatch = true;

      Timer.periodic(new Duration(seconds: 1), (timer) {
        if (!stopwatch) {
          timer.cancel();
        }
        if (stopwatch) {
          int diff = alarm.clock.difference(DateTime.now()).inSeconds;
          // print(diff);
          // print(isNotification);
          if ( diff <= -1 && isNotification) {
            stopwatch = false;
            setState(() {
              alarm.active = false;
            });
          }
        }
      });
    });
  }

  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }


  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        // appBar: AppBar(title: Text(widget.title),),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.black,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: Text('No Alarm', style: TextStyle(
                          color: Colors.grey
                        )),
                      )
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                        child: RaisedButton(
                          child: Text('Setup', style: TextStyle(
                            color: Colors.orangeAccent
                          ),),
                          color: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)
                          ),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                )
              )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey
                  ),
                )
              ),
                height: 70,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10,left: 10),
                      child: Text('Other',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                          )
                      )
                    ),
                  ),
                ],
              )
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                 ...alarms.map((item) {
                   final String formatted = DateFormat.Hm().format(item.clock);
                   return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                              child: item.active ? Text(formatted, style: TextStyle(
                                fontSize: 40,
                                  color: Colors.white
                              ),) : Text(formatted, style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0, top: 10, bottom: 10),
                              child: CupertinoSwitch(
                                value: item.active,
                                onChanged: (bool value) {
                                  _activeButton(item, value);
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey
                                  ),
                                )
                            )
                        )
                      ],
                    );
                  }).toList(),
                ],
              )
            )
          ],
        )
    ,
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListView(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDate) {
                        _addAlarm(newDate);
                      },
                      mode: CupertinoDatePickerMode.time,
                    ),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      _setAlarm();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      },
      child: Icon(Icons.add),
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Pesanan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Inbox'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Akun'),
          ),
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


