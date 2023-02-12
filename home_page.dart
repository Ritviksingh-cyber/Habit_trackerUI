import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //overall habit list
  List habitlist=[
    //  [habitName,habitStarted,timeSpent(sec),timeGoal(min)]
    ['Exercise',false,0,60],
    ['Study',false,0,120],
    ['Read',false,0,30],
    ['Meditation',false,0,20],
    ['Code',false,0,60],
    ['Room Cleaning',false,0,20],
    ['Minimalism',false,0,30],
  ];


  void habitstarted(int index) {
    //note what the start time is
    var startTime = DateTime.now();

    //include the time already elapsed
    int elapsedTime = habitlist[index][2];

    //habit started or stopped
    setState(() {
      habitlist[index][1] = !habitlist[index][1];
    });

    if ( habitlist[index][1]) {
      //keep the time going
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //check when the user has stopped the timer
          if (!habitlist[index][1]) {
            timer.cancel();
          }

          //calculate the time elapsed by comparing current the current time and start time
          var currentTime = DateTime.now();
          habitlist[index][2] = elapsedTime + currentTime.second - startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }
  void settingsOpened(int index){
    showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('settings for ' + habitlist[index][0]),

          );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Consistency is the key'),
        centerTitle: false,
      ),
    body: ListView.builder(
      itemCount: habitlist.length,
      itemBuilder: ((context,index){
      return habit_tile(
          habitName: habitlist[index][0],
          onTap: (){
            habitstarted(index);
          },
          settingsTapped:(){
            settingsOpened(index);
          },
          habitStarted: habitlist[index][1],
          timeSpent: habitlist[index][2],
          timeGoal: habitlist[index][3],
      );
    }),
    ),
    );
  }
}
