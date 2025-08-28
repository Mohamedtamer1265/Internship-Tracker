import Task from "../model/task.js";
function createTask() {
  return async (req, res) => {
    try {
      const task = new Task({
        ...req.body,
        userId: req.user._id,
      });
      await task.save();
      res.status(200).json(task);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  };
}
function updateFav() {
  return async (req, res) => {
    try {
      const task = await Task.findOne({
        taskId: req.params.id,
        userId: req.user._id,
      });
      if (!task) {
        return res.status(404).json({ error: "Task not found" });
      }
      task.favorite = !task.favorite;
      await task.save();
      console.log(task);
      res.json(task);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
}

function getTasks() {
  return async (req, res) => {
    try {
      const tasks = await Task.find({ userId: req.user._id });
      res.json(tasks);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
}

function getFav() {
  return async (req, res) => {
    try {
      const tasks = await Task.find({ userId: req.user._id,favorite : true });
      res.json(tasks);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
}

function getTask() {
  return async (req, res) => {
    try {
      const task = await Task.findOne({
        _id: req.params.id,
        userId: req.user._id,
      });

      if (!task) return res.status(404).json({ error: "Task not found" });

      res.json(task);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
}

function updateTask() {
  return async (req, res) => {
    try {
      const task = await Task.findOneAndUpdate(
        { _id: req.params.id, userId: req.user._id }, // only user’s task
        req.body,
        { new: true } // the updated one will be saved in task
      );

      if (!task) return res.status(404).json({ error: "Task not found" });

      res.json(task);
    } catch (err) {
      res.status(400).json({ error: err.message });
    }
  };
}

function removeTask() {
  return async (req, res) => {
    try {
      const task = await Task.findOneAndDelete({
        _id: req.params.id,
        userId: req.user._id, // only user’s task
      });

      if (!task) return res.status(404).json({ error: "Task not found" });

      res.json({ message: "Task deleted successfully" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  };
}
export {
  createTask,
  getTasks,
  getTask,
  updateTask,
  removeTask,
  updateFav,
  getFav
};
