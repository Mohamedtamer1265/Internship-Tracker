import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/features/add_task.dart';
import 'package:internship_tracker/features/home_page.dart';
import 'package:internship_tracker/features/login_page.dart';
import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/models/task.dart';

import 'package:http/http.dart' as http;

Future<void> deleteTask(BuildContext context, String taskId) async {
  try {
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/tasks/$taskId/delete"),
      headers: {"Content-Type": "application/json", "Authorization": "$token"},
    );

    if (response.statusCode != 200) {
      showNicePopup(
        context,
        "Error",
        "Failed: ${response.statusCode}\n${response.body}",
        Icons.error,
      );
      return;
    }
    showNicePopup(
      context,
      "Deleted",
      "Task deleted successfully 🗑️",
      Icons.check_circle,
    );

    // Navigate back to HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(token: token)),
    );
  } catch (e) {
    showNicePopup(context, "Error", "Something went wrong: $e", Icons.error);
  }
}

class TaskDetails extends StatelessWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskPage(task: task),
                        ),
                      );
                    },
                    icon: Icon(Icons.update),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: const Text(
                            "Are you sure you want to delete this task?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(ctx).pop(false), // cancel
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.of(ctx).pop(true), // confirm
                              icon: const Icon(Icons.delete),
                              label: const Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await deleteTask(context, task.taskId.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(task.position, style: styleText(28, FontWeight.bold)),
            const SizedBox(height: 6),
            Text(task.companyName, style: styleText(20, FontWeight.w500)),
            const SizedBox(height: 12),

            // Info cards
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _infoRow(Icons.location_on, "Location", task.location),
                    _infoRow(Icons.work, "Work Type", task.workType),
                    _infoRow(Icons.category, "Type", task.type),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Deadline highlight
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Remaining time until deadline: ${task.timeUntilDeadline}",
                      style: styleText(15, FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description
            if (task.description != null && task.description!.isNotEmpty) ...[
              Text(
                "Updates:",
                style: styleText(
                  18,
                  FontWeight.bold,
                ).copyWith(decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 8),
              Text(
                task.description!,
                style: styleText(15, FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text("$label: ", style: styleText(16, FontWeight.w600)),
          Expanded(child: Text(value, style: styleText(16, FontWeight.w400))),
        ],
      ),
    );
  }
}
