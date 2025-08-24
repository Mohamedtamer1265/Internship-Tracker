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


const requireAuth = (req, res, next) => {
  passport.authenticate("jwt", { session: false }, (err, user) => {
    if (err) return next(err); 
    if (!user) {
      return res
        .status(401)
        .json({ error: "Unauthorized - invalid or expired token" });
    }
    req.user = user;
    next();
  })(req, res, next);
};

router.post("/create", requireAuth, createTask());

// Get all tasks for logged-in user
router.get("/", getTasks);

// Get task by id
router.get("/:id", getTask);

// Create task
router.post("/create", createTask());

// Update task
router.put("/:id", updateTask);

// Remove task
router.delete("/:id", removeTask);

export default router;
