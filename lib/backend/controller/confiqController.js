import User from "../config/user.js";
import { genPassword, validatePassword } from "../passwordUtil.js";
import { issueJWT } from "../passwordUtil.js";
function createUser() {
  return async function (req, res) {
    try {
      const {nickname, email, password } = req.body;
      await User.init(); // ensures indexes are created
      const { salt, hash } = genPassword(password);
      const newUser = new User({ nickname, email, hash, salt });
      const user = await newUser.save();

      const jwtToken = issueJWT(user);

      // Respond
      res.json({
        success: true,
        user,
        token: jwtToken.token,
        expiresIn: jwtToken.expires,
      });
      console.log(user);
    } catch (err) {
      // Catch DB errors or other issues
      res.status(400).json({ success: false, msg: err.message });
      console.log("what");
    }
  };
}

function login() {
  return async function (req, res, next) {
    try {
      const user = await User.findOne({ email: req.body.email });
      if (!user) {
        return res
          .status(401)
          .json({ success: false, msg: "could not find user" });
      }

      const isValid = validatePassword(req.body.password, user.hash, user.salt);
      if (!isValid) {
        return res.status(401).json({ success: false, msg: "wrong password" });
      }

      const tokenObject = issueJWT(user);

      res.status(200).json({
        success: true,
        token: tokenObject.token,
        expiresIn: tokenObject.expires,
      });
      console.log(res);
    } catch (err) {
      next(err);
    }
  };
}

export { createUser, login };
