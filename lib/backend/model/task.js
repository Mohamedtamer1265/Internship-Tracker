import mongoose from "mongoose";

const TaskStatus = ["pending", "accepted", "rejected"];
const WorkType = ["remote", "hybrid", "onsite"];
const Type = [
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
const Source = [
  "linkedin",
  "googleForm",
  "glassdoor",
  "indeed",
  "companyWebsite",
  "referral",
  "email",
  "other",
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
  description: {
    type: String,
    default: "",
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
    default: Source[0],
  },
  type: {
    type: String,
    enum: Type,
    default: "type",
  },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  favourite: {
    type: Boolean,
    default: false,
  },
  taskId: { type: Number },
});
taskSchema.pre("save", async function (next) {
  if (this.isNew) {
    const lastTask = await this.constructor
      .findOne({ userId: this.userId })
      .sort("-taskId")
      .exec();

    this.taskId = lastTask ? lastTask.taskId + 1 : 1;
  }
  next();
});

const Task = mongoose.model("Task", taskSchema);

export default Task;
