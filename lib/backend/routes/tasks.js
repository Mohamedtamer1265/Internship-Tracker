import express from "express";
import passport from "../config/passport.js";
import {
  createTask,
  getTasks,
  updateTask,
  removeTask,
  updateFav,
  getFav,
} from "../controller/TaskController.js";
const router = express.Router();

// Middleware to require authentication
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

// ---------------- TASK ROUTES ---------------- //

// Apply authentication middleware to all routes
router.use(requireAuth);

// Create task
router.post("/create", createTask());

// Get all tasks for logged-in user
router.get("/", getTasks());


// get fav tasks
router.get("/favorite", getFav());


// toggle fav
router.patch("/:id/favorite", updateFav());

// Update task
router.put("/:id/update", updateTask());


// Remove task
router.delete("/:id/delete", removeTask());

export default router;
