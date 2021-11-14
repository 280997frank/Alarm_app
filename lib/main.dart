import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/notification_api.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alarm_app/alarm.dart';
import 'package:intl/intl.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  int counter = 0;
  int click = 1;
  bool startAndStop = true;
  bool stopwatch;
  bool alarm = false;
  String button = 'start';
  final alarms = <Alarm>[];

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+6281375151332',
      text: "Hay sayang",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  // Future _showNotification() async {
  //   var iosDetails = new IOSNotificationDetails();
  //   var generalNotification = new NotificationDetails(iOS: iosDetails);
  //   await localNotification.show(0, 'Notif', 'ini body', generalNotification);
  // }

  void _activeButton(Alarm item, bool value) async {
    setState(() {
      item.active = value;
    });

    Future<DateTime> clock = NotificationApi.showNotification(item.clock, value);

    startAndStop = false;
    stopwatch = true;
    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (!stopwatch) {
        // _notifications.show(0, 'Alarm', 'alarm berbunyi', _notificationDetails(), payload: 'segera matikan alarm');
        timer.cancel();
      }
      if (stopwatch) {
        int diff = item.clock.difference(DateTime.now()).inSeconds;
        if ( diff == -1) {
          stopwatch = false;
          setState(() {
            item.active = false;
          });
          // launchWhatsApp();
          // NotificationApi.showNotification(alarm);
        }
      }
    });
  }

  void _addAlarm(DateTime date) {
    print(date);
      setState(() {
        if (date == null) {
          dateTime = DateTime.now();

          return;
        }
        dateTime = date;
      });
  }

  void _setAlarm() {
    setState(() {
      Alarm alarm = new Alarm(dateTime, false);
      alarms.add(alarm);
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
            Container(
              child: Column(
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
                              child: Text(formatted, style: TextStyle(
                                fontSize: 40,
                                  color: Colors.white
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
    );
  }
}


