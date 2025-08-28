import 'package:flutter/material.dart';
import 'package:internship_tracker/main.dart';

AppBar homePageBar() {
  return AppBar(
    title: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child:
              // left section with profile picture and name
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/123456789?v=4",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        nickName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
        // add notification button
        Container(
          alignment: Alignment.centerRight,
          child: Icon(Icons.notifications, size: 30),
        ),
      ],
    ),
  );
}
