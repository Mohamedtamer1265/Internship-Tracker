import 'package:flutter/material.dart';
import 'package:internship_tracker/features/add_task.dart';

Widget footer(BuildContext context) {
  Widget footer = Stack(
    alignment: Alignment.bottomCenter,
    children: [
      // bar
      Container(
        margin: EdgeInsets.fromLTRB(60, 0, 45, 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => (),
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () => (),
              icon: Icon(Icons.favorite_outline, color: Colors.white),
            ),
          ],
        ),
      ),
      // add button
      GestureDetector(
        child: Container(
          // alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 35),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.black, // border color
              width: 2, // border thickness
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(25 / 100),
                spreadRadius: .5,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Icon(Icons.add, color: Colors.black),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
      ),
    ],
  );
  return footer;
}
