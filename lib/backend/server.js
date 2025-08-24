import express, { Router } from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import session from "express-session";
import MongoStore from "connect-mongo";
import crypto from "crypto"; // For generating session IDs
import passport from "./config/passport.js";
import User from "./config/user.js"; // Assuming you have a User model defined
import auth from "./routes/auth.js";
import tasks from "./routes/tasks.js";
dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Connect to MongoDB
mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("Connected!"))
  .catch((err) => console.error("MongoDB connection error:", err));

app.use("/auth", auth);
app.use("/tasks",tasks);
app.get("/", (req, res) => {
  req.session.views = (req.session.views || 0) + 1;
  res.send(`Views: ${req.session.views}`);
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
