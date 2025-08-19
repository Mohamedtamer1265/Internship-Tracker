enum TaskStatus { pending, accepted, rejected }
enum Source {
  linkedin,
  googleForm,
  glassdoor,
  indeed,
  companyWebsite,
  referral,
  email,
  other,
}

enum WorkType { remote, hybrid, onsite }
enum Type {
  internship,
  remote,
  fullTime,
  partTime,
  freelance,
  volunteer,
  temporary,
  contract,
  apprenticeship,
}


class Task {
  final String companyName;
  final DateTime appliedDate;
  final DateTime deadline;
  final TaskStatus status;
  final String position;
  final String location;
  final WorkType workType;
  final Enum source;
  final Enum type; // Types of internships
  final String? description; // Optional description field

  const Task({
    required this.companyName,
    required this.appliedDate,
    required this.deadline,
    required this.status,
    required this.position,
    required this.location,
    required this.workType,
    required this.source,
    this.type = Type.internship, // Default type is internship
    this.description,
  });

  /// Helper: Check if the deadline has passed
  bool get isDeadlinePassed => DateTime.now().isAfter(deadline);

  /// Helper: Time left until deadline
  String get timeLeft {
    final diff = deadline.difference(DateTime.now());

    if (diff.isNegative) {
      return "Expired";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} left";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} left";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} min left";
    } else {
      return "${diff.inSeconds} sec left";
    }
  }

  /// Convert Task to JSON
  Map<String, dynamic> toJson() => {
    'companyName': companyName,
    'appliedDate': appliedDate.toIso8601String(),
    'deadline': deadline.toIso8601String(),
    'status': status.name,
    'position': position,
    'location': location,
    'workType': workType.name,
    'source': source,
  };

  /// Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    companyName: json['companyName'],
    appliedDate: DateTime.parse(json['appliedDate']),
    deadline: DateTime.parse(json['deadline']),
    status: TaskStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => TaskStatus.pending,
    ),

    position: json['position'],
    location: json['location'],
    workType: WorkType.values.firstWhere(
      (e) => e.name == json['workType'],
      orElse: () => WorkType.onsite,
    ),
    source: json['source'] ?? 'unknown',
  );

  @override
  String toString() {
    return 'Task(companyName: $companyName, appliedDate: $appliedDate, deadline: $deadline, status: $status, position: $position, location: $location, workType: $workType)';
  }
}
