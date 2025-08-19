const mongoose = require("mongoose");

const TaskStatus = ["pending", "accepted", "rejected"];
const WorkType = ["remote", "hybrid", "onsite"];
const Type = [
  internship,
  remote,
  fullTime,
  partTime,
  freelance,
  volunteer,
  temporary,
  contract,
  apprenticeship,
];
const Source = [
  linkedin,
  googleForm,
  glassdoor,
  indeed,
  companyWebsite,
  referral,
  email,
  other,
];

const taskSchema = new mongoose.Schema({
  companyName: {
    type: String,
    required: true,
  },
  appliedDate: {
    type: Date,
    required: true,
    default: Date.now,
  },
  deadline: {
    type: Date,
    required: true,
  },
  status: {
    type: String,
    enum: TaskStatus,
    default: "pending",
  },
  position: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  workType: {
    type: String,
    enum: WorkType,
    default: "onsite",
  },
  source: {
    type: String,
    enum: Source,
    default: "unknown",
  },
  type: {
    type: String,
    enum: Type,
    default: "type",
  },
});

// Optional: add a virtual for days left until deadline
taskSchema.virtual("daysLeft").get(function () {
  const diff = this.deadline - new Date();
  return Math.ceil(diff / (1000 * 60 * 60 * 24));
});

const Task = mongoose.model("Task", taskSchema);

module.exports = Task;
