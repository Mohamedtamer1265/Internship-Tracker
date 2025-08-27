import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart';
import 'package:internship_tracker/features/task_detail.dart';
import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/models/task.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Widget typeBox(String type) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black, width: 1.2),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(message, style: const TextStyle(fontSize: 15)),
      ],
    ),
    btnOkOnPress: () {},
    btnOkColor: Colors.black,
  ).show();
}

/// Converted into a StatefulWidget so we can use setState
class TaskList extends StatefulWidget {
  final Task task;

  const TaskList({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

Future<void> toggleFavorite(int taskId) async {
  final url = Uri.parse("http://10.0.2.2:3000/tasks/$taskId/favorite");
  final token = await storage.read(key: 'token');
  final response = await http.patch(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": token.toString(),
    },
  );

  if (response.statusCode == 200) {
    final updatedTask = jsonDecode(response.body);
    print("Favorite toggled: ${updatedTask['favourite']}");
  } else {
    print("Error: ${response.statusCode}, ${response.body}");
  }
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title + favorite button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task.position,
                  style: styleText(20, FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.task.favorite = !widget.task.favorite;
                      toggleFavorite(widget.task.taskId);
                    });
                  },
                  icon: Icon(
                    widget.task.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.task.favorite ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
            // type
            Text(
              widget.task.type.toString().replaceAll('Type.', ''),
              style: styleText(14, FontWeight.w400),
            ),
            // company name
            Text(
              widget.task.companyName,
              style: styleText(16, FontWeight.w400),
            ),
            // location + work type
            Text(
              "${widget.task.location}  (${widget.task.workType.toString().replaceAll('WorkType.', '')})",
              style: styleText(14, FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: styleText(14, FontWeight.w400),
                    children: [
                      TextSpan(text: "${widget.task.timeLeft} on "),
                      TextSpan(
                        text: widget.task.source.toString().replaceAll(
                          'Source.',
                          '',
                        ),
                        style: styleText(14, FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.task.status.toString().replaceAll('TaskStatus.', ' '),
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
          MaterialPageRoute(
            builder: (context) => TaskDetails(task: widget.task),
          ),
        );
      },
    );
  }
}
