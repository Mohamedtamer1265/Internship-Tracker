import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/core/widgets/task_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_tracker/features/home_page.dart';
import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/models/task.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

Future<bool> createTask(
  BuildContext context,
  Map<String, dynamic> taskData,
) async {
  try {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/tasks/create"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 200) {
      showNicePopup(
        context,
        "Error",
        "Failed: ${response.statusCode}\n${response.body}",
        Icons.error,
      );
      return false;
    }
    return true;
  } catch (e) {
    showNicePopup(context, "Error", "Something went wrong: $e", Icons.error);
    return false;
  }
}

Future<bool> updateTask(
  BuildContext context,
  String taskId,
  Map<String, dynamic> taskData,
) async {
  try {
    final token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse("http://10.0.2.2:3000/tasks/$taskId/update"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 200) {
      showNicePopup(
        context,
        "Error",
        "Failed: ${response.statusCode}\n${response.body}",
        Icons.error,
      );
      return false;
    }
    return true;
  } catch (e) {
    showNicePopup(context, "Error", "Something went wrong: $e", Icons.error);
    return false;
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedStatus = taskStatus[0];
  String? selectedWorkType = workType[2]; // default "onsite"
  String? selectedType = taskType[0];
  String? selectedSource = sourceList[0];

  DateTime? appliedDate = DateTime.now();
  DateTime? deadline;

  @override
  void initState() {
    super.initState();
    // If editing, prefill fields
    if (widget.task != null) {
      final t = widget.task!;
      companyController.text = t.companyName;
      positionController.text = t.position;
      locationController.text = t.location;
      descriptionController.text = t.description ?? "";
      selectedStatus = t.status;
      selectedWorkType = t.workType;
      selectedType = t.type;
      selectedSource = t.source;
      appliedDate = t.appliedDate;
      deadline = t.deadline;
    }
  }

  @override
  void dispose() {
    companyController.dispose();
    positionController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context, bool isDeadline) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline
          ? (deadline ?? DateTime.now())
          : (appliedDate ?? DateTime.now()),
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

  Future<void> _onSubmit() async {
    String token = await storage.read(key: 'token').toString();
    if (companyController.text.isEmpty ||
        positionController.text.isEmpty ||
        locationController.text.isEmpty) {
      showNicePopup(
        context,
        "Warning",
        "Please fill company, position and location fields",
        Icons.warning_amber_sharp,
      );
      return;
    }

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
      "description": descriptionController.text.isNotEmpty
          ? descriptionController.text
          : "",
    };
    final bool ok = widget.task == null
        ? await createTask(context, taskData)
        : await updateTask(context, widget.task!.taskId.toString(), taskData);

    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Job" : "Add Job",
          style: styleText(20, FontWeight.w800),
        ),
      ),
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
              decoration: taskDecoration("Source"),
            ),
            const SizedBox(height: 10),
            TaskField(
              controller: descriptionController,
              text: "Description",
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
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(221, 221, 221, 1),
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
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(221, 221, 221, 1),
                  ),
                  child: Text("Select", style: styleText(10, FontWeight.w400)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: Text(
                  isEdit ? "Update Job" : "Add Job",
                  style: styleText(
                    16,
                    FontWeight.w600,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
