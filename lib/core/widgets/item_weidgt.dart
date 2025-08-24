import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart';
import 'package:internship_tracker/features/login_page.dart';
import 'package:internship_tracker/features/task_detail.dart';
import 'package:internship_tracker/models/task.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

Widget typeBox(String type) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.black, // border color
        width: 1.2, // border thickness
      ),
      boxShadow: [
        BoxShadow(
          color: AppTheme.grayLight.withOpacity(0.4),
          spreadRadius: 0.5,
          blurRadius: 0.5,
        ),
      ],
    ),
    child: Text(
      type,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'SFProDisplay',
      ),
    ),
  );
}

TextStyle styleText(double fontSize, FontWeight fontWeight) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: 'SFProDisplay',
    color: Colors.black,
  );
}

void showNicePopup(
  BuildContext context,
  String title,
  String message,
  IconData icon,
) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    body: Column(
      children: [
        Icon(icon, size: 60, color: Colors.red),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(fontSize: 15)),
      ],
    ),
    btnOkOnPress: () {},
    btnOkColor: Colors.black,
  ).show();
}

Widget taskList(Task task, BuildContext context) {
  return GestureDetector(
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black, // border color
          width: 1.2, // border thickness
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title + favoirute button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task.position, style: styleText(20, FontWeight.w700)),
              Icon(Icons.favorite_border),
            ],
          ),
          // type
          Text(
            task.type.toString().replaceAll('Type.', ''),
            style: styleText(14, FontWeight.w400),
          ),
          // comapany name
          Text(task.companyName, style: styleText(16, FontWeight.w400)),
          // location + work type
          Text(
            "${task.location}  (${task.workType.toString().replaceAll('WorkType.', '')})",
            style: styleText(14, FontWeight.w400),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: styleText(14, FontWeight.w400), // default style
                  children: [
                    TextSpan(text: "${task.timeLeft} on "),
                    TextSpan(
                      text: task.source.toString().replaceAll('Source.', ''),
                      style: styleText(
                        14,
                        FontWeight.w700,
                      ), // bold only for source
                    ),
                  ],
                ),
              ),
              Text(
                task.status.toString().replaceAll('TaskStatus.', ' '),
                style: TextStyle(
                  color: AppTheme.blueDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SFProDisplay',
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskDetails(task: task,)),
      );
    },
  );
}
