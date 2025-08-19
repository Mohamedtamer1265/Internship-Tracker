import 'package:flutter/material.dart';
import 'package:internship_tracker/core/widgets/app_bar.dart';
import 'package:internship_tracker/core/widgets/footer.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
            Text("Recent internships",
                style: styleText(25, FontWeight.w700)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                    taskList(Task(
                      companyName: "Microsoft",
                      appliedDate: DateTime.now(),
                      status: TaskStatus.accepted,
                      position: "Software Engineer Intern",
                      location: "USA",
                      workType: WorkType.remote,
                      source: Source.linkedin,
                      deadline: DateTime.now().add(Duration(days: 30)),
                      type: Type.internship,
                      description: "An exciting internship at Microsoft.",
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: footer(),
    );
  }
}
