import { Router } from "express";
import { createUser, login } from "../controller/confiqController.js";
const router = Router();

router.post("/signup", createUser());
router.post("/login",login());
export default router;
