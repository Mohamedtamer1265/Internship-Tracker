import 'package:flutter/material.dart';
import 'package:internship_tracker/features/add_task.dart';

class Footer extends StatefulWidget {
  final Function(bool) onTap;
  const Footer({super.key, required this.onTap});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  bool changeIcon = false; // false -> home ....true -> favorite
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom navigation bar
        Container(
          margin: const EdgeInsets.fromLTRB(60, 0, 45, 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: "Home",
                onPressed: () {
                  setState(() {
                    if(!changeIcon)return;
                    changeIcon = !changeIcon;
                  });
                  widget.onTap(true);
                }, // Recent internships
                icon: Icon(
                  !changeIcon ? Icons.home : Icons.home_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                tooltip: "Favorites",
                onPressed: () {
                  setState(() {
                    if(changeIcon)return;
                    changeIcon = !changeIcon;
                  });
                  widget.onTap(false);
                }, // Favorites
                icon: Icon(
                  changeIcon ? Icons.favorite : Icons.favorite_outline,
                  color: changeIcon ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Floating Add button
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(bottom: 35),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: .5,
                  blurRadius: 0.5,
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()),
            );
          },
        ),
      ],
    );
  }
}
