import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/notification_api.dart';
import 'package:alarm_app/alarm.dart';
import 'package:intl/intl.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({Key key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<AlarmView> {
  DateTime dateTime = DateTime.now();
  int id = 0;
  int click = 1;
  bool startAndStop = true;
  bool stopwatch;
  bool alarm = false;
  String button = 'start';
  bool isNotification = false;
  final alarms = <Alarm>[];

  void _activeButton(Alarm item, bool value) async {
    print('ini status ' + value.toString());
    setState(() {
      item.active = value;
    });

    NotificationApi.showNotification(item);

    // startAndStop = false;
    // stopwatch = true;
    // Timer.periodic(new Duration(seconds: 1), (timer) {
    //   if (!stopwatch) {
    //     timer.cancel();
    //   }
    //   if (stopwatch) {
    //     int diff = item.clock.difference(DateTime.now()).inSeconds;
    //     if ( diff <= -1 && isNotification) {
    //       stopwatch = false;
    //       setState(() {
    //         item.active = false;
    //       });
    //     }
    //   }
    // });
  }

  void _addAlarm(DateTime date) {
    setState(() {
      dateTime = date;
      print('ini bro ' + dateTime.toString());
    });
  }

  void _setAlarm() {
    id += 1;
    print(id);
    Alarm alarm = new Alarm(id, dateTime, true, false);
    setState(() {
      alarms.add(alarm);
    });

    NotificationApi.showNotification(alarm);
    alarm.isNotification = true;

    startAndStop = false;
    stopwatch = true;

    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Alarm'),
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
      body: ListView(
        children: <Widget>[
          Container(
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
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.white30
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
                              color: Colors.white30
                          ),
                        )
                    )
                )
              ],
            );
          }).toList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
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
