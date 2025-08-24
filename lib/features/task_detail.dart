import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart';
import 'package:internship_tracker/models/task.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  const TaskDetails({super.key, required this.task});

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.position), // Position first
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.boxFeild,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Company", task.companyName),
            _buildRow("Status", task.status),
            _buildRow("Location", task.location),
            _buildRow("Work Type", task.workType),
            _buildRow("Source", task.source),
            _buildRow("Type", task.type),
            _buildRow(
              "Applied Date",
              task.appliedDate.toLocal().toString().split(' ')[0],
            ),
            _buildRow(
              "Deadline",
              task.deadline.toLocal().toString().split(' ')[0],
            ),
            _buildRow("Time Left", task.timeLeft),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                "Description:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(task.description!),
            ],
          ],
        ),
      ),
    );
  }
}
