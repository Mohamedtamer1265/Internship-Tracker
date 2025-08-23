import express from "express";
import passport from "../config/passport.js";
import {
  createTask,
  getTasks,
  getTask,
  updateTask,
  removeTask,
} from "../controller/TaskController.js";
const router = express.Router();

//  create New Task
router.post("/", passport.authenticate("jwt", { session: false }), createTask);

// get all tasks for logged-in user
router.get("/", passport.authenticate("jwt", { session: false }), getTasks);

//  Get task by id
router.get("/:id", passport.authenticate("jwt", { session: false }), getTask);

// update Task
router.put(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  updateTask
);

// remove Task
router.delete(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  removeTask
);

export default router;
