import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/app_bar.dart';
import 'package:internship_tracker/core/widgets/footer.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/main.dart';
import 'package:internship_tracker/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String? token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<List<Task>> fetchTasks() async {
  final token = await storage.read(key: 'token');
  final response = await http.get(
    Uri.parse("http://10.0.2.2:3000/tasks"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": token.toString(),
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load tasks: ${response.statusCode}");
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageBar(),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // types of internships
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  typeBox("Internship"),
                  typeBox("remote"),
                  typeBox("full time"),
                  typeBox("part time"),
                  typeBox("freelance"),
                  typeBox("volunteer"),
                  typeBox("temporary"),
                  typeBox("contract"),
                  typeBox("apprenticeship"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("Recent internships", style: styleText(25, FontWeight.w700)),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: fetchTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No tasks found"));
                  }
                  /*
                  ListView is a scrollable list of widgets.
                  .builder is a special constructor optimized for long or dynamic lists.
                  Instead of building all items at once, it builds them lazily — only what’s visible on screen + a few offscreen items.
                   */
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskList(task :tasks[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: footer(context),
    );
  }
}
