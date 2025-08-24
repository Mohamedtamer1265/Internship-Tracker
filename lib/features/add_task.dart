import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/core/widgets/task_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

Future<void> createTask(
  BuildContext context,
  Map<String, dynamic> taskData,
) async {
  try {
    final token = await storage.read(key: 'token');
    if (token == null) {
      showNicePopup(context, "eror", "fUck", Icons.check_circle);
      return;
    }
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/tasks/create"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(taskData),
    );

    if (response.statusCode == 200) {
      showNicePopup(
        context,
        "Success",
        "Task created successfully 🎉",
        Icons.check_circle,
      );
    } else {
      showNicePopup(
        context,
        "Error",
        "Failed: ${response.statusCode}\n${response.body}",
        Icons.error,
      );
    }
  } catch (e) {
    showNicePopup(context, "Error", "Something went wrong: $e", Icons.error);
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final locationController = TextEditingController();
  final decriptionController = TextEditingController();
  String? selectedStatus = taskStatus[0];
  String? selectedWorkType = workType[2]; // default "onsite"
  String? selectedType = taskType[0];
  String? selectedSource = sourceList[0];

  DateTime? appliedDate = DateTime.now();
  DateTime? deadline;

  @override
  void dispose() {
    companyController.dispose();
    positionController.dispose();
    locationController.dispose();
    decriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context, bool isDeadline) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          deadline = picked;
        } else {
          appliedDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Job", style: styleText(20, FontWeight.w800))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TaskField(controller: companyController, text: "Company Name"),
            const SizedBox(height: 10),
            TaskField(controller: locationController, text: "Location"),
            const SizedBox(height: 10),
            TaskField(controller: positionController, text: "Position"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: taskStatus
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
              decoration: taskDecoration("Status"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedWorkType,
              /*
              same as 
              items: [
              DropdownMenuItem(value: "remote", child: Text("remote")),
              DropdownMenuItem(value: "hybrid", child: Text("hybrid")),
              DropdownMenuItem(value: "onsite", child: Text("onsite")),
                     ],
               */
              items: workType
                  .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                  .toList(),
              onChanged: (v) => setState(() => selectedWorkType = v),
              decoration: taskDecoration("Work Type"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: taskType
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => selectedType = v),
              decoration: taskDecoration("Type"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedSource,
              items: sourceList
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => selectedSource = v),
              decoration: taskDecoration("Type"),
            ),
            const SizedBox(height: 10),
            TaskField(
              controller: decriptionController,
              text: "description",
              isDescription: true,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Applied Date: ${appliedDate != null ? appliedDate!.toLocal().toString().split(' ')[0] : 'Not selected'}",
                    style: styleText(15, FontWeight.w400),
                  ),
                ),
                TextButton(
                  onPressed: () => pickDate(context, false),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromRGBO(221, 221, 221, 1),
                    ),
                  ),
                  child: Text("Select", style: styleText(10, FontWeight.w400)),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Deadline: ${deadline != null ? deadline!.toLocal().toString().split(' ')[0] : 'Not selected'}",
                    style: styleText(15, FontWeight.w400),
                  ),
                ),
                TextButton(
                  onPressed: () => pickDate(context, true),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromRGBO(221, 221, 221, 1),
                    ),
                  ),
                  child: Text("Select", style: styleText(10, FontWeight.w400)),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              onPressed: () async {
                if (companyController.text.isNotEmpty &&
                    positionController.text.isNotEmpty &&
                    locationController.text.isNotEmpty) {
                  final taskData = {
                    "companyName": companyController.text,
                    "position": positionController.text,
                    "location": locationController.text,
                    "status": selectedStatus,
                    "workType": selectedWorkType,
                    "type": selectedType,
                    "source": selectedSource,
                    "appliedDate": appliedDate?.toIso8601String(),
                    "deadline": deadline?.toIso8601String(),
                    "description": decriptionController.text.isNotEmpty
                        ? decriptionController.text
                        : "",
                  };
                  await createTask(context, taskData);
                } else {
                  showNicePopup(
                    context,
                    "Warning",
                    "Fill all the fields",
                    Icons.warning_amber_sharp,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text(
                "Add Job",
                style: styleText(
                  15,
                  FontWeight.w400,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
