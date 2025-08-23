import crypto from "crypto";
import jsonwebtoken from "jsonwebtoken";
import { configDotenv } from "dotenv";
configDotenv();
function validatePassword(password, hash, salt) {
     let hashVerify = crypto
    .pbkdf2Sync(password, salt, 10000, 64, "sha512")
    .toString("hex");
    return hash == hashVerify;
}

function genPassword(password) {
  let salt = crypto.randomBytes(32).toString("hex");
  let genHash = crypto
    .pbkdf2Sync(password, salt, 10000, 64, "sha512")
    .toString("hex");
  return {
    salt: salt,
    hash: genHash,
  };
}

function issueJWT(user) {
  const _id = user._id;

  const expiresIn = '1y';

  const payload = {
    sub: _id,
    iat: Date.now() // issue at 
  };
  const signedToken = jsonwebtoken.sign(payload, process.env.JWT_SECRET, { expiresIn: expiresIn, algorithm: 'HS256' });

  return {
    token: "Bearer " + signedToken,
    expires: expiresIn
  }
}
export {validatePassword , genPassword,issueJWT};
