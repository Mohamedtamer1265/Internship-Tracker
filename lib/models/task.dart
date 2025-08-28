const List<String> taskStatus = ["pending", "accepted", "rejected"];
const List<String> workType = ["remote", "hybrid", "onsite"];
const List<String> taskType = [
  "internship",
  "remote",
  "fullTime",
  "partTime",
  "freelance",
  "volunteer",
  "temporary",
  "contract",
  "apprenticeship",
];
const List<String> sourceList = [
  "linkedin",
  "googleForm",
  "glassdoor",
  "indeed",
  "companyWebsite",
  "referral",
  "email",
  "other",
];

class Task {
  final String companyName;
  final DateTime appliedDate;
  final DateTime deadline;
  final String status;
  final String position;
  final String location;
  final String workType;
  final String source;
  final String type; // Types of internships
  final String? description; // Optional description field
  final int taskId;
   bool favorite;
   Task({
    required this.companyName,
    required this.appliedDate,
    required this.deadline,
    required this.status,
    required this.position,
    required this.location,
    required this.workType,
    required this.source,
    this.type = "internship", // Default type is internship
    this.description,
    this.favorite = false,
    required this.taskId
  });

  /// Helper: Check if the deadline has passed
  bool get isDeadlinePassed => DateTime.now().isAfter(deadline);

  /// Helper: Time left until deadline
  String get timeLeft {
    final diff = -appliedDate.difference(DateTime.now());
    if (diff.isNegative) return "Expired";
    if (diff.inDays >= 1)
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} left";
    if (diff.inHours >= 1)
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} left";
    if (diff.inMinutes >= 1) return "${diff.inMinutes} min left";
    return "${diff.inSeconds} sec left";
  }

  String get timeUntilDeadline {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return "Expired";
    if (diff.inDays >= 1)
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} left";
    if (diff.inHours >= 1)
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} left";
    if (diff.inMinutes >= 1) return "${diff.inMinutes} min left";
    return "${diff.inSeconds} sec left";
  }

  /// Convert Task to JSON
  Map<String, dynamic> toJson() => {
    'companyName': companyName,
    'appliedDate': appliedDate.toIso8601String(),
    'deadline': deadline.toIso8601String(),
    'status': status,
    'position': position,
    'location': location,
    'workType': workType,
    'source': source,
    'type': type,
    'description': description ?? '',
  };

  /// Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    companyName: json['companyName'],
    appliedDate: DateTime.parse(json['appliedDate']),
    deadline: DateTime.parse(json['deadline']),
    status: json['status'] ?? "pending",
    position: json['position'] ?? "",
    location: json['location'] ?? "",
    workType: json['workType'] ?? "onsite",
    source: json['source'] ?? "other",
    type: json['type'] ?? "internship",
    description: json['description'] ?? '',
    taskId: json['taskId'],
    favorite: json['favorite']??false
  );

  @override
  String toString() {
    return 'Task(companyName: $companyName, appliedDate: $appliedDate, deadline: $deadline, status: $status, position: $position, location: $location, workType: $workType)';
  }
}
