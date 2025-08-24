import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';

class TaskField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final bool isDescription;
  const TaskField({
    super.key,
    required this.controller,
    required this.text,
    this.isDescription = false,
  });

  @override
  State<TaskField> createState() => _TaskFieldState();
}

class _TaskFieldState extends State<TaskField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: taskDecoration(
        widget.text,
        isDescription: widget.isDescription,
      ),
      maxLines: widget.isDescription ? 6 : 1,
    );
  }
}

InputDecoration taskDecoration(String text, {bool isDescription = false}) {
  return InputDecoration(
    labelStyle: styleText(15, FontWeight.w400),
    labelText: text,
    filled: true,
    fillColor: const Color.fromRGBO(247, 247, 247, 1),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 0.7),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: isDescription
        ? const EdgeInsets.fromLTRB(10, 0, 10, 90) // taller for description
        : const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ), // normal height
  );
}
