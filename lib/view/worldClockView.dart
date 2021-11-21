import 'package:alarm_app/worldClock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class WorldClockView extends StatefulWidget {
  const WorldClockView({Key key}) : super(key: key);

  @override
  _WorldClockState createState() => _WorldClockState();
}

class _WorldClockState extends State<WorldClockView> {
  DateTime clock = DateTime.now();
  WorldClock selectedWorldClock = new WorldClock(1, 'Jakarta', 0);
  final worldClockList = <WorldClock>[];
  final displayedWorldClockList = <WorldClock>[];

  @override
  void initState() {
    super.initState();
    WorldClock jakarta = new WorldClock(1, 'Jakarta', 0);
    WorldClock japan = new WorldClock(2, 'Japan', 1);
    WorldClock amerika = new WorldClock(3, 'Amerika', 2);

    worldClockList.add(jakarta);
    worldClockList.add(japan);
    worldClockList.add(amerika);

    Timer.periodic(new Duration(seconds: 1), (timer) {
       setState(() {
         clock = DateTime.now();
       });
    });
  }

  void _selectedWorldClock(int index) {
    setState(() {
      selectedWorldClock = worldClockList[index];
    });
  }

  void _setWorldClock() {
    setState(() {
      displayedWorldClockList.add(selectedWorldClock);
    });

    selectedWorldClock = worldClockList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: Text('Alarm'),
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
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'World Clock', style: TextStyle(
                        color: Colors.white,
                        fontSize: 40
                      ),
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
            ),
            ...displayedWorldClockList.map((worldClock) {
              String formattedClock = DateFormat.Hm().format(clock.add(Duration(hours: worldClock.duration)));
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 30.0),
                          child: Text(
                            worldClock.region, style: TextStyle(
                              color: Colors.white,
                              fontSize: 30
                          ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.only(right: 10.0, bottom: 10.0, top: 30.0),
                            child: Text(
                              formattedClock, style: TextStyle(
                                color: Colors.white,
                                fontSize: 30
                            ),
                            )
                        ),
                      )
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
                      height: 350,
                      child: CupertinoPicker(
                        itemExtent: 64,
                        children: worldClockList.map((item) => Center(
                          child: Text(
                            item.region, style: TextStyle(
                            fontSize: 32,
                          )
                          ),
                        ))
                        .toList(),
                        onSelectedItemChanged: (index) {
                          _selectedWorldClock(index);
                        },
                      ),
                    ),
                    CupertinoButton(
                      child: Text('OK'),
                      onPressed: () {
                        _setWorldClock();
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
